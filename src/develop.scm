(define-module (src develop)
  #:use-module (guix packages)
  #:use-module (guix build-system)
  #:use-module (guix records)

  #:use-module (src develop haskell)

  #:export (development-environment
            development-environment?
            this-development-environment

            development-environment-package
            development-environment-addons

            make-dev-manifest))

(define-record-type* <development-environment> development-environment
  make-development-environment
  development-environment?
  this-development-environment

  (package       development-environment-package
                 (default #f))
  (addons        development-environment-addons
                 (default '())))

(define (development-environmnet-type de)
  (build-system-name
   (package-build-system
    (development-environment-package de))))

(define (make-dev-manifest de)
  (let ((type (development-environmnet-type de))
        (pkg (development-environment-package de)))
    (case type
      (("haskell") (make-haskell-manifest pkg))
      (else (make-haskell-manifest pkg)))))
