(define-module (src develop haskell)
  ;; #:use-module (gnu home services symlink-manager)
  ;; #:use-module (gnu home services shells)
  ;; #:use-module (gnu home services xdg)
  ;; #:use-module (gnu home services fontutils)
  ;; #:use-module (gnu services)
  ;; #:use-module (guix diagnostics)
  ;; #:use-module (guix gexp)
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

(define (make-haskell-manifest pkg)
  (manifest-add
   (package->development-manifest pkg)
   (list (package->manifest-entry cabal-wrapper))))
