package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"unicode"

	"github.com/iancoleman/strcase"

	"github.com/jedib0t/go-pretty/v6/table"
	"github.com/jedib0t/go-pretty/v6/text"
	"gopkg.in/yaml.v2"
)

func toFunctionName(val string) (res string) {
	if val == "" {
		return
	}
	res = strcase.ToLowerCamel(val)
	if !unicode.IsLetter([]rune(res)[0]) {
		panic("do not provide name with non letter on its first character")
	}
	return
}

type atObj struct {
	Description string `json:"description,omitempty"`
}

type jsonDoc map[string]json.RawMessage

func (doc *jsonDoc) deleteValue(name string) {
	delete(*doc, name)
	delete(*doc, "@"+name)
}

func (doc *jsonDoc) getValue(name string) string {
	return string((*doc)[name])
}

func (doc *jsonDoc) getNames() (keys []string) {
	for k := range *doc {
		if k[0] == '@' {
			continue
		}
		keys = append(keys, k)
	}
	return
}

func (doc *jsonDoc) getDescription(name string) string {
	name = fmt.Sprintf("@%s", name)
	var extVal atObj
	obj := (*doc)[name]
	if obj != nil {
		if err := json.Unmarshal(obj, &extVal); err != nil {
			panic(err)
		}
	}
	return extVal.Description
}

func (doc *jsonDoc) updateValue(name string, val string) string {
	extVal := doc.getValue(name)

	var err error
	if (*doc)[name], err = json.Marshal(val); err != nil {
		panic(err)
	}

	return extVal
}

func (doc *jsonDoc) updateDescription(name string, desc string) string {
	extDesc := doc.getDescription(name)

	var err error
	if (*doc)["@"+name], err = json.Marshal(atObj{
		Description: desc,
	}); err != nil {
		panic(err)
	}

	return extDesc
}

type arbFile struct {
	path string
	id   string
}

func (file arbFile) doc() (obj jsonDoc) {
	data, err := os.ReadFile(file.path)
	if err != nil {
		panic(err)
	}

	json.Unmarshal(data, &obj)
	return
}

func (file arbFile) commit(doc jsonDoc) {
	val, err := json.MarshalIndent(doc, "", "\t")
	if err != nil {
		panic(err)
	}

	err = os.WriteFile(file.path, val, 0644)
	if err != nil {
		panic(err)
	}
}

type arbFiles []arbFile

func (files *arbFiles) getArbFileByID(id string) *arbFile {
	for _, file := range *files {
		if file.id == id {
			return &file
		}
	}
	return nil
}

func (files *arbFiles) remove(name string) {
	for _, v := range *files {
		doc := v.doc()
		doc.deleteValue(name)
		fmt.Printf("removing value => [%s]:%s [%s]\n", v.id, v.path, name)
		v.commit(doc)
	}
}

func (files *arbFiles) rename(name string, moveTo string) {
	for _, v := range *files {
		doc := v.doc()

		if move, ok := doc[name]; !ok || move == nil {
			panic("key not found")
		} else {
			doc[moveTo] = move
		}

		if move, ok := doc["@"+name]; ok {
			doc["@"+moveTo] = move
		}

		doc.deleteValue(name)

		fmt.Printf("moving name => [%s]:%s [%s:%s]\n", v.id, v.path, name, moveTo)
		v.commit(doc)
	}
}

func (files *arbFiles) process(id, name, val, desc string) {
	arb := files.getArbFileByID(id)
	doc := arb.doc()
	if val != "" {
		if ext := doc.updateValue(name, val); ext != "" {
			fmt.Printf("updating value => [%s]:%s [%s]:\"%s\":\"%s\"\n", arb.id, arb.path, name, ext, val)
		} else {
			fmt.Printf("creating value => [%s]:%s [%s]:\"%s\"\n", arb.id, arb.path, name, val)
		}
	}

	if desc != "" {
		if ext := doc.updateDescription(name, desc); ext != "" {
			fmt.Printf("updating description => [%s]:%s [%s]:\"%s\":\"%s\"\n", arb.id, arb.path, name, ext, desc)
		} else {
			fmt.Printf("creating description => [%s]:%s [%s]:\"%s\"\n", arb.id, arb.path, name, desc)
		}
	}

	arb.commit(doc)
}

func isFilenameMatchTemplate(filename, template string) (match bool, code string) {
	pattern := strings.ReplaceAll(regexp.QuoteMeta(template), `\*`, `(\w+)`)
	re := regexp.MustCompile("^" + pattern + "$")
	match = re.MatchString(filename)

	if match {
		submatches := re.FindStringSubmatch(filename)
		code = submatches[1]
	}

	return match, code
}

type l10nConfig struct {
	ArbDir          string `yaml:"arb-dir"`
	TemplateArbFile string `yaml:"template-arb-file"`
}

