#!/usr/bin/env -S guile -L /gnu/store/7k6iiqj95x648plx1fw9qqr9ix1b1f2l-guix-module-union/share/guile/site/3.0 -s
!#

(use-modules (guix build haskell-build-system)
             (guix build utils)
             (srfi srfi-1)
             (srfi srfi-26))

(let ((ghc-path (getenv "GHC_PACKAGE_PATH"))
      (raw-args (cdr (command-line))))
  (unsetenv "GHC_PACKAGE_PATH")

  (apply invoke `("cabal" ,@raw-args))

  (setenv "GHC_PACKAGE_PATH" ghc-path))
