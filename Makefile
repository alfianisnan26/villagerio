export WEB_RENDERER := "canvaskit"
export FLUTTER_PATH := "/Users/alfian.isnan/Downloads/flutter/bin"
export ENV := $(ENV)
export PATH := $(FLUTTER_PATH):$(PATH)
export CHANNEL := $(CHANNEL)
export L10N_CFG_FILE := "./l10n.yaml"
export PUBSPEC_PATH := "./pubspec.yaml"

build:
	@echo "Building flutter web app with $(WEB_RENDERER) web renderer"
	@flutter build web --web-renderer=$(WEB_RENDERER)

clean:
	@flutter clean
	@flutter packages get
	@flutter packages upgrade

build_minor:
	@./scripts/build-version -l minor -pubspec $(PUBSPEC_PATH)
	@make build
build_major:
	@./scripts/build-version -l major -pubspec $(PUBSPEC_PATH)
	@make build
build_version:
	@./scripts/build-version -l version -pubspec $(PUBSPEC_PATH)
	@make build

deploy_only: build
	@echo "Deploying to firebase hosting with $(ENV) environment"
	@firebase deploy --only hosting
	
deploy_minor:
	@./scripts/build-version -l minor -pubspec $(PUBSPEC_PATH)
	@make deploy_only
deploy_major: deploy_only
	@./scripts/build-version -l major -pubspec $(PUBSPEC_PATH)
	@make deploy_only
deploy_version: deploy_only
	@./scripts/build-version -l version -pubspec $(PUBSPEC_PATH)
	@make deploy_only

deploy: deploy_minor

deploy_hard: 
	@make clean
	@make deploy_minor

pre-deploy:
	@echo "Pre-deployment process"

lang:
	@flutter gen-l10n

splash:
	@dart run flutter_native_splash:create --path=./flutter_native_splash.yaml

str:
	@go build ./scripts/make_str/make-str.go
	@mv ./make-str ./scripts

version:
	@go build ./scripts/build_version/build-version.go
	@mv ./build-version ./scripts

.PHONY: build