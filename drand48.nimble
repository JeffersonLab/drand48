# Package

version       = "1.0.1"
author        = "Robert Edwards"
description   = "Nim implementation of standard unix drand48 random number generator"
license       = "BSD clause 3"

# Dependencies

requires "nim >= 0.17.0"

# Builds
task test, "Run the test suite":
  exec "nim c -r drand48"

task docgen, "Generate the documentation":
  exec "nim doc2 --out:docs/drand48.html drand48.nim"

