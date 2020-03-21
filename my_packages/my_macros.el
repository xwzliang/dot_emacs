;;; my_macros.el --- my macros.

;;; Commentary:
;; my macros.


;;; Code:
(fset 'my_macro_org_copy_agenda_link_line_to_journal_checklist
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([3 111 108 27 106 97 3 12 13 13 27 13 escape 27 107 106] 0 "%d")) arg)))

(fset 'my_macro_copy_all_agenda_items_link_to_journal
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("xhelm-mode

(fset 'my_macro_close_checklist_item_and_linked_todo_item
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("d" 0 "%d")) arg)))

(fset 'my_macro_save_html_and_url
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("xhelm-mode



(provide 'my_macros)
;;; my_macros.el ends here