#!/usr/bin/env -S guile -s
!#

(use-modules (guix build haskell-build-system)
             (guix build utils)
             (srfi srfi-1)
             (srfi srfi-26))

(define %system "x86_64-linux")

(define %inputs
  '(("haskell" . "/gnu/store/wbz6vkiz7cq8c531xvb31lxm28nz332i-ghc-8.10.7")
    ("source" . "/gnu/store/iwhhzk6qhifabnqrl4qfzq67xkavz314-graphdoc")
    ("ghc-pandoc" . "/gnu/store/p33al1k62g6gxnlrn4w6hdilnhj99n4l-ghc-pandoc-2.14.0.3")
    ("ghc-pandoc-types" . "/gnu/store/11wwng6062vkcabbbqk73gr35zjf106p-ghc-pandoc-types-1.22.1")
    ("tar" . "/gnu/store/g2ajyl8xk9aarxrgjbng2hkj3qm2v0z2-tar-1.34")
    ("gzip" . "/gnu/store/iixwcv3k49ks1rf34pjgfzmzyhhgwng3-gzip-1.10")
    ("bzip2" . "/gnu/store/s3hl12jxz9ybs7nsy7kq7ybzz7qnzmsg-bzip2-1.0.8")
    ("xz" . "/gnu/store/c8isj4jq6knv0icfgr43di6q3nvdzkx7-xz-5.2.5")
    ("file" . "/gnu/store/4ic6244i3ca4b4rxc2wnrgllsidyishv-file-5.39")
    ("diffutils" . "/gnu/store/ahmmvw21p11ik80lg1f953y7fd8bqkjm-diffutils-3.8")
    ("patch" . "/gnu/store/z39hnrwds1dgcbpfgj8dnv2cngjb2xbl-patch-2.7.6")
    ("findutils" . "/gnu/store/39rsx3nl4c31952jybbjb8d6idr5hx7r-findutils-4.8.0")
    ("gawk" . "/gnu/store/690qz3fg334dpwn3pn6k59n4wc943p2b-gawk-5.1.0")
    ("sed" . "/gnu/store/wxgv6i8g0p24q5gcyzd0yr07s8kn9680-sed-4.8")
    ("grep" . "/gnu/store/xjwp2hsd9256icjjybfrmznppjicywf6-grep-3.6")
    ("coreutils" . "/gnu/store/d251rfgc9nm2clzffzhgiipdvfvzkvwi-coreutils-8.32")
    ("make" . "/gnu/store/55cbpsi18mahg131nmiya6km5b4mscfa-make-4.3")
    ("bash" . "/gnu/store/4y5m9lb8k3qkb1y9m02sw9w9a6hacd16-bash-minimal-5.1.8")
    ("ld-wrapper" . "/gnu/store/s2pg5k98fl2g2szg9dykxyd9zl3xihv9-ld-wrapper-0")
    ("binutils" . "/gnu/store/rc781v4k0drhaqn90xfwwpspki5x0bvf-binutils-2.37")
    ("gcc" . "/gnu/store/069aq2v993kpc41yabp5b6vm4wb9jkhg-gcc-10.3.0")
    ("libc" . "/gnu/store/5h2w4qi9hk1qzzgi1w83220ydslinr4s-glibc-2.33")
    ("libc:static" . "/gnu/store/4jdghmc65q7i7ib89zmvq66l0ghf7jc4-glibc-2.33-static")
    ("locales" . "/gnu/store/fnr1z6xsan0437r0yg48d0y8k32kqxby-glibc-utf8-locales-2.33")
    ("kernel-headers" . "/gnu/store/6mjww4iz4xdan74d5bbjfh7il8rngfkk-linux-libre-headers-5.10.35")))

(define %outputs
  '("out"))

(define %tmp-db-dir
  (string-append (or (getenv "TMP") "/tmp")
                 "/package.conf.d"))

(define (make-ghc-package-database system inputs outputs)
  "Generate the GHC package database."
  (let* ((haskell  (assoc-ref inputs "haskell"))
         (name-version (strip-store-file-name haskell))
         ;; Silence 'find-files' (see 'evaluate-search-paths')
         (conf-dirs (search-path-as-string->list
                     "/gnu/store/i2fxm64abvpfzpkffkz71cwffnbq63nw-profile/lib/ghc-8.10.7/ghc-pandoc-2.14.0.3.conf.d:/gnu/store/i2fxm64abvpfzpkffkz71cwffnbq63nw-profile/lib/ghc-8.10.7/ghc-pandoc-types-1.22.1.conf.d:/gnu/store/i2fxm64abvpfzpkffkz71cwffnbq63nw-profile/lib/ghc-8.10.7/package.conf.d"))
         (conf-files (append-map (cut find-files <> "\\.conf$") conf-dirs)))
    (mkdir-p %tmp-db-dir)
    (for-each (lambda (file)
                (let ((dest (string-append %tmp-db-dir "/" (basename file))))
                  (unless (file-exists? dest)
                    (copy-file file dest))))
              conf-files)
    (invoke "ghc-pkg"
            (string-append "--package-db=" %tmp-db-dir)
            "recache")
    #t))

(let* ((haskell (assoc-ref %inputs "haskell"))
       (name-version (strip-store-file-name haskell)))
  (cond
   ((string-match "ghc" name-version)
    (make-ghc-package-database %system %inputs %outputs))
   (else
    (format #t
            "Compiler ~a not supported~%" name-version))))
