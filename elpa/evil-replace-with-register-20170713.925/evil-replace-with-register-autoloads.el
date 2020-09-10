;;; evil-replace-with-register-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "evil-replace-with-register" "evil-replace-with-register.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from evil-replace-with-register.el

(autoload 'evil-replace-with-register "evil-replace-with-register" "\
Replacing an existing text with the contents of a register" t)

(autoload 'evil-replace-with-register-install "evil-replace-with-register" "\
Setting evil-replace-with-register key bindings.

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "evil-replace-with-register" '("evil-replace-with-register-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evil-replace-with-register-autoloads.el ends here
