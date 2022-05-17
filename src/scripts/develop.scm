(define-module (src scripts develop)
  ;; #:use-module (ice-9 match)
  #:use-module (guix ui)
  #:use-module (guix scripts)
  #:export (guix-develop))

(define (show-help)
  (display (G_ "Usage: guix-develop
Activate a development environment.\n"))
  (newline)
  (show-bug-report-information))

(define-command (guix-develop . args)
  (category development)
  (synopsis "activate development environments")

  (with-error-handling
    ;; TODO
    (show-help)))
