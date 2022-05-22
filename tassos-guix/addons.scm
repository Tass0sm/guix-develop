(define-module (tassos-guix addons)
  #:use-module (guix gexp))

(define-record-type* <addon-type> addon-type make-addon-type
  addon-type?
  (name       addon-type-name)                  ;symbol (for debugging)

  ;; Things extended by addons of this type.
  (extensions addon-type-extensions)            ;list of <addon-extensions>

  ;; Given a list of extensions, "compose" them.
  (compose    addon-type-compose                ;list of Any -> Any
              (default #f))

  ;; Extend the addons' own parameters with the extension composition.
  (extend     addon-type-extend                 ;list of Any -> parameters
              (default #f))

  ;; Optional default value for instances of this type.
  (default-value addon-type-default-value       ;Any
                 (default &no-default-value))

  ;; Meta-data.
  (description  addon-type-description          ;string
                (default #f))
  (location     addon-type-location             ;<location>
                (default (and=> (current-source-location)
                                source-properties->location))
                (innate)))
