package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"gopkg.in/yaml.v2"
)

type yamlMapSlice yaml.MapSlice

func (ym *yamlMapSlice) marshal() ([]byte, error) {
	return yaml.Marshal(ym)
}

func (ym *yamlMapSlice) get(key string) interface{} {
	for _, v := range *ym {
		if fmt.Sprint(v.Key) == key {
			return v.Value
		}
	}

	return nil
}

func (ym *yamlMapSlice) set(key string, val interface{}) {
	for i, v := range *ym {
		if fmt.Sprint(v.Key) == key {
			v.Value = val
			(*ym)[i] = v
		}
	}
}

type packageInfo struct {
	build   uint64
	minor   uint64
	major   uint64
	version uint64
}

func (pi packageInfo) String() string {
	return fmt.Sprintf("%d.%d.%d+%d", pi.version, pi.major, pi.minor, pi.build)
}

var _ fmt.Stringer = packageInfo{}

func packageInfoFromString(val string) packageInfo {
	packageInfoObj := strings.Split(val, "+")
	versionInfoObj := strings.Split(packageInfoObj[0], ".")
	build, err := strconv.ParseUint(packageInfoObj[1], 10, 64)
	if err != nil {
		panic(err)
	}
	minor, err := strconv.ParseUint(versionInfoObj[2], 10, 64)
	if err != nil {
		panic(err)
	}
	major, err := strconv.ParseUint(versionInfoObj[1], 10, 64)
	if err != nil {
		panic(err)
	}
	version, err := strconv.ParseUint(versionInfoObj[0], 10, 64)
	if err != nil {
		panic(err)
	}
	return packageInfo{
		build:   build,
		minor:   minor,
		major:   major,
		version: version,
	}
}

func main() {
	level := flag.String("l", "minor", "set update version [minor | major | version]")
	pubspecPath := flag.String("pubspec", "./pubspec.yaml", "set pubspec path")

	flag.Parse()

	pubspecData, err := os.ReadFile(*pubspecPath)
	if err != nil {
		panic(err)
	}

	var pubspecYaml yamlMapSlice

	yaml.Unmarshal(pubspecData, &pubspecYaml)

	val := fmt.Sprint(pubspecYaml.get("version"))

	packageInfoObj := packageInfoFromString(val)

	switch *level {
	case "minor":
		packageInfoObj.minor++
	case "major":
		packageInfoObj.minor = 0
		packageInfoObj.major++
	case "version":
		packageInfoObj.minor = 0
		packageInfoObj.major = 0
		packageInfoObj.version++
	}

	packageInfoObj.build, err = strconv.ParseUint(time.Now().Format("060102"), 10, 64)
	if err != nil {
		panic(err)
	}

	pubspecYaml.set("version", packageInfoObj.String())
	fmt.Printf("version %s\n", packageInfoObj)
	data, err := pubspecYaml.marshal()
	if err != nil {
		panic(err)
	}
	if err := os.WriteFile(*pubspecPath, data, 0644); err != nil {
		panic(err)
	}
}
