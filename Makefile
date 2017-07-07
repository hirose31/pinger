
SOURCES = $(shell echo *.go)
DEBUG_ASSETS := -debug=true
VERSION = $(shell grep '^const Version' version.go | sed -E 's/.*"([^"]+)"$$/\1/')

BUILD_OPTS = -ldflags="-s -w"


all:
	@echo blah $(VERSION)

# for test
pinger: $(SOURCES)
	go build -tags=linux $(BUILD_OPTS) -o $@
	# upx $@
	sudo chown root $@
	sudo chmod 4755 $@

build:
	gox $(BUILD_OPTS) -osarch "linux/amd64 darwin/amd64" -output "dist/$(VERSION)/pinger-$(VERSION)_{{.OS}}_{{.Arch}}/pinger"
	# @for bin in dist/$(VERSION)/pinger-$(VERSION)_*/pinger; do \
	#   upx $${bin}; \
	# done

package: build
	-@mkdir dist/$(VERSION)/pkg 2>/dev/null
	@cd dist/$(VERSION) && for pkg in pinger-$(VERSION)_*; do \
	  echo $${pkg}; \
	  zip pkg/$${pkg}.zip $${pkg}/*; \
	done

release:
	$(MAKE) package
	@env ghr -u hirose31 --replace $(VERSION) dist/$(VERSION)/pkg/

clean:
	$(RM) *~ pinger
