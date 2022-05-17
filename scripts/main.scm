#!/usr/bin/env -S guile --no-auto-compile -L /gnu/store/7k6iiqj95x648plx1fw9qqr9ix1b1f2l-guix-module-union/share/guile/site/3.0 -L /home/tassos/software/guile/guix-develop -e main -s
!#

(use-modules (src scripts develop))

(define* (main #:optional (args (command-line)))
  (apply guix-develop args))
