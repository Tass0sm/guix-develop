(define-module (tassos-guix develop clojure)
  #:use-module (gnu packages clojure)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (guix profiles)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system clojure)
  #:use-module ((guix licenses) #:prefix license:)

  #:export (make-clojure-manifest))

(define (make-clojure-manifest pkg)
  (manifest-add
   (package->development-manifest pkg)
   (map package->manifest-entry (list clojure-tools))))
