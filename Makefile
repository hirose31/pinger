
SOURCES = $(shell echo *.go)
DEBUG_ASSETS := -debug=true
VERSION = $(shell grep '^const Version' version.go | sed -E 's/.*"([^"]+)"$$/\1/')

BUILD_OPTS = -ldflags="-s -w"
DIST := dist

all:
	@echo blah $(VERSION)

# for test
pinger: $(SOURCES)
	go build -tags=linux $(BUILD_OPTS) -o $@
	# upx $@
	sudo chown root $@
	sudo chmod 4755 $@

build:
	gox $(BUILD_OPTS) -osarch "linux/amd64 darwin/amd64 windows/amd64 windows/386" -output "$(DIST)/$(VERSION)/pinger-$(VERSION)_{{.OS}}_{{.Arch}}/pinger"
	# @for bin in $(DIST)/$(VERSION)/pinger-$(VERSION)_*/pinger; do \
	#   upx $${bin}; \
	# done

package: build
	-@mkdir $(DIST)/$(VERSION)/pkg 2>/dev/null
	@cd $(DIST)/$(VERSION) && for pkg in pinger-$(VERSION)_*; do \
	  echo $${pkg}; \
	  zip pkg/$${pkg}.zip $${pkg}/*; \
	done

release:
	$(MAKE) package
	@env ghr -u hirose31 --replace $(VERSION) $(DIST)/$(VERSION)/pkg/

clean:
	$(RM) *~ pinger
