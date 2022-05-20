(use-modules (src develop)
             (src utils)
             (guix gexp)
             (guix modules)
             (guix profiles)
             (guix packages)
             (guix git-download)
             (guix build-system haskell)
             ((guix licenses) #:prefix license:)
             (gnu packages haskell-xyz))

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
    (inputs (list ghc-pandoc
                  ghc-pandoc-types))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:gpl3+)))

(make-dev-manifest
 (development-environment
  (package ghc-graphdoc)))
