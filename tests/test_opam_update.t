Create a simple dune project: testing if opam-dune-lint update opam files
using the dune-project file, before the linting process.

  $ cat > dune-project << EOF
  > (lang dune 2.7)
  > (generate_opam_files true)
  > (package
  >  (name test)
  >  (synopsis "Test package")
  >  (depends cmdliner))
  > EOF

  $ cat > dune << EOF
  > (executable
  >  (name main)
  >  (public_name main)
  >  (modules main)
  >  (libraries findlib fmt))
  > (test
  >  (name test)
  >  (modules test)
  >  (libraries bos opam-state))
  > EOF

  $ touch main.ml test.ml
  $ dune build
  $ cat test.opam
  # This file is generated by dune, edit dune-project instead
  opam-version: "2.0"
  synopsis: "Test package"
  depends: [
    "dune" {>= "2.7"}
    "cmdliner"
    "odoc" {with-doc}
  ]
  build: [
    ["dune" "subst"] {dev}
    [
      "dune"
      "build"
      "-p"
      name
      "-j"
      jobs
      "@install"
      "@runtest" {with-test}
      "@doc" {with-doc}
    ]
  ]

Replace all version numbers with "1.0" to get predictable output.

  $ export OPAM_DUNE_LINT_TESTS=y

Check that the missing libraries get added:

  $ opam-dune-lint -f
  test.opam: changes needed:
    "fmt" {>= "1.0"}                         [from /]
    "ocamlfind" {>= "1.0"}                   [from /]
    "bos" {with-test & >= "1.0"}             [from /]
    "opam-state" {with-test & >= "1.0"}      [from /]
  Note: version numbers are just suggestions based on the currently installed version.
  Wrote "dune-project"

  $ cat test.opam | sed 's/= [^&)}]*/= */g'
  # This file is generated by dune, edit dune-project instead
  opam-version: "2.0"
  synopsis: "Test package"
  depends: [
    "dune" {>= *}
    "opam-state" {>= *& with-test}
    "bos" {>= *& with-test}
    "ocamlfind" {>= *}
    "fmt" {>= *}
    "cmdliner"
    "odoc" {with-doc}
  ]
  build: [
    ["dune" "subst"] {dev}
    [
      "dune"
      "build"
      "-p"
      name
      "-j"
      jobs
      "@install"
      "@runtest" {with-test}
      "@doc" {with-doc}
    ]
  ]
