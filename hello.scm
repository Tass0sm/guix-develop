#!/usr/bin/env -S guile -L "/home/tassos/software/guix/" -L . -s
!#

(use-modules (src develop)
             (guix gexp)
             (guix packages)
             (guix git-download)
             (guix build-system haskell)
             ((guix licenses) #:prefix license:))

(define %source-dir
  "/home/tassos/software/haskell/graphdoc/")

(define ghc-graphdoc
  (package
   (name "ghc-graphdoc")
   (version "0.0.1")
   (source
    (local-file %source-dir
                #:recursive? #t
                #:select? (git-predicate %source-dir)))
   (build-system haskell-build-system)
   (inputs '())
   (home-page "")
   (synopsis "")
   (description "")
   (license license:gpl3+)))

(hello-func)
