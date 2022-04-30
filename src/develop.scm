(define-module (src develop)
  ;; #:use-module (gnu home services)
  ;; #:use-module (gnu home services symlink-manager)
  ;; #:use-module (gnu home services shells)
  ;; #:use-module (gnu home services xdg)
  ;; #:use-module (gnu home services fontutils)
  ;; #:use-module (gnu services)
  #:use-module (guix records)
  ;; #:use-module (guix diagnostics)
  ;; #:use-module (guix gexp)
  ;; #:use-module (guix store)

  #:export (development-environment
            development-environment?
            this-development-environment

            development-environment-packages

            hello-func))

(define-record-type* <development-environment> development-environment
  make-development-environment
  development-environment?
  this-development-environment

  ;; list of (PACKAGE OUTPUT...)
  (packages           development-environment-packages
                      (default '())))

(define (hello-func)
  (display "Hello, world!")
  (newline))
