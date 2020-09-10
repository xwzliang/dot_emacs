;;; python-docstring-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "python-docstring" "python-docstring.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from python-docstring.el

(autoload 'python-docstring-fill "python-docstring" "\
Wrap Python docstrings as epytext or ReStructured Text.

\(fn)" t nil)

(autoload 'python-docstring-mode "python-docstring" "\
Toggle python-docstring-mode.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

\(fn &optional ARG)" t nil)

(autoload 'python-docstring-install "python-docstring" "\
Add python-docstring-mode as a hook to python.mode.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "python-docstring" '("python-docstring-")))

;;;***

;;;### (autoloads nil nil ("python-docstring-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; python-docstring-autoloads.el ends here
