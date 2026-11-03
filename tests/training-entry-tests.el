(require 'ert)
(require 'org)
(require 'cl-lib)
;; Load only the training functions, without starting the full init.
(let ((init (expand-file-name "../init.el" (file-name-directory load-file-name))))
  (with-temp-buffer
    (insert-file-contents init)
    (goto-char (point-min))
    (search-forward "(defun my/org-training--ensure-heading")
    (goto-char (match-beginning 0))
    (eval (read (current-buffer)) t)
    (eval (read (current-buffer)) t)
    (eval (read (current-buffer)) t)))
(defconst training-source "* Daily Training Journal\n:PROPERTIES:\n:ID: keep-me\n:END:\n\n** 2026\n\n*** 2026-09\n\n| Date | Day | Exercise | Type | Set | Reps |\n|------+-----+----------+------+-----+------|\n| 2026-09-24 | Thu | Leg Raises | warm up | Knee Raises | 2x10 |\n| 2026-09-24 | | | work set | Knee Raises | 2x15 |\n| 2026-09-24 | | Running | work set | Running | 3x400m |\n| 2026-09-24 | Thu | Squats | work set | Squats | 2x20 |\n\n* Historical entry comments\nKeep this note.\n")
(defun test-training-insert-at (day)
  (let ((now (encode-time 0 0 12 (string-to-number (substring day 8 10))
                          (string-to-number (substring day 5 7))
                          (string-to-number (substring day 0 4)))))
    (cl-letf (((symbol-function 'current-time) (lambda () now)))
      (my/org-insert-daily-training-entry))))
(ert-deftest training-new-month-full-session-and-duplicate ()
  (with-temp-buffer
    (insert training-source) (org-mode)
    (test-training-insert-at "2026-10-01")
    (should (= 4 (how-many "^| 2026-10-01" (point-min) (point-max))))
    (should (string-match-p "\\*\\*\\* 2026-10" (buffer-string)))
    (should (string-suffix-p "* Historical entry comments\nKeep this note.\n" (buffer-string)))
    (let ((before (buffer-string)))
      (should-error (test-training-insert-at "2026-10-01") :type 'user-error)
      (should (equal before (buffer-string))))))
(ert-deftest training-existing-month-narrowing-and-new-year ()
  (with-temp-buffer
    (insert training-source) (org-mode)
    (test-training-insert-at "2026-10-01")
    (goto-char (point-min)) (re-search-forward "^\\*\\*\\* 2026-09")
    (beginning-of-line) (org-narrow-to-subtree)
    (test-training-insert-at "2026-10-08")
    (should (buffer-narrowed-p))
    (widen)
    (should (= 1 (how-many "^\\*\\*\\* 2026-10$" (point-min) (point-max))))
    (should (= 4 (how-many "^| 2026-10-08" (point-min) (point-max))))
    (test-training-insert-at "2027-01-07")
    (should (string-match-p "\\*\\* 2027\n\n\\*\\*\\* 2027-01" (buffer-string)))))
(ert-deftest training-insert-before-future-month-and-rows ()
  (with-temp-buffer
    (insert training-source) (org-mode)
    (test-training-insert-at "2026-11-05")
    (test-training-insert-at "2026-10-15")
    (test-training-insert-at "2026-10-01")
    (let ((text (buffer-string)))
      (should (< (string-match "2026-10-01" text) (string-match "2026-10-15" text)))
      (should (< (string-match "\\*\\*\\* 2026-10" text) (string-match "\\*\\*\\* 2026-11" text))))))
(ert-deftest training-no-source-leaves-buffer-unchanged ()
  (with-temp-buffer
    (insert training-source) (org-mode)
    (let ((before (buffer-string)))
      (should-error (test-training-insert-at "2026-09-25") :type 'user-error)
      (should (equal before (buffer-string))))))

(ert-deftest training-running-only-falls-back-to-latest-strength-session ()
  (with-temp-buffer
    (insert training-source)
    (org-mode)
    (goto-char (point-min))
    (search-forward "* Historical entry comments")
    (beginning-of-line)
    (insert "*** 2026-10\n\n"
            "| Date | Day | Exercise | Type | Set | Reps |\n"
            "|------+-----+----------+------+-----+------|\n"
            "| 2026-10-01 | Thu | Pushups | warm up | Wall Pushups | 1x10 |\n"
            "| 2026-10-01 | | | work set | Wall Pushups | 2x20 |\n"
            "| 2026-10-01 | | Running | work set | Running | 5km |\n"
            "| 2026-10-01 | | | work set | Running | 1km |\n"
            "| 2026-10-08 | Thu | Running | work set | Running | 6km |\n"
            "| 2026-10-14 | Wed | Squats | work set | Squats | 2x20 |\n"
            "| 2026-10-15 | Thu | Running | work set | Running | 7km |\n"
            "| 2026-10-15 | | | work set | Running | 2km |\n\n")
    (let ((original (buffer-string)))
      (test-training-insert-at "2026-10-22")
      (should (= 4 (how-many "^| 2026-10-22" (point-min) (point-max))))
      (goto-char (point-min))
      (re-search-forward "^| 2026-10-22")
      (let ((rows (buffer-substring (line-beginning-position)
                                    (progn (forward-line 4) (point)))))
        (should (string-match-p "7km" rows))
        (should (string-match-p "2km" rows))
        (should (string-match-p "Pushups" rows))
        (should (string-match-p "1x10" rows))
        (should (string-match-p "2x20" rows))
        (should-not (string-match-p "5km\\|6km\\|1km\\|Squats\\|Leg Raises" rows)))
      ;; Source rows survive unchanged; only the new month's table is aligned.
      (should (string-prefix-p
               (substring original 0 (string-match "*** 2026-10" original))
               (buffer-string)))
      (let ((before (buffer-string)))
        (should-error (test-training-insert-at "2026-10-22") :type 'user-error)
        (should (equal before (buffer-string)))))))

(ert-deftest training-running-only-without-strength-history ()
  (with-temp-buffer
    (org-mode)
    (insert "* Daily Training Journal\n** 2026\n*** 2026-09\n"
            "| Date | Day | Exercise | Type | Set | Reps |\n"
            "|------+-----+----------+------+-----+------|\n"
            "| 2026-09-17 | Thu | Running | work set | Running | 5km |\n"
            "| 2026-09-24 | Thu | Running | work set | Running | 7km |\n")
    (test-training-insert-at "2026-10-01")
    (should (= 1 (how-many "^| 2026-10-01" (point-min) (point-max))))
    (goto-char (point-min))
    (re-search-forward "^| 2026-10-01")
    (should (string-match-p "7km" (thing-at-point 'line t)))))

(ert-deftest training-update-date-fills-only-first-blank-day ()
  ;; Previous date, current Day, expected Day.  An intervening old row
  ;; ensures the command checks all preceding rows, not just its neighbor.
  (dolist (case '(("2026-11-02" "" "Tue")
                  ("2026-11-03" "" "")
                  ("2026-11-03" "Mon" "")))
    (with-temp-buffer
      (org-mode)
      (insert "| Date | Day | Exercise |\n|------+-----+----------|\n"
              "| " (nth 0 case) " | Mon | Running |\n"
              "| 2026-11-02 | | Squats |\n"
              "| 2026-11-02 | " (nth 1 case) " | Pushups |\n"
              "| 2026-11-03 | | Leg Raises |\n")
      (goto-char (point-min))
      (forward-line 4)
      (let ((now (encode-time 0 0 12 3 11 2026)))
        (cl-letf (((symbol-function 'current-time) (lambda () now)))
          (my/org-update-daily-training-entry-date)))
      (should (equal (org-table-get nil 1) "2026-11-03"))
      (should (equal (org-table-get nil 2) (nth 2 case)))
      (should (equal (org-table-get nil 3) "Pushups"))
      (forward-line 1)
      (should (equal (org-table-get nil 2) "")))))

(ert-deftest training-update-selected-rows ()
  (dolist (earlier-today '(nil t))
    (dolist (reverse-selection '(nil t))
      (with-temp-buffer
        (org-mode)
        (insert "| Date | Day | Exercise |\n|------+-----+----------|\n"
                "| " (if earlier-today "2026-11-03" "2026-11-02")
                " | Tue | Running |\n"
                "| 2026-11-01 | Sun | Squats |\n"
                "| 2026-11-02 | Mon | Pushups |\n"
                "| 2026-11-02 | | Leg Raises |\n")
        (goto-char (point-min))
        (forward-line 3)
        (let ((start (+ (point) 4))
              (now (encode-time 0 0 12 3 11 2026))
              (transient-mark-mode t))
          (forward-line 2)
          (set-mark start)
          (activate-mark)
          (when reverse-selection (exchange-point-and-mark))
          (cl-letf (((symbol-function 'current-time) (lambda () now)))
            (my/org-update-daily-training-entry-date)))
        (goto-char (point-min))
        (forward-line 3)
        (should (equal (org-table-get nil 1) "2026-11-03"))
        (should (equal (org-table-get nil 2) (if earlier-today "" "Tue")))
        (should (equal (org-table-get nil 3) "Squats"))
        (forward-line 1)
        (should (equal (org-table-get nil 1) "2026-11-03"))
        (should (equal (org-table-get nil 2) ""))
        (should (equal (org-table-get nil 3) "Pushups"))
        ;; Ending the region at this row's beginning must exclude it.
        (forward-line 1)
        (should (equal (org-table-get nil 1) "2026-11-02"))))))

(ert-run-tests-batch-and-exit)
