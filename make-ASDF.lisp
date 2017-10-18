#-eql5
(error "Please use the EQL5 executable (see README)")

(require :cmp)

(load "dependencies")
(load "tr")

(push "./" asdf:*central-registry*)

(asdf::make-build "stochos-embed"
                 :monolithic t
                 :type :static-library
                 :move-here "./")

(let ((lib-name #+msvc "stochos_embed_lib.lib"
                #-msvc "libstochos_embed.a"))
  (when (probe-file lib-name)
    (delete-file lib-name))
  (rename-file (x:cc "stochos-embed--all-systems"
                      #+msvc ".lib"
                      #-msvc ".a")
               lib-name))
