(define-module (tassos-guix develop haskell)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages haskell-apps)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (guix profiles)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system trivial)
  #:use-module (guix build-system haskell)
  #:use-module ((guix licenses) #:prefix license:)

  #:export (make-haskell-manifest))

(define cabal-wrapper-script
  (program-file "cabal-wrapper.scm"
                #~(let ((ghc-path (getenv "GHC_PACKAGE_PATH"))
                        (raw-args (cdr (command-line))))
                    (unsetenv "GHC_PACKAGE_PATH")
                    (apply execl `(#$(file-append cabal-install "/bin/cabal") "cabal" ,@raw-args))
                    (setenv "GHC_PACKAGE_PATH" ghc-path))))

(define cabal-install-wrapper
  (package
    (name "cabal-install-wrapper")
    (version "0.0.1")
    (source cabal-wrapper-script)
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       '(("cabal-wrapper.scm" "bin/cabal"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'chmod
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (result (string-append out "/bin/cabal")))
               (chmod result #o555)))))))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:gpl3+)))

(define (make-haskell-manifest pkg)
  (manifest-add
   (package->development-manifest pkg)
   (map package->manifest-entry (list cabal-install-wrapper
                                      zlib))))
