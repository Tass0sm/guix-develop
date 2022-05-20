#!/usr/bin/env -S guix repl -L /home/tassos/software/guile/guix-develop --
!#

(use-modules (src scripts develop))

(let ((args (command-line)))
  (apply guix-develop args))
