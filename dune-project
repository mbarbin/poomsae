(lang dune 3.14)

(name poomsae)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/poomsae))

(documentation "https://mbarbin.github.io/poomsae/")

(package
 (name poomsae)
 (synopsis "Studying some Taekwondo poomsae")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))
  (stdio
   (and
    (>= v0.16)
    (< v0.17)))
  (textutils
   (and
    (>= v0.16)
    (< v0.17)))))
