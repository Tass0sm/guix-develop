(use-modules (src develop)
             (src utils)
             (gnu packages compression)
             (gnu packages haskell-xyz)
             (gnu packages haskell-apps)
             (guix gexp)
             (guix modules)
             (guix profiles)
             (guix packages)
             (guix git-download)
             (guix build-system copy)
             (guix build-system trivial)
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
    (native-inputs (list zlib))
    (inputs (list ghc-pandoc
                  ghc-pandoc-types))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:gpl3+)))

(make-dev-manifest
 (development-environment
  (package ghc-graphdoc)))
