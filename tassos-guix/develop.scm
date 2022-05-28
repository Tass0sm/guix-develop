(define-module (tassos-guix develop)
  #:use-module (guix packages)
  #:use-module (guix build-system)
  #:use-module (guix records)

  #:use-module (tassos-guix develop haskell)

  #:export (development-environment
            development-environment?
            this-development-environment

            development-environment-package
            development-environment-addons

            de->manifest))

(define-record-type* <development-environment> development-environment
  make-development-environment
  development-environment?
  this-development-environment

  (package       development-environment-package
                 (default #f))
  (addons        development-environment-addons
                 (default '())))

(define (development-environment-type de)
  (build-system-name
   (package-build-system
    (development-environment-package de))))

(define (de->manifest de)
  (let ((type (development-environment-type de))
        (pkg (development-environment-package de)))
    (case type
      ((haskell) (make-haskell-manifest pkg))
      (else (make-haskell-manifest pkg)))))