func (cfg l10nConfig) getTemplate() string {
	tmpl := strings.Replace(cfg.TemplateArbFile, "en", "*", 1)
	return fmt.Sprintf("%s/%s", cfg.ArbDir, tmpl)
}

func main() {
	cfgDir := flag.String("l10n_cfg", "./l10n.yaml", "set l10n .yaml config file")

	nameVal := flag.String("n", "", "set the name of value or index for update")
	enVal := flag.String("en", "", "set english locale value")
	idVal := flag.String("id", "", "set indonesia locale value")
	descVal := flag.String("d", "", "set description for value")
	doNotList := flag.Bool("nl", false, "don not list after process finished")
	isRemove := flag.Bool("r", false, "remove all value of the name given")
	move := flag.String("mv", "", "rename key of the value")
	verbose := flag.Bool("v", false, "verbose")

	flag.Parse()

	cfg := l10nConfig{
		ArbDir:          "lib/l10n",
		TemplateArbFile: "arb_en.arb",
	}

	if cfgDir != nil {
		cfgFile, err := os.ReadFile(*cfgDir)
		if err != nil {
			panic(err)
		}

		if err := yaml.Unmarshal(cfgFile, &cfg); err != nil {
			panic(err)
		}
	}

	cfg.TemplateArbFile = strings.Replace(cfg.TemplateArbFile, "en", "*", 1)

	var arbs arbFiles

	if err := filepath.Walk(cfg.ArbDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip directories
		if info.IsDir() {
			return nil
		}

		match, langCode := isFilenameMatchTemplate(path, cfg.getTemplate())
		if !match {
			return nil
		}

		// Create arbFile instance
		arb := arbFile{
			path: path,
			id:   langCode,
		}

		// Add arbFile instance to the slice
		arbs = append(arbs, arb)

		return nil
	}); err != nil {
		panic(err)
	}

	if i, err := strconv.Atoi(*nameVal); err == nil {
		doc := arbs.getArbFileByID("en").doc()
		names := doc.getNames()
		sort.Strings(names)
		*nameVal = names[i-1]
	}

	var generate = false

	if *move != "" {
		arbs.rename(*nameVal, toFunctionName(*move))
		nameVal = move
		generate = true
	}

	if env := *nameVal == ""; env && *enVal != "" {
		*nameVal = toFunctionName(*enVal)
	} else if env {
		arbs.list("")
		return
	}

	if *isRemove {
		arbs.remove(*nameVal)
		*nameVal = ""
		generate = true
	} else {
		if *enVal != "" || *descVal != "" {
			arbs.process("en", toFunctionName(*nameVal), *enVal, *descVal)
			generate = true
		}

		if *idVal != "" {
			arbs.process("id", toFunctionName(*nameVal), *idVal, "")
			generate = true
		}
	}

	if generate {
		if out := genl10n(); *verbose {
			fmt.Println(out)
		}
	}

	if !*doNotList {
		arbs.list(toFunctionName(*nameVal))
	}
}

func genl10n() string {
	cmd := exec.Command("make", "lang", "-s")
	stdout, err := cmd.CombinedOutput()
	if err != nil {
		if stdout != nil {
			return string(stdout)
		}
		panic(err.Error())
	}

	return string(stdout)
}

type strData struct {
	desc   string
	locale map[string]string
}

type strsData map[string]strData

func (data strsData) asTable(highlightedName string) {
	t := table.NewWriter()
	t.SetOutputMirror(os.Stdout)

	t.AppendHeader(table.Row{"#", "name", "locale:en", "locale:id", "desc"})
	t.SetStyle(table.StyleLight)

	keys := make([]string, 0, len(data))
	for k := range data {
		keys = append(keys, k)
	}

	sort.Strings(keys)

	for i, k := range keys {
		t.AppendRow(table.Row{
			i + 1, k, data[k].locale["en"], data[k].locale["id"], data[k].desc,
		})
	}

	t.SetRowPainter(func(row table.Row) text.Colors {
		if row[1] == highlightedName {
			return text.Colors{
				text.BgBlue,
				text.FgBlack,
			}
		}

		return text.Colors{
			text.FgBlack,
		}
	})

	// Render the table
	t.Render()
}

func (files *arbFiles) list(highlightedName string) {
	var strs strsData = make(strsData)

	for _, v := range *files {
		doc := v.doc()
		for _, name := range doc.getNames() {
			name = text.WrapHard(name, 25)

			desc := text.WrapSoft(doc.getDescription(name), 25)
			val := text.WrapHard(doc.getValue(name), 25)

			if ext, ok := strs[name]; ok {
				if ext.desc == "" {
					ext.desc = desc
				}

				ext.locale[v.id] = val
			} else {
				locale := make(map[string]string)

				locale[v.id] = val
				strs[name] = strData{
					desc:   desc,
					locale: locale,
				}
			}
		}
	}

	strs.asTable(highlightedName)
}
