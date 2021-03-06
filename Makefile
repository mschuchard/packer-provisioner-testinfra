.PHONY: build

build:
	@go build -o packer-provisioner-testinfra

unit:
	@go test -v

acceptance: build
	@mkdir -p ~/.packer.d/plugins/
	@mv packer-provisioner-testinfra ~/.packer.d/plugins/packer-provisioner-testinfra
	# go test with acceptance tests set to true

install-packer-sdc:
	@go install github.com/hashicorp/packer-plugin-sdk/cmd/packer-sdc@latest

#release-docs: install-packer-sdc
#	@packer-sdc renderdocs -src docs -partials docs-partials/ -dst docs/
#	@/bin/sh -c "[ -d docs ] && zip -r docs.zip docs/"

plugin-check: install-packer-sdc build
	@packer-sdc plugin-check packer-provisioner-testinfra

generate: install-packer-sdc
	export PATH="${PATH}:$(go env GOPATH)/bin"
	@go generate ./...
	#packer-sdc renderdocs -src ./docs -dst ./.docs -partials ./docs-partials

test: unit acceptance plugin-check
