(defsystem :stochos-embed
  :serial t
  :depends-on (:alexandria)
  :components ((:file "package")
               (:file "lisp/main")))
