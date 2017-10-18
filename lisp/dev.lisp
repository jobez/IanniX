(time (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                             (user-homedir-pathname))))
        (when (probe-file quicklisp-init)
          (load quicklisp-init))))

(in-package :eql)
(setf eql:*qtpl* nil)

(defun load-repl ()
  (qload
   (asdf/system:system-relative-pathname :swank "eql-start-swank.lisp")))

(load-repl)
