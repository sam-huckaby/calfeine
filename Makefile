.PHONY: build install clean run dev

build:
	dune build

install:
	opam install . --deps-only
	dune install

clean:
	dune clean

run:
	dune exec calfeine

dev:
	dune exec calfeine -- -p 8080
