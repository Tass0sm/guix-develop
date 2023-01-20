(define-module (tassos-guix build-system wrapper)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix search-paths)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:export (%copy-build-system-modules
            default-glibc
            lower
            wrapper-build
            wrapper-build-system))

;; Commentary:
;;
;; Standard build procedure for simple packages that don't require much
;; compilation, mostly just copying files around.  This is implemented as an
;; extension of `gnu-build-system'.
;;
;; Code:
