BIBER_BINARY := biber
BIBER_ARCHIVE := biber-linux_aarch64.tar.gz
OTHER_BINARIES := biblex bibparse dumpnames

.PHONY: all image biber test test-image clean upload package

all: test

image:
	docker build $(CACHE_OPTION) -f Dockerfile.build --tag sbrass/biber-aarch64 .

$(BIBER_BINARY): image
	docker run --rm -v $(PWD):/opt sbrass/biber-aarch64 $(BRANCH) $(REPO)

test-image:
	docker build $(CACHE_OPTION) -f Dockerfile.test --tag sbrass/biber-test .

test: $(BIBER_BINARY) test-image
	docker run --rm -v $(PWD):/opt sbrass/biber-test $(BRANCH) $(REPO)

clean:
	rm -f $(BIBER_BINARY) $(BIBER_ARCHIVE) $(OTHER_BINARIES)

package: $(BIBER_ARCHIVE)

$(BIBER_ARCHIVE): $(BIBER_BINARY)
	tar czf $(BIBER_ARCHIVE) $^
