(use-modules (src develop)
             (src utils)
             (gnu packages haskell-xyz)
             (gnu packages haskell-apps)
             (guix gexp)
             (guix modules)
             (guix profiles)
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
   (inputs (list ghc-pandoc
                 ghc-pandoc-types))
   (home-page "")
   (synopsis "")
   (description "")
   (license license:gpl3+)))

(define wrapped-cabal-install
  (package
    (inherit cabal-install)
    (arguments
     `(#:imported-modules
       ((src utils) ,@%haskell-build-system-modules)
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'update-constraints
           (lambda _
             (display %load-path)
             (newline)
             (substitute* "cabal-install.cabal"
               (("(base|base16-bytestring|random)\\s+[^,]+" all dep)
                dep))))
         (add-after 'install 'wrap-cabal
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (use-modules (src utils))
             (generic-wrap-program (search-input-file outputs "bin/cabal")
                                   (unlines (string-append "#!" (which "bash"))
                                            "exec -a $0 ~a \"$@\"")))))))))

(manifest-add
 (package->development-manifest ghc-graphdoc)
 (list (package->manifest-entry wrapped-cabal-install)))
