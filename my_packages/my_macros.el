;;; my_macros.el --- my macros.

;;; Commentary:
;; my macros.


;;; Code:

(defun my-macro-fun-switch-to-journal-buffer ()
  (interactive)
  (setq last-command-event 13)
  (persp-switch-to-buffer "journal.org")
  (setq last-command-event 'f4))

(fset 'my_macro_org_copy_agenda_link_line_to_journal_checklist
   ;; (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([3 111 108 27 106 97 3 12 13 13 27 13 escape 27 107 106] 0 "%d")) arg)))
   ;; Use (byte-to-string int) to translate
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("oljaxevil-normal-statekj" 0 "%d")) arg)))

(fset 'my_macro_copy_all_agenda_items_link_to_journal
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("xhelm-modeoaaglocjk*xfmy_macro_org_copy_agenda_link_line_to_journal_checklistjddxmy-macro-fun-switch-to-journal-bufferxflip-framexhelm-mode" 0 "%d")) arg)))

(fset 'my_macro_close_checklist_item_and_linked_todo_item
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("dkj" 0 "%d")) arg)))

(fset 'my_macro_save_html_and_url
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("xhelm-modexfind-file-other-window~/pipes/zotero/linked_urldGkPjp;xxfind-file-other-window~/pipes/zotero/amazon_book.htmldGk\\gyGjp;x\\xhelm-mode" 0 "%d")) arg)))

(fset 'my_macro_org_resolve_clock
   "0f[dt[f]ld$\C-coksJ")


(provide 'my_macros)
;;; my_macros.el ends here
