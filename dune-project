(lang dune 3.12)

(name calfeine)

(generate_opam_files true)

(source
 (github samhuckaby/calfeine))

(authors "Sam Huckaby")

(maintainers "Sam Huckaby")

(license MIT)

(package
 (name calfeine)
 (synopsis "A simple OCaml web server with file whitelisting")
 (description "An nginx-like web server that serves files based on a whitelist in files.site")
 (depends
  ocaml
  dune
  (eio (>= 1.0))
  (eio_main (>= 1.0))
  (cohttp-eio (>= 6.0))
  (uri (>= 4.0))
  (http (>= 6.0))))
