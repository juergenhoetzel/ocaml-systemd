
PROFILE=release

build:
	dune build --profile=$(PROFILE)

doc:
	dune build @doc

test:
	dune runtest

install:
	dune install

uninstall: setup.data
	dune uninstall

clean:
	dune clean

.PHONY: build doc test all install uninstall reinstall clean distclean configure
