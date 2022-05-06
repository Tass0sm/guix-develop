(define-module (src utils)
  #:use-module (srfi srfi-1)
  #:use-module (guix build utils)
  #:export (unlines
            generic-wrap-program))

(define* (unlines #:rest lines)
  (reduce-right string-append ""
                (map (lambda (l) (string-append l "\n"))
                     lines)))

(define* (generic-wrap-program prog script-content)
  "Make a wrapper script for PROG. SCRIPT-CONTENT is the wrapper script content.

For example, this command:

  (wrap-program \"cabal\"
                (unlines '(\"#!/usr/bin/bash\"
                           \"TEMP=$GHC_PACKAGE_PATH\"
                           \"unset GHC_PACKAGE_PATH\"
                           \"exec -a $0 ~a -V\"
                           \"GHC_PACKAGE_PATH=$TEMP\"
                           \"unset TEMP\")))

will copy 'cabal' to '.cabal-real' and create the file 'cabal' with the following
contents:

  #!/usr/bin/bash
  TEMP=$GHC_PACKAGE_PATH
  unset GHC_PACKAGE_PATH
  exec -a $0 location/of/.cabal-real -V
  GHC_PACKAGE_PATH=$TEMP
  unset TEMP

Work in progress."
  (define wrapped-file
    (string-append (dirname prog) "/." (basename prog) "-real"))

  (define already-wrapped?
    (file-exists? wrapped-file))

  (when (wrapped-program? prog)
    (error (string-append prog " is a wrapper. Refusing to wrap.")))

  (if already-wrapped?

      ;; PROG is already a wrapper. I'm not sure what to do, so I quit.
      (error (string-append prog " has already been wrapped. Refusing to wrap."))

      ;; PROG is not wrapped yet: create a shell script that sets VARS.
      (let ((prog-tmp (string-append wrapped-file "-tmp")))
        ;; Create a link to the real program.
        (link prog wrapped-file)

        (call-with-output-file prog-tmp
          (lambda (port)
            (format port
                    script-content
                    (canonicalize-path wrapped-file))))

        (chmod prog-tmp #o755)
        (rename-file prog-tmp prog))))
