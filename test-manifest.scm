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

(define cabal-wrapper
  (package
    (name "cabal-wrapper")
    (version "0.0.1")
    (source (local-file "./cabal-wrapper.scm"))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       '(("cabal-wrapper.scm" "bin/cabal-wrapper"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'chmod
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (result (string-append out "/bin/cabal-wrapper")))
               (chmod result #o555)))))))
    (propagated-inputs
     (list cabal-install))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:gpl3+)))

(manifest-add
 (package->development-manifest ghc-graphdoc)
 (list (package->manifest-entry cabal-wrapper)))
