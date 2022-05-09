;; -*- lexical-binding: t; -*-

;; Bootstrap code for straight.el package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)
(setq straight-use-package-by-default t)
;; Configure straight package version lockfile
(setq straight-profiles '((nil . "~/git/dot_emacs/versions.el")))


;; Enable debugging on error (this will cause describe-bindings not working)
;; (toggle-debug-on-error)

;; Back up settings
(defvar my-workspace-store-dir "~/Dropbox/org/persp/")
;; (setq backup-directory-alist `(("." . "~/.emacs.d/my_backups")))
(defvar backup-directory "~/.emacs.d/my_backups")
(if (not (file-exists-p backup-directory))
    (make-directory backup-directory t))
(setq
    make-backup-files t        ; backup a file the first time it is saved
    backup-directory-alist `((".*" . ,backup-directory)) ; save backup files in backup-directory
    backup-by-copying t     ; copy the current file into backup directory
    version-control t   ; version numbers for backup files
    delete-old-versions t   ; delete unnecessary versions
    kept-old-versions 6     ; oldest versions to keep when a new numbered backup is made (default: 2)
    kept-new-versions 9 ; newest versions to keep when a new numbered backup is made (default: 2)
    auto-save-default t ; auto-save every buffer that visits a file
    auto-save-timeout 20 ; number of seconds idle time before auto-save (default: 30)
    auto-save-interval 200 ; number of keystrokes between auto-saves (default: 300)
 )

;; Disable bars and change modeline color
(menu-bar-mode -1)
(tool-bar-mode -1)
(defvar my-modeline-color "#af5f00")
(if (display-graphic-p)
    ; GUI
    (progn
        (toggle-scroll-bar -1)
        (setq my-modeline-color "dim gray")
      )
  )

(defvar my-hostname (concat " " (system-name)))

;; Disable the startup splash screen
(setq inhibit-splash-screen t)

;; basic settings
(setq
      global-mark-ring-max 5000         ; increase mark ring to contains 5000 entries
      mark-ring-max 5000                ; increase mark ring to contains 5000 entries
      kill-ring-max 5000				; increase kill-ring capacity
      mode-require-final-newline t      ; add a newline to end of file
)

;; Changing tab width
(setq-default tab-width 4)

;; Disable tabs by default
(setq-default indent-tabs-mode nil)

;; disable semantic-idle-scheduler-function
(advice-add 'semantic-idle-scheduler-function :around #'ignore)

(setq my-system-is-mac nil)

;; Settings for MacOS
(cond ((string-equal system-type "darwin")
       (progn
         ;; modify option and command key
         (setq mac-command-modifier 'super)
         (setq mac-option-modifier 'meta)
         (setq my-system-is-mac t)
         ;; Use this for dired to work properly
         (setq insert-directory-program "/usr/local/opt/coreutils/libexec/gnubin/ls")
  )))

;; load paths
;; (let ((default-directory "~/.emacs.d/custom/"))
;;   (normal-top-level-add-subdirs-to-load-path))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my_inits"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my_packages"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/local_setting"))


;; Package settings

;; use-package
;; The use-package macro allows you to isolate package configuration in your .emacs file in a way that is both performance-oriented and, well, tidy
(straight-use-package 'use-package)

(use-package dash
;; A modern list API for Emacs
  )

(use-package f
;; Modern API for working with files and directories in Emacs
  )

(use-package project
  ;; Operations on the current project
  )

(use-package general
;; Convenience wrappers for keybindings
  :config
        (general-auto-unbind-keys)
        (general-create-definer my-prefix-key-evil-def :prefix "C-c e")
        (defconst my-space-leader "SPC")
        (defconst my-comma-leader ",")
        ;; Unbind my-space-leader key
        ;; (general-define-key
        ;;      :keymaps 'override
        ;;      :prefix my-space-leader
        ;;      "" nil
        ;;   )
        (general-create-definer my-space-leader-def
            :states '(normal insert motion visual emacs)
            :keymaps 'override
            :prefix my-space-leader
            :global-prefix "M-SPC"
          )
        (general-create-definer my-comma-leader-def
            :states '(normal motion visual emacs)
            :keymaps 'override
            :prefix my-comma-leader
            ;; :global-prefix "M-,"
          )
        (general-evil-setup)
        ;; Use ,, to <esc> keybinding in insert state (jk will cause my macro to be broken somehow)
        (general-imap ","
            (general-key-dispatch 'self-insert-command
                :timeout 0.25
                "," 'evil-normal-state))
        ;; Use fd to <esc> keybinding in insert state
        (general-imap "f"
            (general-key-dispatch 'self-insert-command
                :timeout 0.25
                "d" 'evil-normal-state))
        (my-space-leader-def
            "a" (general-simulate-key "C-c h" :which-key "helm prefix")
            "e" '(:ignore t :which-key "eval edit prefix")
            "r" '(:ignore t :which-key "persp restart reading prefix")
            "t" '(:ignore t :which-key "test debug prefix")
            "v" '(:ignore t :which-key "git visual prefix")
            "x" '(:ignore t :which-key "shell term prefix")
            "o" (general-simulate-key "C-c o" :which-key "org closure prefix")
            "t d" (general-simulate-key "C-c d" :which-key "debug prefix")
            "n" (general-simulate-key "C-c n" :which-key "roam deft noter prefix")
            "m" (general-simulate-key "C-c m" :which-key "misc prefix")
            "i" (general-simulate-key "C-h" :which-key "help prefix")
            "." (general-simulate-key "M-." :which-key "find definition")
            "," (general-simulate-key "M-," :which-key "pop back")
            "J" '(:ignore t :which-key "evil jump prefix")
            "W" '(:ignore t :which-key "window prefix")
         )
  )

(use-package hydra
;; This is a package for GNU Emacs that can be used to tie related commands into a family of short bindings with a common prefix - a Hydra.
  :custom-face
        (hydra-face-red ((t (:foreground "green"))))
  )

(use-package delight
;; Enables you to customise the mode names displayed in the mode line.
  )

(use-package el-patch
;; el-patch provides a way to customize the behavior of Emacs Lisp functions
  )

(use-package fzf
;; A front-end for fzf, fzf is a general-purpose command-line fuzzy file finder
  :bind
        (
            ("C-c f z" . fzf)
         )
  :general
        (my-space-leader-def
            "S" 'fzf
        )
  )

(use-package clues-theme
;; An Emacs theme, which is approaching awesomeness
  :init
        (load-theme 'clues t)
  )

(use-package restart-emacs
;; This is a simple package to restart Emacs for within Emacs.
  :general
        (my-space-leader-def
            "r r" 'restart-emacs
         )
  )

(use-package doom-modeline
;; A fancy and fast mode-line inspired by minimalism design
  :config
        (doom-modeline-mode 1)
        (setq global-mode-string (append global-mode-string '(my-hostname)))
  :custom
        (doom-modeline-icon nil)
        ;; Change height of the modeline
        (doom-modeline-bar-width 2)
        (doom-modeline-height 20)
        (doom-modeline-buffer-file-name-style (quote truncate-with-project))
  :custom-face
        (doom-modeline-buffer-modified ((t (:inherit bold :foreground "brightblack"))))
        (doom-modeline-debug ((t nil)))
        (doom-modeline-evil-emacs-state ((t nil)))
        (doom-modeline-evil-insert-state ((t nil)))
        (doom-modeline-evil-motion-state ((t nil)))
        (doom-modeline-evil-normal-state ((t nil)))
        (doom-modeline-evil-operator-state ((t nil)))
        (doom-modeline-evil-visual-state ((t nil)))
        (doom-modeline-info ((t (:inherit bold))))
        (doom-modeline-project-dir ((t (:inherit bold))))
        (doom-modeline-warning ((t nil)))
        (mode-line ((t (:height 0.8))))
        (mode-line-inactive ((t (:height 0.8))))
        (doom-modeline-bar ((t (:background ,my-modeline-color))))
        (doom-modeline-bar-inactive ((t (:background ,my-modeline-color))))
  )

(use-package macrostep
;; interactive macro-expander for Emacs
  )

(use-package transpose-frame
;; Transpose windows arrangement in a frame
  :general
        (
            :prefix "C-c f"
            "t" 'transpose-frame
            "f" 'flip-frame
            "F" 'flop-frame
         )
  )

(use-package persp-mode
;; named perspectives(set of buffers/window configs) for emacs
  :delight
  :init
        (add-hook 'after-init-hook 'persp-mode)
  :preface
        (defun persp-switch-by-number (num)
          "Switch to the perspective given by NUMBER."
          (interactive "NSwitch to perspective number: ")
          (let* ((persps (sort (persp-names) 'string-lessp))
                 (max-persps (length persps)))
            (if (<= num max-persps)
                (persp-switch (nth (- num 1) persps))
              (message "Perspective number %s not available, only %s exist%s"
                       num
                       max-persps
                       (if (= 1 max-persps) "s" ""))))
          )
  :config
        (el-patch-defun persp-prev ()
          "Switch to previous perspective (to the left)."
          (interactive)
          (let* ((persp-list (el-patch-swap (persp-names-current-frame-fast-ordered)
                                            (sort (persp-names) 'string-lessp)))
                 (persp-list-length (length persp-list))
                 (only-perspective? (equal persp-list-length 1))
                 (pos (cl-position (safe-persp-name (get-current-persp)) persp-list)))
            (cond
             ((null pos) nil)
             (only-perspective? nil)
             ((= pos 0)
              (if persp-switch-wrap
                  (persp-switch (nth (1- persp-list-length) persp-list))))
             (t (persp-switch (nth (1- pos) persp-list))))))

        (el-patch-defun persp-next ()
          "Switch to next perspective (to the right)."
          (interactive)
          (let* ((persp-list (el-patch-swap (persp-names-current-frame-fast-ordered)
                                            (sort (persp-names) 'string-lessp)))
                 (persp-list-length (length persp-list))
                 (only-perspective? (equal persp-list-length 1))
                 (pos (cl-position (safe-persp-name (get-current-persp)) persp-list)))
            (cond
             ((null pos) nil)
             (only-perspective? nil)
             ((= pos (1- persp-list-length))
              (if persp-switch-wrap (persp-switch (nth 0 persp-list))))
             (t (persp-switch (nth (1+ pos) persp-list))))))

        ; Don't auto resume
        (setq persp-auto-resume-time 0)
        (persp-set-keymap-prefix (kbd "C-c r"))
  :general
        (my-space-leader-def
            "r l" 'persp-load-state-from-file
            "r w" 'persp-save-state-to-file
            "r s" 'persp-frame-switch
            "r R" 'persp-rename
            "r a" 'persp-add-buffer
            "r k" 'persp-remove-buffer
            "r K" 'persp-kill-buffer
            "r b" 'persp-switch-to-buffer
            "r p" 'persp-prev
            "r n" 'persp-next
         )
        (
            :prefix "C-a"
            "c" 'persp-add-new
            "p" 'persp-prev
            "n" 'persp-next
            "X" 'persp-kill
            "," 'persp-rename
            "." 'persp-switch
            "a" 'persp-add-buffer
            "k" 'persp-remove-buffer
            "K" 'persp-kill-buffer
            "b" 'persp-switch-to-buffer
            "C-l" 'persp-load-state-from-file
            "C-s" 'persp-save-state-to-file
            "1" '(lambda () (interactive) (persp-switch-by-number 1))
            "2" '(lambda () (interactive) (persp-switch-by-number 2))
            "3" '(lambda () (interactive) (persp-switch-by-number 3))
            "4" '(lambda () (interactive) (persp-switch-by-number 4))
            "5" '(lambda () (interactive) (persp-switch-by-number 5))
            "6" '(lambda () (interactive) (persp-switch-by-number 6))
            "7" '(lambda () (interactive) (persp-switch-by-number 7))
            "8" '(lambda () (interactive) (persp-switch-by-number 8))
            "9" '(lambda () (interactive) (persp-switch-by-number 9))
            "0" '(lambda () (interactive) (persp-switch-by-number 10))
         )
  :custom
        (persp-save-dir my-workspace-store-dir)
        (persp-names-sort-before-read-function
         ;; Sort by alphabetic order
           (lambda (list) (sort list 'string-lessp)))
  )


;; (use-package perspective
;; ;; The Perspective package provides multiple named workspaces (or "perspectives") in Emacs, similar to multiple desktops in window managers like Awesome and XMonad, and Spaces on the Mac.
;;   :delight
;;   :init
;;         (persp-mode)
;;   :custom
;;         (persp-mode-prefix-key (kbd "C-a"))
;;         (persp-sort 'created)
;;         (persp-state-default-file my-workspace-store-dir)
;;   :general
;;         (my-space-leader-def
;;             "r l" 'persp-state-load
;;             "r w" 'persp-state-save
;;             "r s" 'persp-switch
;;             "r R" 'persp-rename
;;             "r a" 'persp-add-buffer
;;             "r k" 'persp-remove-buffer
;;             "r d" 'persp-kill
;;             "b" 'persp-switch-to-buffer
;;          )
;;   :config
;;         ;; Change persp sort created order from newest first to oldest first
;;         (el-patch-defun persp-names ()
;;           "Return a list of the names of all perspectives on the `selected-frame'.
;;         If `persp-sort' is 'name (the default), then return them sorted
;;         alphabetically. If `persp-sort' is 'access, then return them
;;         sorted by the last time the perspective was switched to, the
;;         current perspective being the first. If `persp-sort' is 'created,
;;         then return them in the order they were created, with the oldest
;;         first."
;;           (let ((persps (hash-table-values (perspectives-hash))))
;;             (cond ((eq persp-sort 'name)
;;                    (sort (mapcar 'persp-name persps) 'string<))
;;                   ((eq persp-sort 'access)
;;                    (mapcar 'persp-name
;;                            (sort persps (lambda (a b)
;;                                           (time-less-p (persp-last-switch-time b)
;;                                                        (persp-last-switch-time a))))))
;;                   ((eq persp-sort 'created)
;;                    (mapcar 'persp-name
;;                            (sort persps (lambda (a b)
;;                                           (el-patch-wrap 1 1
;;                                             (not
;;                                               (time-less-p (persp-created-time b)
;;                                                            (persp-created-time a)))))))))))
;;       )

;; (use-package eyebrowse
;; ;; eyebrowse is a global minor mode for Emacs that allows you to manage your window configurations in a simple manner, just like tiling window managers like i3wm with their workspaces do.
;;   :commands
;;          (eyebrowse--set)
;;   :config
;;         (eyebrowse-mode t)
;;   :general
;;         (
;;             :prefix "C-a"
;;             "p" 'eyebrowse-prev-window-config
;;             "n" 'eyebrowse-next-window-config
;;             "'" 'eyebrowse-last-window-config
;;             "X" 'eyebrowse-close-window-config
;;             "," 'eyebrowse-rename-window-config
;;             "." 'eyebrowse-switch-to-window-config
;;             "0" 'eyebrowse-switch-to-window-config-0
;;             "1" 'eyebrowse-switch-to-window-config-1
;;             "2" 'eyebrowse-switch-to-window-config-2
;;             "3" 'eyebrowse-switch-to-window-config-3
;;             "4" 'eyebrowse-switch-to-window-config-4
;;             "5" 'eyebrowse-switch-to-window-config-5
;;             "6" 'eyebrowse-switch-to-window-config-6
;;             "7" 'eyebrowse-switch-to-window-config-7
;;             "8" 'eyebrowse-switch-to-window-config-8
;;             "9" 'eyebrowse-switch-to-window-config-9
;;             "c" 'eyebrowse-create-window-config
;;          )
;;   :custom
;;         (eyebrowse-new-workspace t)
;;         (eyebrowse-wrap-around t)
;;         (eyebrowse-switch-back-and-forth t)
;;   )

;; (use-package eyebrowse-restore
;;   :straight
;;         (
;;             :host github
;;             :repo "FrostyX/eyebrowse-restore"
;;             :branch "main"
;;          )
;;   :general
;;         (
;;             :prefix "C-a"
;;             "C-s" 'eyebrowse-restore-save-all
;;             "C-l" 'eyebrowse-restore
;;          )
;;   :custom
;;         (eyebrowse-restore-dir "~/Dropbox/org/persp/eyebrowse")
;;   :config
;;         (eyebrowse-restore-mode)
;;   )

(use-package tab-bar
;; frame-local tabs with named persistent window configurations
  :straight nil
  ;; :general
  ;;       (
  ;;           :prefix "C-a"
  ;;           "t" 'tab-bar-mode
  ;;           "c" 'tab-new
  ;;           "p" 'tab-bar-switch-to-prev-tab
  ;;           "n" 'tab-next
  ;;           "X" 'tab-close
  ;;           "r" 'tab-bar-undo-close-tab
  ;;           "," 'tab-rename
  ;;           "." 'tab-bar-select-tab-by-name
  ;;           "0" 'tab-bar-switch-to-recent-tab
  ;;           "1" 'tab-bar-select-tab
  ;;           "2" 'tab-bar-select-tab
  ;;           "3" 'tab-bar-select-tab
  ;;           "4" 'tab-bar-select-tab
  ;;           "5" 'tab-bar-select-tab
  ;;           "6" 'tab-bar-select-tab
  ;;           "7" 'tab-bar-select-tab
  ;;           "8" 'tab-bar-select-tab
  ;;           "9" 'tab-bar-select-tab
  ;;        )
  :config
        (tab-bar-mode 0)
  :custom
        (tab-bar-new-tab-choice "*scratch*")
        (tab-bar-new-tab-to 'rightmost)
        (tab-bar-close-button-show nil)
        (tab-bar-new-button-show nil)
        ;; Don't turn on tab-bar-mode when tabs are created
        (tab-bar-show nil)
        ;; Show absolute numbers on tabs in the tab bar before the tab name.
        (tab-bar-tab-hints t)
        (tab-bar-tab-name-function 'tab-bar-tab-name-truncated)
        (tab-bar-tab-name-truncated-max 25)
        (tab-bar-tab-name-ellipsis "...")
        ;; List of modifier keys for selecting a tab by its index digit.
        (tab-bar-select-tab-modifiers '(meta))
  :custom-face
        (tab-bar ((t (:inherit variable-pitch :background ,my-modeline-color :foreground "black"))))
        (tab-bar-tab ((t (:inherit tab-bar :weight bold))))
        (tab-bar-tab-inactive ((t (:inherit tab-bar))))
  )

;; (use-package burly
;; ;; This package provides tools to save and restore frame and window configurations in Emacs, including buffers that may not be live anymore.
;;   :disabled
;;   :straight
;;         (:branch "wip/tab-bar")
;;   )

;; company-mode
(use-package company
;; Modular in-buffer completion framework for Emacs
  :delight
  ;; :init
  ;;       (add-hook 'after-init-hook 'global-company-mode)
  :bind
        ;; ("C-j" . company-select-next)
        ;; ("C-k" . company-select-previous)
        (
            :map company-active-map
            ("TAB" . company-complete-selection)
        )
  :config
        ; Solve the conflicts with yasnippet of tab key binding
        (advice-add 'company-complete-common :before (lambda ()
                                        (setq my-company-point (point))))
        (advice-add 'company-complete-common :after (lambda ()
                                        (when (equal my-company-point (point)) (yas-expand))))
  :custom
        (company-idle-delay 0)
        (company-minimum-prefix-length 1)
        (company-backends
        '((company-files
            company-keywords
            company-capf	; completion-at-point-functions backend
            company-yasnippet
            )
            (company-abbrev company-dabbrev)))
  :custom-face
        (company-preview ((t (:background "black" :foreground "brightblack"))))
        (company-preview-common ((t (:inherit company-preview :foreground "brightblack"))))
        (company-scrollbar-bg ((t (:background "black"))))
        (company-scrollbar-fg ((t (:background "black"))))
        (company-tooltip ((t (:background "black" :foreground "white"))))
        (company-tooltip-annotation ((t (:foreground "yellow"))))
        (company-tooltip-common ((t (:foreground "gold3"))))
        (company-tooltip-selection ((t (:background "forestgreen"))))
  :hook
        (prog-mode . company-mode)
  )

(use-package company-statistics
;; Sort completion candidates by previous completion choices
  :hook
        (after-init . company-statistics-mode)
  )

(use-package evil
;; The extensible vi layer for Emacs.
  :after
        (hydra undo-tree)
  :init
        (setq evil-want-keybinding nil)		;; required by evil-collection
        ; Don't use TAB to jump forward
        (setq evil-want-C-i-jump nil)
  :bind
        (
            :map evil-motion-state-map
            ; Use B,E to move to the beggining and end of line
            ("B" . evil-beginning-of-line)
            ("E" . evil-end-of-line)
            ; Use C-b to evil-scroll-up instead of evil-scroll-page-up
            ("C-b" . evil-scroll-up)
         )
  :preface
        (defhydra hydra-move ()
          "move"
          ("j" evil-next-line)
          ("k" evil-previous-line)
          ("u" evil-scroll-up)
          ("d" evil-scroll-down)
          ("g" evil-goto-first-line)
          ("G" evil-goto-line)
          )
  :general
        (my-space-leader-def
            ;; Jump to matched parentheses, default key binding %
            "J j" 'evil-jump-item
            "J n" 'evil-jump-forward
            "J p" 'evil-jump-backward
            "u" 'evil-scroll-up
            "d" 'evil-scroll-down
            "w" 'evil-write-all
            "W s" 'evil-window-split
            "W v" 'evil-window-vsplit
            "q" 'evil-quit
            "<escape>" 'hydra-move/body
         )
        (
            :prefix "C-a"
            "s" 'evil-window-split
            "v" 'evil-window-vsplit
            "x" 'evil-quit
         )
        ([remap evil-search-forward] 'swiper)
  :config
        (evil-mode 1)
        (global-undo-tree-mode)
        (evil-set-undo-system 'undo-tree)
        ; change granularity level of undo
        (setq evil-want-fine-undo t)
        (general-define-key
            :states 'motion
            ;; swap ; and :
            ";" 'evil-ex
            ":" 'evil-repeat-find-char
         )
  :hook
        (after-change-major-mode . (lambda ()
            ;; Treat underscore as part of the whole word for all major mode
            (modify-syntax-entry ?_ "w")
        ))
 )

(use-package evil-collection
;; A set of keybindings for evil-mode
  :init
        (setq evil-want-keybinding nil)		;; required by evil-collection
  :config
        ;; Don't use evil-collection in w3m
        (delete 'w3m evil-collection-mode-list)
        (evil-collection-init)
  :custom
        (evil-collection-setup-minibuffer t)
  )

(use-package linum-relative
;; Display relative line number in the left margin in emacs
  :general
        (my-space-leader-def
            ";" 'linum-relative-toggle
         )
  :config
        ;; Use `display-line-number-mode` as linum-mode's backend for smooth performance
        (setq linum-relative-backend 'display-line-numbers-mode)
  )

(use-package smartparens
;; Minor mode for Emacs that deals with parens pairs and tries to be smart about it.
  :config
        (require 'smartparens-config)
        (smartparens-global-mode 1)
        (show-smartparens-global-mode)
  ;; :hook
  ;;       (emacs-lisp-mode . show-smartparens-mode)
  ;;       (ielm-mode . show-smartparens-mode)
  )

(use-package evil-surround
;; "surroundings": parentheses, brackets, quotes, XML tags, and more, ys<textobject>, cs<old-textobject><new-textobject>, ds<textobject>
  :config
        (global-evil-surround-mode 1)
  )

(use-package evil-exchange
;; Easy text exchange operator for Evil, gx for exchange, gX for cancel
  :config
        (evil-exchange-install)
  )

(use-package evil-replace-with-register
;; Replace text with the contents of a register, ["x]gR{motion}
  :general
        (
            :states '(normal visual)
            :keymaps 'override
            ;; "g r" 'evil-replace-with-register
            "g r" (general-predicate-dispatch 'evil-replace-with-register
                    (equal major-mode 'dired-mode) 'revert-buffer
                    (derived-mode-p 'magit-mode) 'magit-refresh-all
                    (derived-mode-p 'neotree-mode) 'neotree-refresh
                    (equal major-mode 'elfeed-search-mode) 'elfeed-search-fetch
                    (equal major-mode 'compilation-mode) 'recompile
                   )
         )
  :config
        ;; (setq evil-replace-with-register-key (kbd "gr"))
        (evil-replace-with-register-install)
  )

(use-package evil-visualstar
;; Start a * or # search from the visual selection. Make a visual selection with v or V, and then hit * to search that selection forward, or # to search that selection backward
  :config
        ;; allowing for repeated * or #
        (setq evil-visualstar/persistent t)
        (global-evil-visualstar-mode)
  )

(use-package evil-nerd-commenter
;; Comment/uncomment lines efficiently. Like Nerd Commenter in Vim
  :config
        (evilnc-default-hotkeys)
  )

(use-package evil-lion
;; Evil align operator. Align bashed on CHAR with gl MOTION CHAR or right-align with gL MOTION CHAR. Use CHAR / to enter regular expression if a single character wouldn't suffice. Use CHAR RET to align with align.el's default rules for the active major mode.
  :config
        (evil-lion-mode)
  )

(use-package evil-numbers
;; Increment and decrement numbers in Emacs
  :bind
        (
            ("C-c +" . evil-numbers/inc-at-pt)
            ("C-c -" . evil-numbers/dec-at-pt)
            ("C-c =" . evil-numbers/inc-at-pt-incremental)
            ("C-c _" . evil-numbers/dec-at-pt-incremental)
         )
  )

(use-package evil-args
;; Motions and text objects for delimited arguments in Evil
  :bind
        (
            ;; "cia" change arg, "daa" delete arg
            :map evil-inner-text-objects-map
            ("a" . evil-inner-arg)
            :map evil-outer-text-objects-map
            ("a" . evil-outer-arg)
         )
  )

(use-package evil-indent-plus
;; Better indent textobjects for evil
;; It provides six new text objects to evil based on indentation:
;; ii: A block of text with the same or higher indentation.
;; ai: The same as ii, plus whitespace.
;; iI: A block of text with the same or higher indentation, including the first line above with less indentation.
;; aI: The same as iI, plus whitespace.
;; iJ: A block of text with the same or higher indentation, including the first line above and below with less indentation.
;; aJ: The same as iJ, plus whitespace
  :config
        (evil-indent-plus-default-bindings)
  )

(use-package evil-visual-mark-mode
;; Display evil marks on buffer
  )

(use-package anzu
;; anzu.el provides a minor mode which displays current match and total matches information in the mode-line
  :delight
  :config
        (global-anzu-mode)
  )

(use-package evil-anzu
;; anzu for Evil
  )

(use-package evil-mc
;; Multiple cursors implementation for evil-mode
  :delight
  :general
        (
            :states '(normal visual)
            "g m" evil-mc-cursors-map
         )
  :config
        (global-evil-mc-mode)
  )

(use-package evil-textobj-line
;; Evil Line text object. Default: "l"
  )

(use-package exato
;; This package provides the x text object to manipulate html/xml tag attributes. Try using dax, vix and gUix
  )

(use-package evil-textobj-syntax
;; This package provides h text objects for consecutive items with same syntax highlight.
  )

(use-package evil-string-inflection
;; Evil operator g~ to cycle text objects through camelCase, kebab-case, snake_case and UPPER_CASE.
  )

(use-package evil-cleverparens
;; Evil normal-state minor-mode for editing lisp-like languages
;; This package provides the f,c,d text object
;; Form bound to f. Form is a pair-delimited range as defined by smartparens
;; Comment bound to c
;; Defun bound to d
;; H	Move backward by sexp
;; L	Move forward by sexp
;; (	Move backward up a sexp.
;; )	Move forward up a sexp.
;; [	Move to the previous opening parentheses
;; ]	Move to the next closing parentheses
;; {	Move to the next opening parentheses
;; }	Move to the previous closing parentheses
  ;; :hook
  ;;        ((lisp-mode emacs-lisp-mode) . evil-cleverparens-mode)
  )

(use-package undo-tree
;; Treat undo history as a tree
  :delight
  )

(use-package avy
;; Jump to things in Emacs tree-style
  :general
        ;; (my-space-leader-def
        ;;     :prefix (concat my-space-leader " v")
        ;;     "c" 'avy-goto-char
        ;;     "w" 'avy-goto-word-1
        ;;     "l" 'avy-goto-line
        ;;     "o" 'avy-org-goto-heading-timer
        ;;     "r" 'avy-resume
        ;;  )
        (my-space-leader-def
            "z" 'avy-goto-char-timer
         )
  :custom-face
        (avy-lead-face ((t (:background "blue" :foreground "white"))))
        (avy-lead-face-0 ((t (:background "blue" :foreground "white"))))
        (avy-lead-face-1 ((t (:background "blue" :foreground "white"))))
        (avy-lead-face-2 ((t (:background "blue" :foreground "white"))))
  )

(use-package git-gutter
;; Emacs port of GitGutter
  :delight
  :init
        (add-hook 'after-init-hook 'global-git-gutter-mode)
  :bind
        (
            ("C-x v C-g" . git-gutter)
            ("C-x v =" . git-gutter:popup-hunk)
            ("C-x v p" . git-gutter:previous-hunk)
            ("C-x v n" . git-gutter:next-hunk)
            ("C-x v s" . git-gutter:stage-hunk)
            ("C-x v r" . git-gutter:revert-hunk)
            ("C-x v SPC" . git-gutter:mark-hunk)
         )
  :general
        (my-space-leader-def
            "v =" 'git-gutter:popup-hunk
            "v p" 'git-gutter:previous-hunk
            "v n" 'git-gutter:next-hunk
            "v s" 'git-gutter:stage-hunk
            "v r" 'git-gutter:revert-hunk
            "v SPC" 'git-gutter:mark-hunk
            "v f" 'straight-freeze-versions
            "v R" 'straight-thaw-versions
         )
  :config
        (add-to-list 'git-gutter:update-hooks 'focus-in-hook)
  :custom
        (git-gutter:modified-sign "~")
  :custom-face
        (git-gutter:added ((t (:foreground "white" :weight extra-light))))
        (git-gutter:deleted ((t (:foreground "white" :weight extra-light))))
        (git-gutter:modified ((t (:foreground "white" :weight extra-light))))
  )


(use-package neotree
;; A Emacs tree plugin like NerdTree for Vim.
  :bind
        (
            ([f8] . 'neotree-toggle)
            ;; :map neotree-mode-map
            ;; ("s" . neotree-enter-vertical-split)
            ;; This cannot override key binding defined by evil-collection
            :map evil-normal-state-map
            ("C-n" . neotree-refresh)
         )
  :general
        (my-space-leader-def
            "8" 'neotree-toggle
            "9" 'neotree-refresh
         )
  :config
        (general-define-key
            :states 'normal
            :keymaps 'neotree-mode-map
            "s" 'neotree-enter-vertical-split
            "S" 'neotree-enter-horizontal-split
            "TAB" (neotree-make-executor
                      :file-fn 'neo-open-file
                      :dir-fn 'neo-open-dir)
         )
  :custom
        (neo-confirm-create-directory (quote off-p))
        (neo-confirm-create-file (quote off-p))
        (neo-autorefresh t)
        (neo-smart-open t)
  )

(use-package ivy
;; a generic completion mechanism for Emacs
  :general
        (
            :states '(insert normal)
            :keymaps 'ivy-minibuffer-map
            "C-j" 'ivy-next-line
            "C-k" 'ivy-previous-line
            "TAB" 'ivy-alt-done
            "C-l" 'ivy-dispatching-done
        )
  :config
        (ivy-mode 1)
        ;; make selection highlight-background expand full width of the minibuffer
        (setcdr (assoc t ivy-format-functions-alist) #'ivy-format-function-line)
        (setq ivy-re-builders-alist
            ;; allow input not in order
            '((t   . ivy--regex-ignore-order)))
  :custom
        ;; Don't start searches with ^
        (ivy-initial-inputs-alist nil)
  :custom-face
        (ivy-minibuffer-match-face-1 ((t (:foreground "gold3"))))
        (ivy-minibuffer-match-face-2 ((t (:inherit ivy-minibuffer-match-face-1))))
        (ivy-minibuffer-match-face-3 ((t (:inherit ivy-minibuffer-match-face-1))))
        (ivy-minibuffer-match-face-4 ((t (:inherit ivy-minibuffer-match-face-1))))
        (ivy-current-match ((t (:background "forestgreen"))))
  )

(use-package counsel
;; a collection of Ivy-enhanced versions of common Emacs commands
  :general
        (
            :states '(insert normal)
            :keymaps 'ivy-minibuffer-map
            ;; :keymaps 'minibuffer-local-map
            "C-r" 'counsel-minibuffer-history
            "C-u" 'counsel-up-directory
        )
        (my-comma-leader-def
            "SPC" 'counsel-M-x
            "b" 'counsel-ibuffer
            "s" 'counsel-find-file
        )
        (my-space-leader-def
            "`" 'counsel-M-x
        )
  :custom
        ;; Don't show app path
        (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  )

(use-package swiper
;; Swiper is an alternative to isearch that uses Ivy to show an overview of all matches.
  :custom-face
        (swiper-match-face-1 ((t (:inherit isearch))))
        (swiper-match-face-2 ((t (:inherit swiper-match-face-1))))
        (swiper-match-face-3 ((t (:inherit swiper-match-face-1))))
        (swiper-match-face-4 ((t (:inherit swiper-match-face-1))))
        (swiper-background-match-face-1 ((t (:inherit isearch))))
        (swiper-background-match-face-2 ((t (:inherit swiper-background-match-face-1))))
        (swiper-background-match-face-3 ((t (:inherit swiper-background-match-face-1))))
        (swiper-background-match-face-4 ((t (:inherit swiper-background-match-face-1))))
  )

(use-package ivy-rich
;; This package comes with rich transformers for commands from ivy and counsel. It should be easy enough to define your own transformers too.
  :config
        (ivy-rich-mode 1)
        ;; (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  )

(use-package helm
;; Helm is an Emacs framework for incremental completions and narrowing selections.
  :delight
  :init
        (global-set-key (kbd "C-c h") 'helm-command-prefix)
  ;; :bind-keymap
  ;;       ("C-c h" . helm-command-prefix)
  :bind
        (
            ("M-x" . helm-M-x)
            ("M-y" . helm-show-kill-ring)
            ("C-x b" . helm-mini)
            ("C-x C-f" . helm-find-files)
            ("C-h SPC" . helm-all-mark-rings)
            :map helm-command-map
            ("o" . helm-occur)
            ("y" . helm-yas-complete)
            ("r" . helm-resume)
            :map helm-map
            ("C-l" . helm-select-action) ; list actions
            ("C-u" . helm-find-files-up-one-level)
            :map minibuffer-local-map
            ("C-c C-l" . helm-minibuffer-history)
        )
  :general
        (
            :states '(insert normal)
            :keymaps 'helm-map
            "C-j" 'helm-next-line
            "C-k" 'helm-previous-line
            "TAB" 'helm-execute-persistent-action
        )
        (
            :states '(insert normal)
            :keymaps 'minibuffer-local-map
            "C-r" 'helm-minibuffer-history
        )
        (my-space-leader-def
            "SPC" 'helm-M-x
            "y" 'helm-show-kill-ring
            "s" 'helm-find-files
            "f" 'helm-occur
        )
        ;; (my-comma-leader-def
        ;;     :states '(normal motion visual insert)
        ;;     :keymaps 'helm-map
        ;;     "," 'helm-keyboard-quit
        ;;  )
  :config
        (require 'helm-config)
        (global-unset-key (kbd "C-x c"))
        ;; (helm-mode 1)
        (setq
            ;; helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
            helm-ff-file-name-history-use-recentf t
            ;; helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
            ;; helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
            ;; helm-echo-input-in-header-line		t
        )
        ; Don't show the first two lines (current dir and parent dir)
        ;; (advice-add 'helm-ff-filter-candidate-one-by-one
        ;;         :around (lambda (fcn file)
        ;;                 (unless (string-match "\\(?:/\\|\\`\\)\\.\\{1,2\\}\\'" file)
        ;;                     (funcall fcn file))))
        ;; helm-mini
        (setq helm-buffers-fuzzy-matching t
            helm-recentf-fuzzy-match    t)
        ;; helm ack
        (if (eq system-type 'darwin)
            (if (not (member "/usr/local/bin/" exec-path))
                (add-to-list 'exec-path "/usr/local/bin/")))
        (setq helm-grep-default-command
            "ack -Hn --color --smart-case --no-group %e %p %f"
            helm-grep-default-recurse-command
            "ack -H --color --smart-case --no-group %e %p %f")
        ;; helm-semantic-or-imenu
        (semantic-mode 1)
        (setq helm-semantic-fuzzy-match	t
            helm-imenu-fuzzy-match	t)
        ; Show type in C/C++
        (with-eval-after-load 'helm-semantic
            (push '(c-mode . semantic-format-tag-summarize) helm-semantic-display-style)
            (push '(c++-mode . semantic-format-tag-summarize) helm-semantic-display-style))
        ;; helm-occur
        (setq helm-apropos-fuzzy-match t)
  :hook
        (eshell-mode . (lambda ()
                (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)
        ))
)

(use-package helm-company
;; Helm interface for company-mode
)

(use-package helm-descbinds
;; Helm Descbinds provides an interface to emacs’ describe-bindings making the currently active key bindings interactively searchable with helm.
  :config
        (helm-descbinds-mode)
  )

(use-package helm-swoop
;; helm-swoop allows to show interactively lines (in one or multiple buffers) that match a pattern in another (helm) buffer
  :after
        (helm)
  :bind
        (
            :map helm-command-map
            ("w w" . helm-multi-swoop)
            ("w a" . helm-multi-swoop-all)
            ("w m" . helm-multi-swoop-current-mode-from-helm-swoop)
         )
  :general
        (
            ;; Fix RET not working with helm-multi-swoop
            :states '(normal insert)
            :keymaps 'helm-multi-swoop-buffers-map
            "RET"  (lambda () (interactive) (helm-exit-and-execute-action 'helm-multi-swoop--exec))
         )
        (my-prefix-key-evil-def
            :states 'motion
            "w" 'helm-swoop-from-evil-search
         )
  :custom-face
        (helm-swoop-target-line-block-face ((t nil)))
        (helm-swoop-target-line-face ((t nil)))
        (helm-swoop-target-word-face ((t (:foreground "gold3"))))
  )

(use-package helm-ag
;; The silver searcher with helm interface
  :bind
        (
            :map helm-command-map
            ("g g" . helm-ag)
            ("g d" . helm-do-ag)
            ("g b" . helm-do-ag-buffers)
            ("g p" . helm-do-ag-project-root)
         )
  :general
        (my-space-leader-def
            "F" 'helm-do-ag-project-root
        )
  :custom
        ;; Enable helm-follow-mode by default
        (helm-follow-mode-persistent t)
  )

(use-package helm-make
;; Select a Makefile target with helm. A call to helm-make will give you a helm selection of this directory Makefile's targets
  :bind
        (
            :map helm-command-map
            ("k" . helm-make)
         )
  )

(use-package projectile
;; a project interaction library for Emacs
  :delight
  :bind-keymap
        ("C-c p" . projectile-command-map)
  :bind
        (
            ("C-c TAB" . projectile-find-other-file)
            ;; ("C-c P" . (lambda () (interactive)
            ;;              (projectile-cleanup-known-projects)
            ;;              (projectile-discover-projects-in-search-path)))
            :map projectile-command-map
            ("s a" . helm-projectile-ack)
         )
  :config
        (projectile-global-mode)
        (setq projectile-completion-system 'helm)
  )

(use-package helm-projectile
;; Helm integration for Projectile
  :config
        (helm-projectile-on)
        ;; (setq projectile-switch-project-action 'helm-projectile)
  :general
        (my-space-leader-def
            "p" 'helm-projectile-switch-project
         )
  )

(use-package iedit
;; Edit multiple regions simultaneously in a buffer or a region
  :after
        (hydra)
  :bind
        (
            ("C-c s" . iedit-mode)
         )
  :general
        (my-space-leader-def
            "e e" 'iedit-mode
            "e <escape>" 'hydra-iedit/body
         )
  :preface
        (defun hydra-iedit-pre ()
          ;; Enable iedit-mode if not enabled already
          (if (not (bound-and-true-p iedit-mode))
              (iedit-mode)
              )
          ;; Restrict to current line for next operation
          (iedit-restrict-current-line)
          )
        (defhydra hydra-iedit
          (:body-pre hydra-iedit-pre)
            "iedit"
            ("j" iedit-expand-down-a-line)
            ("k" iedit-expand-up-a-line)
            ("." iedit-restrict-current-line)
            ("n" iedit-next-occurrence)
            ("p" iedit-prev-occurrence)
          )
  )

(use-package evil-iedit-state
;; Slick Evil states for iedit.
  :after
        (evil iedit)
  :hook
        ;; Use evil-iedit-state when iedit-mode is enabled.
        (iedit-mode)
  )

(use-package ggtags
;; Emacs frontend to GNU Global source code tagging system.
  :hook
        (c-mode-common . (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
                (ggtags-mode 1)
                ;; (helm-gtags-mode)
                )
            (define-key evil-normal-state-local-map (kbd "M-.") 'ggtags-find-tag-dwim)
        ))
  )

(use-package helm-gtags
;; GNU GLOBAL helm interface
  :after
        (ggtags)
  :bind
        (
            :map helm-gtags-mode-map
            ("C-c t a" . helm-gtags-tags-in-this-function)
            ("C-c t f" . helm-gtags-find-files)
            ("C-c t p" . helm-gtags-parse-file)
            ("C-c t S" . helm-gtags-show-stack)
         )
  :hook
        (ggtags-mode . helm-gtags-mode)
  :custom
        (helm-gtags-prefix-key "\C-c t")
        (helm-gtags-suggested-key-mapping t)
        (helm-gtags-path-style 'relative)
        (helm-gtags-ignore-case t)
        (helm-gtags-auto-update t)
  )

(use-package yasnippet
;; A template system for Emacs, It allows you to type an abbreviation and automatically expand it into function templates.
  :bind
        (
            ("C-h y" . yas-describe-tables)
        )
  :general
        (
            :states '(insert normal)
            "M-TAB" 'yas-expand
        )
  :config
        (yas-global-mode 1)
        (yas-reload-all)
  :custom
        ; Don't make aliases for the old style yas/ prefixed symbols
        (yas-alias-to-yas/prefix-p nil)
        (yas-snippet-dirs '("~/git/dot_emacs/yas_snippets"))
  )

(use-package yasnippet-snippets
;; a collection of yasnippet snippets for many languages
  )

(use-package helm-c-yasnippet
;; Helm source for yasnippet
  :after
        (helm yasnippet)
  :bind
        (
            ("C-c y" . helm-yas-complete)
         )
  :config
        ; helm pattern space match anyword greedy, "if else" replace to "if.*else"
        (setq helm-yas-space-match-any-greedy t)
  )

(use-package auto-yasnippet
;; quickly create disposable yasnippets
  )

(use-package rg
;; Emacs search tool based on ripgrep
  :config
        (rg-enable-default-bindings)
  :custom-face
        (rg-info-face ((t (:foreground "#0ff"))))
        (rg-line-number-face ((t (:foreground "#0ff"))))
        (rg-match-face ((t (:foreground "gold3"))))
  )

(use-package helm-rg
;; Search massive codebases extremely fast, using ripgrep and helm
  :bind
        (
            :map helm-command-map
            ("g r" . helm-rg)
            :map helm-rg-map
            ("C-u" . helm-find-files-up-one-level)
         )
  :config
        (setq helm-rg--color-format-argument-alist
            '((red :cmd-line yellow :text-property yellow)))
        ;; Enable follow mode by helm-attrset for helm-rg-process-source
        (helm-attrset 'follow 1 helm-rg-process-source)
  :custom-face
        (helm-rg-title-face ((t (:foreground "green" :weight bold))))
        (helm-rg-line-number-match-face ((t (:foreground "#0ff" :underline t))))
        (helm-rg-error-message ((t (:foreground "pink"))))
        (helm-rg-preview-line-highlight ((t (:foreground "gold3"))))
  )

(use-package bookmark+
;; Bookmark+ enhances vanilla Emacs bookmarks in many ways, Bookmarks record locations so you can return to them later
;; Bookmark the file you are editing: ‘C-x x m’
;; Jump to a bookmark: ‘C-x j j’
;; Tag a file (creates an autofile bookmark): `C-x x t + a’
;; List/edit your bookmarks: ‘C-x r l’
  :custom
        (bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
  )

(use-package bm
;; This package provides visible, buffer local, bookmarks and the ability to jump forward and backward to the next bookmark.
  )

(use-package expand-region
;; Emacs extension to increase selected region by semantic units.
  :bind
        (
            ("M-+" . er/expand-region)
         )
  )

(use-package ibuffer-vc
;; Group buffers in ibuffer list by VC project
  :after
        (ibuffer)
  :config
        (setq ibuffer-formats
            '((mark modified read-only vc-status-mini " "
                    (name 18 18 :left :elide)
                    " "
                    (size 9 -1 :right)
                    " "
                    (mode 16 16 :left :elide)
                    " "
                    (vc-status 16 16 :left)
                    " "
                    filename-and-process)))
  :hook
        (ibuffer . (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  )

(use-package magit
;; Magit is an interface to the version control system Git, implemented as an Emacs package. Magit aspires to be a complete Git porcelain.
  :bind
        (
            ("C-x g" . magit-status)
            ("C-c g l" . magit-log)
            ("C-c g c" . magit-blame)
            ("C-c g b" . magit-branch)
            ("C-c g s" . magit-status)
            ;; :map magit-mode-map
            ;; ("o" . magit-file-checkout)
            ;; ("gR" . magit-refresh)
         )
  :general
        (my-space-leader-def
            "g" 'magit-status
         )

  :hook
        (magit-post-refresh . git-gutter:update-all-windows)
        (after-save . magit-after-save-refresh-status)
  )

;; (use-package evil-magit
;;   :after
;;         (evil magit)
;;   )

(use-package magit-gitflow
;; GitFlow plugin for magit
  :after
        (magit)
  :general
        (
            :keymaps 'magit-mode-map
            "gw" 'magit-gitflow-popup
         )
  :hook
        (magit-mode . turn-on-magit-gitflow)
  )

(use-package forge
;; Work with Git forges from the comfort of Magit
  :after
        (magit)
  )

(use-package hl-todo
;; Highlight TODO keywords
  :general
        (
            :prefix "C-c t"
            :keymaps 'hl-todo-mode-map
            "p" 'hl-todo-previous
            "n" 'hl-todo-next
            "o" 'hl-todo-occur
            "i" 'hl-todo-insert
         )
  :config
        ;; (setq hl-todo-keyword-faces '(
        ;;      ("TODO"   . "#FF0000")
        ;;      ("FIXME"  . "#FF0000")
        ;;      ("DEBUG"  . "#A020F0")
        ;;      ("GOTCHA" . "#FF4500")
        ;;      ("STUB"   . "#1E90FF")
        ;;  ))
        (global-hl-todo-mode 1)
  )

(use-package magit-todos
;; Show source files' TODOs (and FIXMEs, etc) in Magit status buffer
  :bind
        (
            ("C-c g t" . magit-todos-mode)
            :map helm-command-map
            ("g t" . helm-magit-todos)
         )
  :config
        ;; (if (executable-find "nice")
        ;;      (setq magit-todos-nice t))
        (if (executable-find "rg")
            (setq magit-todos-scanner 'magit-todos--scan-with-rg))
  )

(use-package gitignore-mode
;; Emacs major modes for Git ignore files
  :straight git-modes
  )

(use-package gitconfig-mode
;; Emacs major modes for Git config files
  :straight git-modes
  )

(use-package gitattributes-mode
;; Emacs major modes for Git attributes files
  :straight git-modes
  )

(use-package git-timemachine
;; Git time machine
  :bind
        (
            ("C-c g r" . git-timemachine)
         )
  :general
        (my-space-leader-def
            :definer 'minor-mode
            :states '(normal motion visual)
            :keymaps 'git-timemachine-mode
            :prefix (concat my-space-leader " g t")
            "p" 'git-timemachine-show-previous-revision
            "n" 'git-timemachine-show-next-revision
            "g" 'git-timemachine-show-nth-revision
            "t" 'git-timemachine-show-revision-fuzzy
            "q" 'git-timemachine-quit
            "w" 'git-timemachine-kill-abbreviated-revision
            "W" 'git-timemachine-kill-revision
            "b" 'git-timemachine-blame
            "c" 'git-timemachine-show-commit
            "?" 'git-timemachine-help
         )
        (
            :definer 'minor-mode
            :states '(normal motion visual)
            :keymaps 'git-timemachine-mode
            "\C-k" 'git-timemachine-show-previous-revision
            "\C-j" 'git-timemachine-show-next-revision
         )
  )

(use-package insert-shebang
;; Insert shebang line automatically for Emacs.
  ;; :hook
        ;; For file extension in my_insert_file_type_list and file has not been created yet, insert shebang, two newline and enter evil-insert-state
        ;; (find-file . (lambda ()
        ;;      (setq my_insert_file_type_list (list
        ;;          "sh"
        ;;          "py"
        ;;          "bats"
        ;;          ))
        ;;      (if (and (member (file-name-extension (buffer-name)) my_insert_file_type_list) (not (file-exists-p (buffer-name))))
        ;;          (progn
        ;;              (insert-shebang)
        ;;              (newline)
        ;;              (newline)
        ;;              (evil-insert-state)
        ;;              ))))
  :bind
        (
            ("C-c f i" . insert-shebang)
         )
  :config
        (remove-hook 'find-file-hook 'insert-shebang)
  :custom
        (insert-shebang-file-types (quote
            (("py" . "python3")
            ("sh" . "bash")
            ("pl" . "perl")
            ("bats" . "bats"))))
        ;; (insert-shebang-ignore-extensions (quote (
        ;;      "txt"
        ;;      "org"
        ;;      "c"
        ;;  )))
  )

(use-package flyspell
  :config
        (if (executable-find "aspell")
            (progn
            (setq ispell-program-name "aspell")
            (setq ispell-extra-args '("--sug-mode=ultra")))
        (setq ispell-program-name "ispell"))
  :hook
        (text-mode . flyspell-mode)
        (org-mode . flyspell-mode)
  )

(use-package flycheck
;; On the fly syntax checking for GNU Emacs
  :delight
  :config
        (add-to-list 'flycheck-gcc-include-path (getenv "unity_path"))
        (setq-default flycheck-disabled-checkers '(
            c/c++-clang
            emacs-lisp
            emacs-lisp-checkdoc
        ))
        (setq-default flycheck-enabled-checkers '(c/c++-gcc))
        (global-flycheck-mode)
  )

(use-package company-c-headers
;; Auto-completion for C/C++ headers using Company
  :config
        (add-to-list 'company-backends 'company-c-headers)
        (add-to-list 'company-c-headers-path-system (getenv "unity_path"))
  )

(use-package golden-ratio
;; Automatic resizing of Emacs windows to the golden ratio
  :delight
  :config
        (golden-ratio-mode 1)
        (setq golden-ratio-exclude-modes '(
            "gud-mode"
            "gdb-locals-mode"
            "gdb-registers-mode"
            "gdb-breakpoints-mode"
            "gdb-threads-mode"
            "gdb-frames-mode"
            "gdb-inferior-io-mode"
            "gdb-disassembly-mode"
            "gdb-memory-mode"
        ))
  )

(use-package pdf-tools
;; Emacs support library for PDF files.
  :mode
        ("\\.pdf\\'" . doc-view-mode)
  :general
        (
            :prefix "C-c n"
            "b" 'pdf-annot-list-annotations
         )
  :custom
        (pdf-annot-default-annotation-properties
            `((t (label . ,user-full-name))
                (text (icon . "Note")
                    (color . "#ff0000"))
                (highlight (color . "yellow")
                           (opacity . 1))
                (squiggly (color . "orange"))
                (strike-out(color . "red"))
                (underline (color . "blue")))
         )
  :hook
        (doc-view-mode . (lambda ()
            (pdf-tools-install)
            ; Use HiDPI for pdf.
            (setq pdf-view-use-scaling t)
        ))
  )

(use-package page-break-lines
;; display ugly ^L page breaks as tidy horizontal lines
  ;; :hook
  ;;       (text-mode . page-break-lines-mode)
  )

(use-package org
  :init
        (setq org-directory "~/Dropbox/org")
  :bind
        (
            ("C-c o c" . org-capture)
            ("C-c o a" . org-agenda)
            ("C-c o e" . org-export-dispatch)
            ("C-c o l" . org-store-link)
            ("C-c o s" . org-schedule)
            ("C-c o z" . org-toggle-archive-tag)
            ("C-c o o" . org-open-at-point)
            ("C-c o `" . org-mark-ring-goto)
            ("C-c o m" . org-mark-ring-push)
            ("C-c o t" . org-set-tags-command)
            ("C-c o i" . org-insert-structure-template)  ;; Insert #+BEGIN_SRC block
            ("C-c o v" . org-latex-preview)
            :map org-mode-map
            ("C-c a" . org-agenda)
            ("C-c C-x M-d" . org-clock-remove-overlays)
            ("C-c M-o" . org-mark-ring-goto)
         )
  :general
        (
            :states 'normal
            :keymaps 'org-mode-map
            ; Change evil default key binding for tab (Only "TAB" works in terminal, "<tab>" not working in terminal, but works in graphic)
            "TAB" 'org-cycle
            "g j" 'evil-next-visual-line
            "g k" 'evil-previous-visual-line
            "g ]" 'org-next-link
            "g [" 'org-previous-link
            "g s" 'org-set-property
            "g w" 'org-babel-tangle
            ;; "M-RET" 'org-insert-todo-heading-respect-content
         )
        (
            :keymaps 'org-mode-map
            :prefix "C-c o k"
            "i" 'org-clock-in
            "o" 'org-clock-out
            "g" 'org-clock-goto
            "G" 'org-clock-in-last
            "q" 'org-clock-cancel
            "p" 'org-clock-report
            "v" 'org-clock-display
            "e" 'org-clock-modify-effort-estimate
            "s" 'org-resolve-clocks
         )
  :config
        ; Log into a logbook drawer
        (setq org-log-into-drawer t)
        ; Add timestampt when item is done
        (setq org-log-done 'time)
        ; Add note and timestampt when item is rescheduled
        (setq org-log-reschedule 'note)
        ; org-refile
        (setq org-refile-targets '((org-agenda-files :maxlevel . 1)))
        ; provide refile targets as paths as well as filename. So a level 3 headline will be available as file/level1/level2/level3.
        (setq org-refile-use-outline-path 'file)
        (setq org-refile-allow-creating-parent-nodes 'confirm)
        ;; makes org-refile outline working with helm/ivy
        (setq org-outline-path-complete-in-steps nil)
        ;; save org buffers after org-refile
        (advice-add 'org-refile :after 'org-save-all-org-buffers)
        ;; For latex exporting
        (add-to-list 'org-latex-packages-alist '("" "tabularx" nil))
        (setq org-preview-latex-default-process 'imagemagick)
        (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))			;; Make latex preview bigger

        (setq org-enforce-todo-dependencies t)
        (setq org-enforce-todo-checkbox-dependencies t)
        (setq org-track-ordered-property-with-tag t)
        (setq org-clock-into-drawer "CLOCKING")
        (setq org-clock-out-remove-zero-time-clocks t)
        (setq org-clock-out-when-done t)
        (setq org-clock-report-include-clocking-task t)
        ;; use pretty things for the clocktable
        ;; (setq org-pretty-entities t)
        ;; Resume clocking task when emacs is restarted
        (org-clock-persistence-insinuate)
        ;; Save the running clock and all clock history when exiting Emacs, load it on startup
        (setq org-clock-persist t)
        ;; Resume clocking task on clock-in if the clock is open
        (setq org-clock-in-resume t)
        ;; Do not prompt to resume an active clock, just resume it
        (setq org-clock-persist-query-resume nil)
        (setq org-startup-indented t)
        (setq org-hide-leading-stars t)
        ; Add beamer for exporting option
        (add-to-list 'org-export-backends "beamer")
        ; Enable org-habit
        (add-to-list 'org-modules 'org-habit)
        (setq org-babel-python-command "python3")
        ; Use other source code languages in org
        (org-babel-do-load-languages
            'org-babel-load-languages
            '(
                (shell . t)
                (python . t)
                (dot . t)
            ))
        ; Don't ask for confirmation when execute the code block
        (setq org-confirm-babel-evaluate nil)
        ;; Add source block type
        (add-to-list 'org-structure-template-alist '("sh" . "src bash"))
        (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
        (add-to-list 'org-structure-template-alist '("py" . "src python"))

        ;; global Effort estimate values
        (setq org-global-properties
            '(("Effort_ALL" .
                "0:15 0:30 0:45 1:00 2:00 3:00 4:00 6:00 8:00")))
        (setq org-todo-keywords '((sequence "SOMEDAY(s!)" "TODO(t!)" "NEXT(n!)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
        ;; TODO state to which a repeater should return the repeating task.
        (setq org-todo-repeat-to-state "TODO")
        (setq org-tag-alist '(("Daily" . ?d) ("Research" . ?r) ("Learning" . ?l) ("Code" . ?c) ("IMPORTANT" . ?i) ("URGENT" . ?u) ("optional" . ?o) ("Emacs" . ?e)))
        (setq org-capture-templates
        '(
            ("e" "Journal Entry"
                entry (file+olp+datetree (lambda () (f-join org-directory "journal.org")))
                "* %?")
            ("j" "Journal Checklist"
                checkitem (file+olp+datetree (lambda () (f-join org-directory "journal.org")))
                "[/]\n- [ ] %?")
            ("c" "Checklist Item"
                plain (function (lambda nil (goto-char (point))))
                "*** Checklist\n- [ ] %?")
            ("i" "Inbox TODO"
                entry (file (lambda () (f-join org-directory "inbox.org")))
                "* SOMEDAY %?")
        ))
  :hook
        (org-mode . (lambda ()
            (visual-line-mode)
            "Beautify Org Checkbox Symbol"
            (push '("[ ]" . "☐") prettify-symbols-alist)
            (push '("[X]" . "☑" ) prettify-symbols-alist)
            (prettify-symbols-mode)))
  :custom-face
        (org-table ((t (:foreground "white"))))
        (org-headline-done ((t (:foreground "brightblack"))))
  )

(use-package visual-fill-column
  :custom
        (visual-fill-column-center-text t)
        (visual-fill-column-width 86)
  :hook
        (visual-line-mode . visual-fill-column-mode)
  )

(use-package org-indent
  :straight org
  :after
        (org)
  :delight
  )

(use-package org-id
  :straight org
  :after
        (org)
  :config
        ; Need this to resolve id links
        (setq org-id-link-to-org-use-id t)
        (setq org-id-locations-file (f-join org-directory ".org-id-locations"))
  )

(use-package org-agenda
  :straight org
  :after
        (org f)
  :preface
        (defun my-org-agenda-find-and-clock-in-remotely (item)
          ;; Clock in item in org agenda buffer, and don't change current buffer
            (with-current-buffer "*Org Agenda*"
                ;; (switch-to-buffer "*Org Agenda*")
                ;; (set-buffer "*Org Agenda*")
                (ignore-errors (org-agenda-clock-out))
                (goto-char (point-min))
                (search-forward item)
                (org-agenda-clock-in)
                (org-agenda-redo)
            )
        )
  :general
        (
            :states 'motion
            :keymaps 'org-agenda-mode-map
            "D" 'org-agenda-day-view
            "W" 'org-agenda-week-view
            "g a" 'org-agenda
            "g i" 'org-pomodoro
            "g q" 'org-agenda-columns
            "g l" 'org-agenda-log-mode
            "g ]" 'org-next-link
            "g [" 'org-previous-link
         )
  :config
        ; agenda files
        (setq org-agenda-files
            (f-files org-directory (lambda (file) (equal (f-ext file) "org")))
         )
        (setq org-agenda-start-with-clockreport-mode t)
        ;; Org agenda start from day view
        (setq org-agenda-span 'day)
        (setq org-agenda-start-with-log-mode t)
        ;; Display pomodoro's in agenda clock report
        (setq org-agenda-clockreport-parameter-plist
            '(:fileskip0 t :link t :maxlevel 2 :formula "$5=($3+$4)*(60/25);t"))
        ;; Add Effort to column view in agenda, default: "%25ITEM %TODO %3PRIORITY %TAGS"
        (setq org-columns-default-format "%1PRIORITY %50ITEM(Task) %TODO %5CLOCKSUM_T(Clock) %9Effort(Estimate){:} %9CLOCKSUM %TAGS")
        ;; Add custom view for agenda
        (add-to-list 'org-agenda-custom-commands
            '("L" "Agenda and non-scheduled TODO|SOMEDAY tasks" (
                (agenda "" (
                    ;; (org-agenda-span 1)
                    (org-agenda-span 'day)
                    (org-agenda-prefix-format '((agenda . " %1c %?-12t% s")))
                ))
                (todo "TODO|SOMEDAY" (
                    (org-agenda-overriding-header "=== TODO|SOMEDAY tasks without scheduled date ===")
                    (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
                    (org-agenda-prefix-format '((todo . " %1c ")))
                ))
        )))
        (add-to-list 'org-agenda-custom-commands
            '("l" "Agenda and non-scheduled TODO tasks" (
                (agenda "" (
                    (org-agenda-span 'day)
                    (org-agenda-prefix-format '((agenda . " %1c %?-12t% s")))
                ))
                (todo "TODO" (
                    (org-agenda-overriding-header "=== TODO tasks without scheduled date ===")
                    (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
                    (org-agenda-prefix-format '((todo . " %1c ")))
                ))
        )))
  :custom-face
        (org-agenda-dimmed-todo-face ((t (:inherit font-lock-keyword-face))))
  )

(use-package org-analyzer
;; org-analyzer creates an interactive visualization of org-mode time-tracking data, displays it in a web page in browser
  )

(use-package org-timeline
;; Add graphical view of agenda timeline to agenda buffer
  :hook
        (org-agenda-finalize . org-timeline-insert-timeline)
  :custom-face
        ;; Background
        (org-timeline-elapsed ((t (:background "brightblack"))))
        ;; Scheduled task
        (org-timeline-block ((t (:background "blue"))))
        (org-timeline-clocked ((t (:background "MediumSeaGreen"))))
  )

(use-package evil-org
;; Supplemental evil-mode keybindings to emacs org-mode
  :delight
  :after
        (evil org)
  :config
        (evil-org-set-key-theme '(navigation insert textobjects calendar))
  :hook
        (org-mode . evil-org-mode)
  )

(use-package evil-org-agenda
  :straight evil-org
  :after
        (evil org org-agenda)
  :hook
        (org-agenda-mode . (lambda ()
            (require 'evil-org-agenda)
            (evil-org-agenda-set-keys)
            (general-define-key
                :states 'motion
                :keymaps 'org-agenda-mode-map
                "i" 'org-agenda-clock-in
                "o" 'org-agenda-clock-out
                "H" 'org-agenda-earlier
                "L" 'org-agenda-later
                "TAB" 'org-agenda-goto
            )
        ))
  )

(use-package org-contrib
;; Org-mode Contributed Packages (https://orgmode.org/worg/org-contrib/)
  )

(use-package org-expiry
  :straight org-contrib
  :config
        ;; Log creation time when a TODO item is added.
        ;; (org-expiry-insinuate)
        ; Don't have everything in the agenda view
        (setq org-expiry-inactive-timestamps t)
  :hook
        (org-mode . org-expiry-insinuate)
  )

(use-package org-super-agenda
;; Supercharge your Org daily/weekly agenda by grouping items
  :general
        (
            :keymaps 'org-agenda-mode-map
            "g p" 'my-org-super-agenda-toggle
         )
  :preface
        (defun my-org-super-agenda-toggle ()
            ;; Toggle org-super-agenda-mode and refresh agenda
            (interactive)
            (if org-super-agenda-mode
                (org-super-agenda-mode -1)
                (org-super-agenda-mode 1)
                )
            (org-agenda-redo)
         )
  :config
        ;; items are automatically grouped by their category (which is usually the filename of the buffer they’re in)
        (setq org-super-agenda-groups
            '((:auto-category t)))
        ;; don't break evil on org-super-agenda headings
        (setq org-super-agenda-header-map (make-sparse-keymap))
  )

(use-package origami
;; A folding minor mode for Emacs (works with org agenda)
  :after
        (org-super-agenda)
  :bind
        (
            :map org-super-agenda-header-map
            ("TAB" . origami-toggle-node)
         )
  :hook
        (org-agenda-finalize . origami-mode)
  )

(use-package helm-org-rifle
;; searches rapidly through org files
  :general
        (
            :prefix "C-c o g"
            "g" 'helm-org-rifle
            "a" 'helm-org-rifle-agenda-files
            "d" 'helm-org-rifle-directories
            "f" 'helm-org-rifle-files
            "b" 'helm-org-rifle-current-buffer
            "o" 'helm-org-rifle-org-directory
            "n" 'helm-org-rifle-my-notes
         )
  :preface
        (defun helm-org-rifle-my-notes ()
            (interactive)
            (helm-org-rifle-directories (list (f-join org-directory "notes")))
         )
  )

(use-package org-ql
;; An Org-mode query language, including search commands and saved views
  )

(use-package calfw
;; A calendar framework for Emacs
  )

(use-package calfw-org
;; A calendar framework for Emacs org-mode
  :after
        (org calfw)
  :bind
        (
            ("C-c m c" . cfw:open-org-calendar)
         )
  :config
        (setq cfw:display-calendar-holidays nil)
  )

(use-package org-brain
;; Org-mode wiki + concept-mapping
  :after
        (org)
  :hook
        (org-brain-visualize-mode . (lambda ()
            (evil-set-initial-state 'org-brain-visualize-mode 'emacs)))
  )

(use-package org-projectile
;; Manage org-mode TODOs for your projectile projects
  :config
        ;; (setq org-projectile-projects-directory (f-join org-directory "projectile"))
        (setq org-projectile-projects-file (f-join org-directory "1_2_projects.org"))
        (push (org-projectile-project-todo-entry) org-capture-templates)
        ;; (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
        (setq org-confirm-elisp-link-function nil)
  )

(use-package org-ref
;; org-mode modules for citations, cross-references, bibliographies in org-mode and useful bibtex tools to go with it.
  :after
        (org ebib)
  :config
        (setq org-ref-default-bibliography ebib-preload-bib-files)
        (setq org-ref-pdf-directory ebib-file-search-dirs)
  )

(use-package biblio
;; Browse and import bibliographic references from CrossRef, DBLP, HAL, arXiv, Dissemin, and doi.org from Emacs
  )

(use-package ebib
;; A BibTeX database manager for Emacs. Ebib is a program for managing BibTeX and biblatex databases that runs inside Emacs. It allows you to manage bibliography files without having to edit the raw .bib files
  :after
        (org)
  :preface
        (defun my-ebib-get-author-names (key)
            (-->
            (ebib-get-field-value "author" key ebib--cur-db "default" 'unbraced)
            (s-split " and " it)
            (--map (car (s-split "," it)) it)
            (if (< 2 (length it))
                (concat (car it) " et al")
            (s-join " and " it))))

        (defun my-ebib-get-year (key)
            (or
            (ebib-get-field-value "year" key ebib--cur-db 'noerror 'unbraced)
            (ebib-get-field-value "date" key ebib--cur-db 'noerror 'unbraced)))

        (defun my-ebib-get-title (key)
            (-->
            (ebib-get-field-value "title" key ebib--cur-db "default" 'unbraced)
            (s-split ":" it)
            (car it)
            (replace-regexp-in-string "[{}]" "" it)
            (s-trim it)
            (s-truncate 100 it "")))

        (defun my-ebib-generate-filename (key)
            (let ((names (my-ebib-get-author-names key))
                (year (my-ebib-get-year key))
                (title (my-ebib-get-title key)))
            (->> (list names year title)
            (-filter #'identity) ; remove nil values
            (s-join "_")
            (replace-regexp-in-string " " "-")
            )))

        (defun my-ebib-add-newest-pdf-from-downloads ()
            "Add the most recently-downloaded PDF in the ~/Downloads directory to the current entry in ebib."
            (interactive)
            ;; pull out the most recent file from ~/Downloads with the .pdf extension.
            (let ((newest-pdf (caar (sort (mapcan (lambda (x) (when (string-equal (file-name-extension (nth 0 x)) "pdf") (cons x nil)))
                                                (directory-files-and-attributes my-pdf-download-dir))
                                        (lambda (x y) (not (time-less-p (nth 6 x) (nth 6 y))))))))
            (if newest-pdf
                ;; https://nullprogram.com/blog/2017/10/27/
                ;; need to override `read-file-name' because ebib normally prompts us for the file to import
                (let ((fpath (concat (file-name-as-directory my-pdf-download-dir) newest-pdf))
                        (bibkey (ebib--get-key-at-point)))
                    (cl-letf (((symbol-function 'read-file-name) (lambda (&rest _) fpath)))
                        (call-interactively #'ebib-import-file))
                    (message "my-ebib: Imported %s for %s" fpath bibkey))
                (message "my-ebib: No PDF files found in %s." my-pdf-download-dir))))

        (defun my-ebib-edit-url ()
            (interactive)
            (goto-char (point-min))
            (search-forward "url")
            (ebib-edit-field)
          )

        (defun my-ebib-edit-keywords ()
            (interactive)
            (goto-char (point-min))
            (search-forward "keywords")
            (ebib-edit-field)
          )

        (defun my-ebib-browse-url (arg)
            "Browse the URL in the \"url\" field.
            If the \"url\" field contains more than one URL, ask the user
            which one to open.  Alternatively, the user can provide a numeric
            prefix argument ARG."
            (interactive "P")
            (ebib--execute-when
                (entries
                (let ((urls (ebib-get-field-value "url" (ebib--get-key-at-point) ebib--cur-db 'noerror 'unbraced 'xref)))
                (if urls
                    (progn
                        ;; (ebib--call-browser (ebib--select-url urls (if (numberp arg) arg nil)))
                        (multi-vterm-dedicated-open)
                        (vterm-send-string (concat "browsh --firefox.with-gui --startup-url " (ebib--select-url urls (if (numberp arg) arg nil))) t)
                        (vterm-send-return)
                    )
                    (error "[Ebib] No URL found in url field"))))
                (default
                (beep))))

        (defun my-ebib-view-pdf (arg)
            "View a file in the \"file\" field.
            The \"file\" field may contain more than one filename.  In that
            case, a numeric prefix argument ARG can be used to specify which
            file to choose."
            (interactive "P")
            (ebib--execute-when
                (entries
                (let ((file (ebib-get-field-value "file" (ebib--get-key-at-point) ebib--cur-db 'noerror 'unbraced 'xref))
                        (num (if (numberp arg) arg nil)))
                    (progn
                        (multi-vterm-dedicated-open)
                        (vterm-send-string (concat "browsh_my_pdf '" (ebib--expand-file-name (ebib--select-file file num (ebib--get-key-at-point)))"'") t)

                        (vterm-send-return)
                    )))
                (default
                    (beep))))

        (defun my-ebib-popup-note (key)
            (interactive (list (ebib--get-key-at-point)))
            (my-orb-edit-note key)
          )

        (defun my-ebib-popup-video-note (key)
            (interactive (list (ebib--get-key-at-point)))
            (my-orb-edit-video-note key)
          )

        (defun my-ebib-add-reading-list-item-for-learning ()
            (interactive)
            (let ((ebib-reading-list-file (f-join org-directory "0_5_learning.org")))
              (ebib-add-reading-list-item)
            )
          )

        (defun my-ebib-clean-curly-braces-from-entry (field key db)
            "Return the contents of FIELD from KEY in DB without curly braces."
            (let
                ((field-value (cond
                               ((cl-equalp field "Author/Editor")
                                (or (ebib-get-field-value "Author" key db 'noerror 'unbraced 'xref)
                                    (ebib-get-field-value "Editor" key db "(No Author/Editor)" 'unbraced 'xref))
                                )
                               )
                  ))
                (replace-regexp-in-string "[{}]" "" field-value)
              )
          )
  :config
        (setq ebib-bibtex-dialect 'biblatex)
        (defvar my-ebib-dir (f-join org-directory "ebib")
            "my ebib directory")
        (defvar my-pdf-download-dir "~/Downloads/books"
            "my pdf download directory")
        (setq ebib-file-search-dirs (list (f-join my-ebib-dir "files")))
        (setq ebib-notes-directory (f-join my-ebib-dir "notes"))
        (setq ebib-preload-bib-files
            (f-files my-ebib-dir (lambda (file) (equal (f-ext file) "bib")))
         )
        ;; (setq ebib-file-associations '(("pdf" . "nohup evince %s")))
        (setq ebib-file-associations '(("pdf" . "zathura")))
        (setq ebib-name-transform-function #'my-ebib-generate-filename)
        (setq ebib-reading-list-file (f-join org-directory "0_4_reading.org"))
        ;; (setq ebib-browser-command "browsh --firefox.with-gui --startup-url %s")
  :general
        (my-space-leader-def
            "r e" 'ebib
         )
        (
            :states 'normal
            :keymaps 'ebib-index-mode-map
            "w" 'ebib-save-current-database
            "W" 'ebib-write-database
            "t" 'ebib-push-citation
            "T" 'ebib-browse-doi
            ;; "s" 'ebib-jump-to-entry
            "/" 'swiper
            "i" 'isbn-to-bibtex
            "I" 'my-ebib-add-newest-pdf-from-downloads
            "Fo" 'ebib-view-file
            "u" 'my-ebib-browse-url
            "f" 'my-ebib-view-pdf
            ;; "n" 'my-ebib-popup-note
            "RA" 'my-ebib-add-reading-list-item-for-learning
         )
        (
            :states 'normal
            :keymaps 'ebib-entry-mode-map
            "w" 'ebib-save-current-database
            "W" 'ebib-write-database
            "i" 'isbn-to-bibtex
            "I" 'my-ebib-add-newest-pdf-from-downloads
            "u" 'my-ebib-edit-url
            "t" 'my-ebib-edit-keywords
         )
        (
            :states 'normal
            :keymaps 'ebib-log-mode-map
            "q" 'ebib-quit-log-buffer
         )
  :hook
        (ebib-index-mode . (lambda ()
            (require 'org-roam-bibtex)
            (general-define-key
                :states 'normal
                :keymaps 'ebib-index-mode-map
                "n" 'my-ebib-popup-note
                "N" 'my-ebib-popup-video-note
            )
            (general-define-key
                :states 'normal
                :keymaps 'ebib-entry-mode-map
                "n" 'my-ebib-popup-note
                "N" 'my-ebib-popup-video-note
            )
        ))
  :custom
        (ebib-field-transformation-functions
         '(
           ("Title" . ebib-clean-TeX-markup-from-entry)
           ("Doi" . ebib-display-www-link)
           ("Url" . ebib-display-www-link)
           ("Note" . ebib-notes-display-note-symbol)
           ("Author/Editor" . my-ebib-clean-curly-braces-from-entry)
           )
         )
  )

(use-package ebib-biblio
  :straight ebib
  :after
        (ebib biblio)
  :bind
        (
            :map biblio-selection-mode-map
            ("i" . ebib-biblio-selection-import)
         )
  )

(use-package helm-bibtex
;; A bibliography manager based on Helm
  :after
        (ebib)
  :bind
        (
            :map helm-command-map
            ("b" . helm-bibtex)
        )
  :config
        (setq bibtex-completion-bibliography ebib-preload-bib-files)
        (setq bibtex-completion-library-path ebib-file-search-dirs)
        (setq bibtex-completion-pdf-field "file")
        (setq bibtex-completion-notes-path ebib-notes-directory)
  )

(use-package org-web-tools
;; View, capture, and archive Web pages in Org-mode
  :general
        (
            :prefix "C-c o w"
            "u" 'org-web-tools-insert-link-for-url
            ;; "w" 'org-web-tools-read-url-as-org
            "w" 'org-web-tools-insert-web-page-as-entry
            ;; "v" 'org-web-tools-convert-links-to-page-entries
            ;; "t" 'org-web-tools-archive-attach
            ;; "V" 'org-web-tools-archive-view
         )
  )

(use-package org-download
;; Drag and drop images to Emacs org-mode
  :hook
        (org-mode . org-download-enable)
  )

(use-package org-board
;; Org mode's web archiver
  :bind-keymap
        ("C-c o b" . org-board-keymap)
  )

(use-package org-pomodoro
;; pomodoro technique for org-mode
  :after
        (org)
  :bind
        (
            ("C-c o T" . org-pomodoro)
         )
  :custom
        (org-pomodoro-audio-player (executable-find "mpv"))
        ;; Play ticking sound
        (org-pomodoro-ticking-sound-p t)
        (org-pomodoro-ticking-frequency 5)
        ;; (org-pomodoro-ticking-sound-states '(:pomodoro :short-break :long-break))
        (org-pomodoro-ticking-sound-states '(:pomodoro))
        ;; Long break 25 minutes
        (org-pomodoro-long-break-length 25)
        (org-pomodoro-short-break-sound (expand-file-name "~/Dropbox/Sounds/Alert/Sunny_Day.mp3"))
        (org-pomodoro-long-break-sound (expand-file-name "~/Dropbox/Sounds/Alert/Sunny_Day.mp3"))
        (org-pomodoro-finished-sound (expand-file-name "~/Dropbox/Sounds/Alert/Little_Crystal.mp3"))
  )

(use-package hide-mode-line
;; An Emacs plugin that hides (or masks) the current buffer's mode-line
  )

(use-package org-present
;; Ultra-minimalist presentation minor-mode for Emacs org-mode
  :after
        (org)
  :config
        ;; Some evil keybindings are made afterwards because of the eval-after-load. There's nothing general can do about this. You need to use with-eval-after-load/:config
        (general-define-key
            :definer 'minor-mode
            :states 'motion
            :keymaps 'org-present-mode
            "<left>" 'org-present-prev
            "<right>" 'org-present-next
            "k" 'org-present-prev
            "j" 'org-present-next
            "g g" 'org-present-beginning
            "G" 'org-present-end
         )
  :hook
        (org-present-mode . (lambda ()
            (org-display-inline-images)
            (org-present-read-only)
            (org-present-hide-cursor)
            (hide-mode-line-mode +1)
         ))
        (org-present-mode-quit . (lambda ()
            (org-remove-inline-images)
            (org-present-read-write)
            (org-present-show-cursor)
            (hide-mode-line-mode -1)
         ))
  )

(use-package org-tree-slide
;; A presentation tool for org-mode based on the visibility of outline trees
  :after
        (org)
  :config
        ;; Some evil keybindings are made afterwards because of the eval-after-load. There's nothing general can do about this. You need to use with-eval-after-load/:config
        (general-define-key
            :definer 'minor-mode
            :states 'motion
            :keymaps 'org-tree-slide-mode
            "<left>" 'org-tree-slide-move-previous-tree
            "<right>" 'org-tree-slide-move-next-tree
            "k" 'org-tree-slide-move-previous-tree
            "j" 'org-tree-slide-move-next-tree
         )
  :hook
        (org-tree-slide-play . (lambda ()
            (org-display-inline-images)
            ;; (setq text-scale-mode-amount 3)
            ;; (text-scale-mode 1)
            (visual-fill-column-mode 1)
            (hide-mode-line-mode +1)
         ))
        (org-tree-slide-stop . (lambda ()
            (org-remove-inline-images)
            ;; (text-scale-mode 0)
            (visual-fill-column-mode 0)
            (hide-mode-line-mode -1)
         ))
  )

(use-package ox-reveal
;; Exports Org-mode contents to Reveal.js HTML presentation
  :custom
        (org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
        (org-reveal-hlevel 2)
        (org-reveal-reveal-js-version 4)
  )

(use-package org-appear
;; Toggle visibility of hidden Org mode element parts upon entering and leaving an element
  :custom
        (org-appear-autolinks t)
  )

(use-package org-noter
;; Emacs document annotator, using Org-mode. Org-noter is compatible with docview, pdf-tools, and nov.el. These modes make it possible to annotate PDF, EPUB, Microsoft Office, DVI, PS, and OpenDocument
  :general
        (
            :prefix "C-c n"
            "n" 'org-noter
            "i" 'org-noter-insert-note
            "." 'org-noter-sync-current-note
         )
  )

(use-package org-roam
;; Rudimentary Roam replica with Org-mode
  :preface
        (defun my-org-get-contents-of-entry ()
          "Get the content text of the entry at point
        Excludes the heading and any child subtrees."
          (if (org-before-first-heading-p)
              (message "Not in an org heading")
            (save-excursion
              ;; If inside heading contents, move the point back to the heading
              ;; otherwise `org-agenda-get-some-entry-text' won't work.
              (unless (org-on-heading-p) (org-previous-visible-heading 1))
              (substring-no-properties
                (org-agenda-get-some-entry-text
                (point-marker)
                most-positive-fixnum))
            )))

        (defun my-pdf-delete-all-annotations ()
          (interactive)
          (let (
                 (my-pdf-annots (pdf-annot-getannots nil pdf-annot-list-listed-types))
                 )
            (dolist (my-pdf-annot my-pdf-annots)
                (pdf-annot-delete my-pdf-annot)
              )
            )
          )

        (defun my-pdf-get-search-regex-string (str)
          (s-replace " " "( |\\n)"
            ;; (s-replace-regexp "[^[:ascii:]]" "." str)
            (s-replace-regexp "[\]\[\(\)]" "."
              (s-replace "." "\\." str)
                )
            )
          )

        (defun my-get-nth-from-list-fn (n)
            (lambda (list)
              (funcall 'nth n list))
          )

        (defun my-org-roam-highlight-pdf-by-excerpt ()
          (interactive)
          (let* (
                (my-pdf-highlight-color-index-alist
                 '(
                    ;; Colors that marginnote use, they will change when marking more than once
                    ;; (0 . "#ffffc3")		;; Yellow
                    ;; (1 . "#d1fed0")		;; Green
                    ;; (2 . "#c5dfff")		;; Blue
                    ;; Colors that won't change when marking more than once
                    (0 . "#ffff00")		;; Yellow
                    (1 . "#03ff00")		;; Green
                    (2 . "#02ffff")		;; Blue
                  )
                 )
                (pdf-file-path (org-entry-get nil "NOTER_DOCUMENT" t))
                ;; (pdf-file-name (file-name-nondirectory pdf-file-path))
                (pdf-start-page (string-to-number (org-entry-get nil "NOTER_PAGE" t)))
                (pdf-end-page (string-to-number (org-entry-get nil "NOTER_PAGE_END" t)))
                (highlight-color-index (string-to-number (org-entry-get nil "HIGHLIGHT_COLOR_INDEX" t)))
                (highlight-color (alist-get highlight-color-index my-pdf-highlight-color-index-alist))
                (excerpt (my-org-get-contents-of-entry))
                (paragraphs-of-excerpt (split-string excerpt "\n\n"))
                )
            (switch-to-buffer-other-window (or (get-file-buffer pdf-file-path)
                                                (find-file-noselect pdf-file-path)))
            (message "%s" highlight-color)
            (dolist (paragraph paragraphs-of-excerpt)
              (message (my-pdf-get-search-regex-string (substring paragraph -40)))
              (let* (
                    (case-fold-search nil)		;; Don't ignore case in search
                    (search-string-length 40)
                    ;; If paragraph is less than search-string-length, just use whole paragraph
                    (search-string-head (or (substring paragraph 0 search-string-length) paragraph))
                    (search-string-tail (or (substring paragraph (- search-string-length)) paragraph))
                    (matches-head
                        (pdf-info-search-regexp (my-pdf-get-search-regex-string search-string-head)
                                                (cons pdf-start-page pdf-end-page) nil pdf-file-path)
                      )
                    (matches-tail
                        (pdf-info-search-regexp (my-pdf-get-search-regex-string search-string-tail)
                                                (cons pdf-start-page pdf-end-page) nil pdf-file-path)
                      )
                    (matches-head-alist (car matches-head))
                    (matches-tail-alist (car matches-tail))
                    (matches-head-page (alist-get 'page matches-head-alist))
                    (matches-tail-page (alist-get 'page matches-tail-alist))
                    (matches-head-edges (alist-get 'edges matches-head-alist))
                    (matches-tail-edges (alist-get 'edges matches-tail-alist))
                    (matches-coordinate-left (apply 'max (mapcar (my-get-nth-from-list-fn 0) matches-head-edges)))
                    (matches-coordinate-top (apply 'min (mapcar (my-get-nth-from-list-fn 1) matches-head-edges)))
                    (matches-coordinate-right (apply 'min (mapcar (my-get-nth-from-list-fn 2) matches-tail-edges)))
                    (matches-coordinate-bottom (apply 'max (mapcar (my-get-nth-from-list-fn 3) matches-tail-edges)))
                    )
                (message "%s\n" matches-head)
                (message "%s\n" matches-tail)
                ;; Markup text between head and tail
                (cond
                 ((= matches-head-page matches-tail-page)
                    (pdf-view-goto-page matches-head-page)
                    (pdf-annot-add-markup-annotation (list
                                                      matches-coordinate-left
                                                      matches-coordinate-top
                                                      matches-coordinate-right
                                                      matches-coordinate-bottom)
                                                     'highlight highlight-color)
                  )
                 ((< matches-head-page matches-tail-page)
                    (pdf-view-goto-page matches-head-page)
                    (let* (
                          (page-edges (pdf-info-textregions matches-head-page))
                          (page-edge-right (apply 'max (mapcar (my-get-nth-from-list-fn 2) page-edges)))
                          (page-edge-bottom (apply 'max (mapcar (my-get-nth-from-list-fn 3) page-edges)))
                          )
                      (pdf-annot-add-markup-annotation (list
                                                        matches-coordinate-left
                                                        matches-coordinate-top
                                                        page-edge-right
                                                        page-edge-bottom)
                                                        'highlight highlight-color)
                      )
                    (let ((current-processing-page (1+ matches-head-page)))
                      (unless (= current-processing-page matches-tail-page)
                        (pdf-view-goto-page current-processing-page)
                        (let* (
                              (page-edges (pdf-info-textregions current-processing-page))
                              (page-edge-left (apply 'min (mapcar (my-get-nth-from-list-fn 0) page-edges)))
                              (page-edge-top (apply 'min (mapcar (my-get-nth-from-list-fn 1) page-edges)))
                              (page-edge-right (apply 'max (mapcar (my-get-nth-from-list-fn 2) page-edges)))
                              (page-edge-bottom (apply 'max (mapcar (my-get-nth-from-list-fn 3) page-edges)))
                              )
                          (pdf-annot-add-markup-annotation (list
                                                            page-edge-left
                                                            page-edge-top
                                                            page-edge-right
                                                            page-edge-bottom)
                                                            'highlight highlight-color)
                          )
                        (cl-incf current-processing-page)
                        )
                      )
                    (pdf-view-goto-page matches-tail-page)
                    (let* (
                          (page-edges (pdf-info-textregions matches-tail-page))
                          (page-edge-left (apply 'min (mapcar (my-get-nth-from-list-fn 0) page-edges)))
                          (page-edge-top (apply 'min (mapcar (my-get-nth-from-list-fn 1) page-edges)))
                          )
                      (pdf-annot-add-markup-annotation (list
                                                        page-edge-left
                                                        page-edge-top
                                                        matches-coordinate-right
                                                        matches-coordinate-bottom)
                                                        'highlight highlight-color)
                      )
                  )
                 ((> matches-head-page matches-tail-page)
                  (error "Search failed, please check the excerpt and matched strings")
                  )
                 )

                ;; Markup all matches edges
                (pdf-annot-add-markup-annotation matches-tail-edges 'highlight highlight-color)
                (pdf-view-goto-page matches-head-page)
                (pdf-annot-add-markup-annotation matches-head-edges 'highlight highlight-color)
                )
              )
            )
        )

        (defun my-org-roam-filter-by-tag (tag-name)
          (lambda (node)
            (member tag-name (org-roam-node-tags node))))

        (defun my-org-roam-list-notes-by-tag (tag-name)
          (mapcar #'org-roam-node-file
                  (seq-filter
                   (my-org-roam-filter-by-tag tag-name)
                   (org-roam-node-list))))

        (defun my-org-roam-filter-by-tag-list (tag-name-list)
          (lambda (node)
            (seq-intersection tag-name-list (org-roam-node-tags node))))

        (defun my-org-roam-list-notes-by-tag-list (tag-name-list)
          (mapcar #'org-roam-node-file
                  (seq-filter
                   (my-org-roam-filter-by-tag-list tag-name-list)
                   (org-roam-node-list))))

        (defun my-org-roam-find-literature ()
          (interactive)
          ;; Select a literature note to open, creating it if necessary
          (org-roam-node-find
           nil
           nil
           (my-org-roam-filter-by-tag "literature")
           :templates
           '(
                ("r" "bibliography reference" plain "%?"
                    :if-new
                    (file+head "literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: literature")
                    :immediate-finish t
                    :unnarrowed t)
                )
           ))

        (defun my-org-roam-find-wiki ()
          (interactive)
          ;; (with-current-buffer (find-file-noselect (f-join org-directory "wiki" ".dir-locals.el"))
          ;;   (save-excursion
          ;;       (org-roam-node-find)
          ;;     )
          ;;   )
          (org-roam-node-find
           nil
           nil
           (my-org-roam-filter-by-tag "wiki")
           :templates
           '(
                ("r" "bibliography reference" plain "%?"
                    :if-new
                    (file+head "wiki/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: wiki")
                    :immediate-finish t
                    :unnarrowed t)
                )
           ))

        ;; (defun my-org-roam-find-project ()
        ;;   (interactive)
        ;;   (org-roam-node-find
        ;;    nil
        ;;    nil
        ;;    (my-org-roam-filter-by-tag "project")
        ;;    :templates
        ;;    '(
        ;;         ("r" "bibliography reference" plain "%?"
        ;;             :if-new
        ;;             (file+head "project/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: project")
        ;;             :immediate-finish t
        ;;             :unnarrowed t)
        ;;         )
        ;;    ))

        (defun my-org-roam-find-project ()
          ;; (interactive "sproject name: ")
          (interactive)
          (let* (
                 (my-roam-project-dir (f-join org-roam-directory "project"))
                 (my-roam-project-list (mapcar 'f-filename (f-directories my-roam-project-dir)))
                 (my-roam-find-or-create-project-note (lambda (my-project-name)
                    ;; Put my-project-name to latest kill in the kill-ring, then use %c in template to use it
                                                ;; (message my-project-name)
                    (kill-new my-project-name)
                    (ignore-errors (make-directory (f-join my-roam-project-dir my-project-name)))
                    (org-roam-node-find
                    nil
                    nil
                    (my-org-roam-filter-by-tag-list '("project" my-project-name))
                    :templates
                    '(
                            ("r" "bibliography reference" plain "%?"
                                :if-new
                                (file+head "project/%c/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :project:%c:")
                                :immediate-finish t
                                :unnarrowed t)
                            )
                        )
                    )
                  )
                 )
            (ivy-read "roam projects: " my-roam-project-list
                      :action my-roam-find-or-create-project-note
                      )

            ;; Can't make helm source work... ivy-read is much easier to use
            ;; (helm :sources (helm-build-sync-source "roam projects"
            ;;                  :candidates my-roam-project-list
            ;;                  :action my-roam-find-or-create-project-note
            ;;                  )
            ;; )
          )
        )

        (defun my-org-roam-filter-exclude-tag (tag-name)
          (lambda (node)
            (not (member tag-name (org-roam-node-tags node)))))

        (defun my-org-roam-list-notes-exclude-tag (tag-name)
          (mapcar #'org-roam-node-file
                  (seq-filter
                   (my-org-roam-filter-exclude-tag tag-name)
                   (org-roam-node-list))))

        (defun my-org-roam-filter-exclude-tag-list (tag-name-list)
          (lambda (node)
            (not (seq-intersection tag-name-list (org-roam-node-tags node)))))

        (defun my-org-roam-list-notes-exclude-tag-list (tag-name-list)
          (mapcar #'org-roam-node-file
                  (seq-filter
                   (my-org-roam-filter-exclude-tag-list tag-name-list)
                   (org-roam-node-list))))

        (defun my-org-roam-find-ever-green ()
          (interactive)
          ;; Select a ever green note to open (exclude literature notes), creating it if necessary
          (org-roam-node-find
           nil
           nil
           (my-org-roam-filter-exclude-tag-list '("literature" "wiki" "project"))
           ))

  :general
        (
            :prefix "C-c n"
            ;; "r" 'org-roam
            "f" 'org-roam-node-find
            ;; "g" 'org-roam-graph
            "i" 'org-roam-node-insert
            "c" 'org-roam-capture
            ;; Show backlinks
            "v" 'org-roam-buffer-toggle
            ;; Dailies
            "j" 'org-roam-dailies-capture-today
            "." 'org-roam-dailies-goto-today
            ;; Customised functions
            "s" 'my-org-roam-find-ever-green
            "l" 'my-org-roam-find-literature
            "w" 'my-org-roam-find-wiki
            "p" 'my-org-roam-find-project
            "h" 'my-org-roam-highlight-pdf-by-excerpt
            "k" 'my-pdf-delete-all-annotations
         )
  :init
        (setq org-roam-v2-ack t)
  :config
        ;; Customize slug of roam node: truncate slug if too long
        (cl-defmethod org-roam-node-slug ((node org-roam-node))
          "Return the slug of NODE."
          (let ((title (org-roam-node-title node))
                (slug-trim-chars '(;; Combining Diacritical Marks https://www.unicode.org/charts/PDF/U0300.pdf
                                   768 ; U+0300 COMBINING GRAVE ACCENT
                                   769 ; U+0301 COMBINING ACUTE ACCENT
                                   770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
                                   771 ; U+0303 COMBINING TILDE
                                   772 ; U+0304 COMBINING MACRON
                                   774 ; U+0306 COMBINING BREVE
                                   775 ; U+0307 COMBINING DOT ABOVE
                                   776 ; U+0308 COMBINING DIAERESIS
                                   777 ; U+0309 COMBINING HOOK ABOVE
                                   778 ; U+030A COMBINING RING ABOVE
                                   780 ; U+030C COMBINING CARON
                                   795 ; U+031B COMBINING HORN
                                   803 ; U+0323 COMBINING DOT BELOW
                                   804 ; U+0324 COMBINING DIAERESIS BELOW
                                   805 ; U+0325 COMBINING RING BELOW
                                   807 ; U+0327 COMBINING CEDILLA
                                   813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
                                   814 ; U+032E COMBINING BREVE BELOW
                                   816 ; U+0330 COMBINING TILDE BELOW
                                   817 ; U+0331 COMBINING MACRON BELOW
                                   )))
            (cl-flet* ((nonspacing-mark-p (char)
                                          (memq char slug-trim-chars))
                       (strip-nonspacing-marks (s)
                                               (string-glyph-compose
                                                (apply #'string (seq-remove #'nonspacing-mark-p
                                                                            (string-glyph-decompose s)))))
                       (cl-replace (title pair)
                                   (replace-regexp-in-string (car pair) (cdr pair) title)))
              (let* ((pairs `(("[^[:alnum:][:digit:]]" . "_") ;; convert anything not alphanumeric
                              ("__*" . "_")                   ;; remove sequential underscores
                              ("^_" . "")                     ;; remove starting underscore
                              ("_$" . "")))                   ;; remove ending underscore
                     (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
                (downcase (truncate-string-to-width slug 125))))))

        (setq org-roam-completion-system 'helm)
        (org-roam-db-autosync-mode)
        (setq org-roam-capture-templates
            '(
                ("d" "default" plain "%?"
                    :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
                    :immediate-finish t
                    :unnarrowed t)
                ;; ("r" "bibliography reference" plain "%?"
                ;;     :if-new
                ;;     (file+head "literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
                ;;     :immediate-finish t
                ;;     :unnarrowed t)
                ;; ("d" "default" plain "%?" :target
                    ;; (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
                    ;; :unnarrowed t)
            )
        )
        ;; (add-to-list 'safe-local-variable-values
        ;;     '(eval setq-local org-roam-db-location
        ;;             (expand-file-name "~/.emacs.d/org-roam-wiki.db"))
        ;; )
        ;; (add-to-list 'safe-local-variable-values
        ;;     '(eval setq-local org-roam-directory
        ;;         (expand-file-name
        ;;             (locate-dominating-file default-directory ".dir-locals.el")))
        ;; )
  ;; :hook
  ;;       (after-init . org-roam-mode)
  :custom
        (org-roam-directory (f-join org-directory "roam"))
        (org-roam-dailies-directory "fleeting/")
  )

(use-package org-roam-bibtex
;; Connector between Org-roam, BibTeX-completion, and Org-ref
  :preface
        (defun my-orb-edit-note (citekey)
          (let ((org-roam-capture-templates
                   '(
                        ("r" "bibliography reference" plain "%?"
                            :if-new
                            (file+head "literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
#+filetags: :${citekey}:book:literature:

* ${title}
:PROPERTIES:
:NOTER_DOCUMENT: ${file}
:END:
")
                            :immediate-finish t
                            :unnarrowed t)
                    )
                 ))
              (orb-edit-note citekey)))
        (defun my-orb-edit-video-note (citekey)
          (let ((orb-process-file-keyword nil)		;; Don't check file since it will be a directory most of time
                (org-roam-capture-templates
                   '(
                        ("r" "bibliography reference" plain "%?"
                            :if-new
                            (file+head "literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
#+filetags: :${citekey}:video:literature:

* ${title}
:PROPERTIES:
:MPV_VIDEO_DIRECTORY: ${file}
:END:
")
                            :immediate-finish t
                            :unnarrowed t)
                    )
                 ))
              (orb-edit-note citekey)))
  :config
        (org-roam-bibtex-mode)
  :custom
        (orb-roam-ref-format 'org-ref-v3)
  )

(use-package org-roam-ui
;; A graphical frontend for exploring your org-roam Zettelkasten
  :custom
        (org-roam-ui-browser-function 'browse-url-chrome)
  )

(use-package org-journal
;; A simple org-mode based journaling mode
  :bind
        (
            ("C-c o j" . org-journal-new-entry)
         )
  :custom
        (org-journal-dir (f-join org-directory "journal"))
        (org-journal-file-format "%Y-%m-%d.org")
        (org-journal-date-prefix "#+TITLE: ")
  )

(use-package nov
;; Major mode for reading EPUBs in Emacs
  :mode
        ("\\.epub\\'" . nov-mode)
  :general
        (
            :states 'normal
            :keymaps 'nov-mode-map
            "u" 'nov-scroll-up
            "U" 'nov-scroll-down
         )
  :hook
        (nov-mode . (lambda ()
            (setq left-margin-width 5)
            (setq right-margin-width 5)
            (visual-line-mode 1)
            (face-remap-add-relative 'default
                                    :background "white"
                                    :foreground "black")
        ))
  )

(use-package deft
;; Deft is an Emacs mode for quickly browsing, filtering, and editing directories of plain text notes
  :bind
        (
            ("C-c n d" . deft)
         )
  :general
        (
            :states 'normal
            :keymaps 'deft-mode-map
            "q" 'kill-current-buffer
         )
  :config
        (setq deft-directory org-directory)
        (setq deft-recursive t)
  :hook
        (deft-mode . (lambda ()
            (evil-set-initial-state 'deft-mode 'insert)))
  )

;; (use-package howm
;; ;; a note-taking tool on Emacs. It is similar to emacs-wiki.el
;;   :config
;;         (setq howm-directory (f-join org-directory "howm"))
;;   :custom-face
;;         (howm-mode-title-face ((t (:foreground "#BDBA9F"))))
;;         (howm-reminder-today-face ((t (:foreground "#55C0D2"))))
;;   )

(use-package anki-editor
;; Emacs minor mode for making Anki cards with Org
  :after
        (org org-expiry)
  ;; :bind
  ;;       (
  ;;           ("C-c m i" . anki-editor-insert-note)
  ;;           ("C-c m p" . anki-editor-push-tree)
  ;;           ("C-c m P" . anki-editor-push-notes)
  ;;           ("C-c m z z" . anki-editor-cloze-dwim)
  ;;           ("C-c m z a" . anki-editor-cloze-region-auto-incr)
  ;;           ("C-c m z p" . anki-editor-cloze-region-dont-incr)
  ;;           ("C-c m z r" . anki-editor-reset-cloze-number)
  ;;        )
  :preface
        (defun anki-editor-cloze-region-auto-incr (&optional arg)
            "Cloze region without hint and increase card number."
            (interactive)
            (anki-editor-cloze-region my-anki-editor-cloze-number "")
            (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
            (forward-sexp))
        (defun anki-editor-cloze-region-dont-incr (&optional arg)
            "Cloze region without hint using the previous card number."
            (interactive)
            (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
            (forward-sexp))
        (defun anki-editor-reset-cloze-number (&optional arg)
            "Reset cloze number to ARG or 1"
            (interactive)
            (setq my-anki-editor-cloze-number (or arg 1)))
        (defun anki-editor-push-tree ()
            "Push all notes under a tree."
            (interactive)
            (anki-editor-push-notes '(4))
            (anki-editor-reset-cloze-number))
        (defun anki-reload ()
            (interactive)
            (unload-feature 'anki-editor)
            (anki-editor-mode))
  :config
        (setq anki-editor-create-decks t) ;; Allow anki-editor to create a new deck if it doesn't exist
  :hook
        (find-file . (lambda ()
            (when (and (stringp buffer-file-name)
                (string-match "\\.anki\\.org\\'" buffer-file-name))
                (anki-editor-mode))))
        (anki-editor-mode . (lambda ()
            (org-expiry-deinsinuate)    ;; Don't log creation for anki-editor-mode
            (visual-line-mode)
            (anki-editor-reset-cloze-number)
        ))
  )

(use-package define-word
;; Lets you see the definition of a word or a phrase at point, without having to switch to a browser
  :bind
        (
            ("C-c m W" . define-word)
            ("C-c m w" . define-word-at-point)
         )
  :custom
        (define-word-default-service 'webster)
  )

(use-package emamux
;; tmux manipulation from Emacs
  :bind-keymap
        ("C-c x" . emamux:keymap)
  :bind
        (
            :map emamux:keymap
            ("y" . emamux:copy-kill-ring)
            ("p" . emamux:yank-from-list-buffers)
            ("k" . emamux:close-panes)
            ("s" . emamux:send-command)
            ("r" . emamux:run-command)
            ("!" . emamux:run-region)
            ("." . emamux:run-last-command)
            ("x" . eshell)
            ("t" . term)
            ("i" . ielm)
         )
  :general
        (my-space-leader-def
            "x y" 'emamux:copy-kill-ring
            "x p" 'emamux:yank-from-list-buffers
            "x e" 'eshell
            "x t" 'term
            "x i" 'ielm
         )
  :custom
        (emamux:completing-read-type 'helm)
        (emamux:show-buffers-with-index nil)
        (emamux:get-buffers-regexp
            "^\\(buffer[0-9]+\\): +\\([0-9]+\\) +\\(bytes\\): +[\"]\\(.*\\)[\"]")
  )

;; (use-package aweshell
  ;; )

(use-package eshell-prompt-extras
;; Display extra information and color for your eshell prompt
  :config
        (with-eval-after-load "esh-opt"
            (autoload 'epe-theme-lambda "eshell-prompt-extras")
            (setq eshell-highlight-prompt nil
                  eshell-prompt-function 'epe-theme-lambda))
        ;; zsh will be slow, fish is even slower for git repo directory
        (setq shell-file-name "/bin/sh")
  :custom-face
        (epe-dir-face ((t (:foreground "blue" :weight bold))))
        (epe-git-face ((t (:foreground "yellow"))))
  )

(use-package exec-path-from-shell
;; Make Emacs use the PATH set up by the user's shell
  :config
        (when (memq window-system '(mac ns x))
            (exec-path-from-shell-initialize))
  )

(use-package eshell-up
;; Quickly go to a specific parent directory in eshell using the eshell-up function, which can be bound to an eshell alias such as up
  )

(use-package eshell-did-you-mean
;; command not found ("did you mean…" feature) in Eshell
  :config
        (eshell-did-you-mean-setup)
  )

(use-package quickrun
;; Run command quickly, quickrun.el is a extension to execute editing buffer. quickrun.el execute not only script languages(Perl, Ruby, Python etc), but also compiling languages(C, C++, Go, Java etc) and markup language
  :general
        (my-space-leader-def
            "x b" 'quickrun
         )
  :config
        (quickrun-add-command "python"
          '((:command . "python3"))
          :override t)
  )

(use-package fish-mode
;; Emacs major mode for fish shell scripts
  )

(use-package fish-completion
;; Emacs fish completion
  :config
        (when (and (executable-find "fish")
                (require 'fish-completion nil t))
          (global-fish-completion-mode))
  )

(use-package which-key
;; Emacs package that displays available keybindings in popup
  :delight
  :general
        (
            :prefix "C-h"
            "K" 'which-key-C-h-dispatch
         )
  :init
        (which-key-mode)
  :config
        (setq which-key-allow-evil-operators t)
        (setq which-key-show-operator-state-maps t)
  )

(use-package helpful
;; A better Emacs *help* buffer
  :general
        (
            :prefix "C-h"
            "f" 'helpful-callable
            "v" 'helpful-variable
            "k" 'helpful-key
            "x" 'helpful-at-point
            "F" 'helpful-function
            "D" 'helpful-command
         )
  )

(use-package undo-propose
;; Navigate the emacs undo history by staging undo's in a temporary buffer
  ;; :config
  ;;        (global-undo-tree-mode -1)
  :general
        (
            :states 'normal
            "U" 'undo-propose
         )
  )

(use-package eshell-z
;; cd to frequent directory in eshell. Instead of using cd in eshell, just use z, can jump by giving a keyword
  :hook
        (eshell-mode . (lambda ()
            (require 'eshell-z)
        ))
  )

(use-package popup
;; Visual Popup Interface Library for Emacs
  :custom-face
        (popup-face ((t (:inherit company-tooltip))))
        (popup-menu-selection-face ((t (:inherit company-tooltip-selection :foreground "white"))))
        (popup-tip-face ((t (:background "lightgray" :foreground "black"))))
  )

(use-package company-quickhelp
;; Documentation popup for Company
  :bind
        (
            :map company-active-map
            ("C-c h" . company-quickhelp-manual-begin)
         )
  :config
        (setq company-quickhelp-delay nil)
        (company-quickhelp-mode)
  )

(use-package company-quickhelp-terminal
;; Terminal support for company-quickhelp
  :config
        (with-eval-after-load 'company-quickhelp
            (company-quickhelp-terminal-mode 1))
  )

(use-package highlight-indentation
;; Minor modes to highlight indentation guides in emacs. This minor mode highlights indentation levels via font-lock
  :custom-face
        (highlight-indentation-face ((t (:background "color-235"))))
  )

;; (use-package elpy
;; Emacs Python Development Environment
;;   :general
;;         (
;;             :states 'normal
;;             :keymaps 'elpy-mode-map
;;             "M-." 'elpy-goto-definition
;;          )
;;   :config
;;         (setq elpy-rpc-python-command "python3")
;;         (setq python-shell-interpreter "python3")
;;   :hook
;;         (python-mode . (lambda ()
;;             (elpy-enable)
;;             ;; Don't enable highlight-indentation-mode by default
;;             (highlight-indentation-mode -1)
;;          ))
;;   )

(use-package blacken
;; Use the python black package to reformat your python buffers
  :config
        (setq blacken-line-length '88)
  :hook
        (python-mode . blacken-mode)
  )

(use-package py-isort
;; py-isort.el integrates isort into Emacs
  :config
        (setq py-isort-options '("--lines=88" "-m=3" "-tc" "-ca"))
  :hook
        (python-mode . py-isort-before-save)
  )

(use-package python-docstring
;; Emacs minor-mode for editing Python docstrings
  :config
        (python-docstring-install)
  )

(use-package sphinx-doc
;; Generate Sphinx friendly docstrings for Python functions in Emacs
  :hook
        (python-mode . sphinx-doc-mode)
  )

(use-package pyenv-mode
;; Integrate pyenv with python-mode, pyenv lets you easily switch between multiple versions of Python
  :hook
        (python-mode . pyenv-mode)
  )

(use-package pipenv
;; A Pipenv porcelain inside Emacs.
  :hook
        (python-mode . pipenv-mode)
  :init
        (setq pipenv-projectile-after-switch-function 'pipenv-projectile-after-switch-extended)
  )

(use-package pippel
;; Emacs frontend to python package manager pip
  :custom
        (pippel-python-command "python3")
  )

(use-package mmm-mode
;; a minor mode for Emacs that allows Multiple Major Modes to coexist in one buffer
  :init
        (add-hook 'mmm-mode-hook
          (lambda ()
            (set-face-background 'mmm-default-submode-face nil)))
  )

(use-package doctest-mode
;; doctest-mode.el --- Major mode for editing Python doctest files
  :straight
        (
            :host github
            :repo "xwzliang/el-doctest-mode"
         )
  :mode "\\.doctest\\'"
  ;; :general
  ;;       (my-space-leader-def
  ;;           "t p" 'doctest-execute
  ;;        )
  :config
        (doctest-register-mmm-classes t t)
  :custom
        (doctest-python-command "python3")
  )

(use-package elisp-slime-nav
;; Slime-style navigation of Emacs Lisp source with M-. & M-,
  :hook
        (emacs-lisp-mode . elisp-slime-nav-mode)
        (ielm-mode . elisp-slime-nav-mode)
  )

(use-package lispy
;; This package reimagines Paredit - a popular method to navigate and edit LISP code in Emacs
  )

(use-package eros
;; Evaluation Result inline OverlayS for Emacs Lisp
  :hook
        (emacs-lisp-mode . eros-mode)
  )

(use-package realgud
;; The Grand "Cathedral" Debugger rewrite
  :general
        (
            :prefix "C-c d"
            "p" 'realgud:pdb
            "t" 'realgud:trepan3k
            "g" 'realgud:gdb
            "b" 'realgud:bashdb
            "z" 'realgud:zshdb
         )
  )

;; (use-package ert-runner
;; ;; Ert-runner is a tool for Emacs projects tested using Ert
;;   )

(use-package overseer
;; Ert-runner Integration Into Emacs
  ;; :general
  ;;       (my-space-leader-def
  ;;           "t e" 'overseer-test-this-buffer
  ;;        )
  :config
        (el-patch-defun overseer--current-buffer-test-file-p ()
          "Return t if the current buffer is a test file."
          (string-match
           (el-patch-swap "-test\.el$" "test\.el$")
           (or (buffer-file-name) ""))
          )
  )

(use-package lsp-mode
;; Emacs client/library for the Language Server Protocol
  :init
        (setq lsp-keymap-prefix "C-c l")
  :bind
        (
            :map lsp-mode-map
            ("TAB" . company-indent-or-complete-common)
        )
  :config
        (setq lsp-prefer-capf t)
        (setq gc-cons-threshold 100000000)
        (setq read-process-output-max (* 1024 1024)) ;; 1mb
        ;; (setq lsp-log-io t)
        (setq lsp-sqls-server "~/go/bin/sqls")
  :hook
        (lsp-mode . lsp-enable-which-key-integration)
        (lsp-mode . (lambda ()
            (add-hook 'before-save-hook #'lsp-format-buffer nil t)
        ))
        (scala-mode . lsp)
        (typescript-mode . lsp)
        (js-mode . lsp)
        (python-mode . lsp)
  )

(use-package lsp-pyright
;; lsp-mode client leveraging Pyright language server (type check, auto import, etc.)
  :hook
        (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          ))
  )

(use-package lsp-java
;; Emacs Java IDE using Eclipse JDT Language Server
  :hook
        (java-mode . lsp)
  )

(use-package emmet-mode
;; Emmet's support for emacs, Emmet is a plugin for many popular text editors which greatly improves HTML & CSS workflow
;; Place point in an emmet snippet and press C-j to expand it, and you'll transform your snippet into the appropriate tag structure
  :config
        (setq emmet-move-cursor-between-quotes t)
  :hook
        (css-mode)
        (html-mode)
  )

(use-package scala-mode
;; The definitive scala-mode for emacs
  :mode "\\.s\\(cala\\|bt\\)$"
  )

(use-package sbt-mode
;; An emacs mode for interacting with scala sbt and projects
  :commands sbt-start sbt-command
  :config
        ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
        ;; allows using SPACE when in the minibuffer
        (substitute-key-definition
        'minibuffer-complete-word
        'self-insert-command
        minibuffer-local-completion-map)
        ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
        (setq sbt:program-options '("-Dsbt.supershell=false"))
)

(use-package lsp-metals)
;; Emacs Scala IDE using lsp-mode to connect to Metals

(use-package helm-lsp
  :disabled t
;; Helm lsp integration.
;; helm-lsp-workspace-symbol - workspace symbols for the current workspace
  )

(use-package lsp-ivy
;; Ivy lsp integration.
;; lsp-ivy-workspace-symbol - workspace symbols for the current workspace
;; lsp-ivy-global-workspace-symbol - workspace symbols from all of the active workspaces.
  )

;; (use-package company-lsp
;;   :config
;;         (push 'company-lsp company-backends)
;;   )

(use-package dap-mode
;; Emacs client/library for Debug Adapter Protocol is a wire protocol for communication between client and Debug Server. It’s similar to the LSP but provides integration with debug server
  :hook
        (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra)))
  )

(use-package rainbow-delimiters
;; Emacs rainbow delimiters mode which highlights delimiters such as parentheses, brackets or braces according to their depth
  )

(use-package emr
;; language-specific refactoring in Emacs
  :bind
        (
            ("C-c t r" . emr-show-refactor-menu)
         )
  ;; :general
  ;;       (my-space-leader-def
  ;;           "t r" 'emr-show-refactor-menu
  ;;        )
  :custom
        (emr-popup-help-delay 3)
  )

(use-package list-environment
;; A tabulated process environment editor
  )

(use-package company-web
;; Emacs company backend for html, jade, slim
  :hook
        (html-mode . (lambda ()
            (set (make-local-variable 'company-backends) '(company-web-html))
        ))
  )

(use-package proxy-mode
;; A minor mode to toggle proxy for Emacs. Supports HTTP proxy and socks v4, v5 proxy with Emacs built-in functions
  :bind
        (
            ("C-c m u" . proxy-mode)
         )
  )

(use-package nix-mode
;; An Emacs major mode for editing Nix expressions
  :mode "\\.nix\\'"
  )

(use-package json-mode
;; Major mode for editing JSON files with emacs
  :mode "\\.json\\'"
  )

(use-package csv-mode
;; Major mode for editing comma/char separated values
  )

(use-package simple-httpd
;; Extensible Emacs HTTP 1.1 server
  )

(use-package web-mode
;; an emacs major mode for editing web templates aka HTML files embedding parts (CSS/JavaScript) and blocks
  :config
        (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
        (add-hook 'web-mode-hook
                (lambda ()
                    (when (string-equal "tsx" (file-name-extension buffer-file-name))
                    (setup-tide-mode))))
        ;; enable typescript-tslint checker
        (flycheck-add-mode 'typescript-tslint 'web-mode)
  )

(use-package tide
;; TypeScript Interactive Development Environment for Emacs
  :after web-mode
  :preface
        (defun setup-tide-mode ()
            (interactive)
            (tide-setup)
            (flycheck-mode +1)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode +1)
            (tide-hl-identifier-mode +1)
            (company-mode +1))
  ;; :config
        ;; formats the buffer before saving
        ;; (add-hook 'before-save-hook 'tide-format-before-save)
        ;; (add-hook 'typescript-mode-hook #'setup-tide-mode)
  )

(use-package dart-mode
;; An Emacs major mode for the Dart language
  )

(use-package lsp-dart
;; Emacs Dart IDE using lsp-mode to connect to Dart Analysis Server
  :hook
        (dart-mode . lsp)
  :custom
        (lsp-dart-flutter-sdk-dir (if my-system-is-mac nil "~/snap/flutter/common/flutter"))
  )

(use-package hover
;; Emacs tool for running flutter mobile apps on desktop using hover
  :after dart-mode
  ;; :bind
  ;;       (:map hover-minor-mode-map
  ;;             ("C-M-z" . hover-run-or-hot-reload)
  ;;             ("C-M-x" . hover-run-or-hot-restart)
  ;;             ("C-M-p" . hover-take-screenshot))
  :init
        (setq
                hover-hot-reload-on-save t
                hover-screenshot-path (concat (getenv "HOME") "/Pictures")
                hover-screenshot-prefix "hover-screenshot"
                hover-observatory-uri "http://127.0.0.1:50300"
                hover-clear-buffer-on-hot-restart t
                )
        (hover-minor-mode 1)
  )

(use-package flutter
  :after dart-mode
  :general
        (my-space-leader-def
            :definer 'minor-mode
            :keymaps 'flutter-test-mode
            "t t" 'flutter-test-current-file
            "t a" 'flutter-test-all
         )
        (
            :prefix my-space-leader
            :states '(normal motion visual)
            :keymaps 'dart-mode-map
            "t r" 'flutter-hot-restart
            "t R" 'flutter-run
         )
  :preface
        (defun my-flutter-run-on-all-devices ()
          (interactive)
          (flutter-run "-d all")
          )
  ;; :bind (:map dart-mode-map
  ;;             ("C-M-x" . #'flutter-run-or-hot-reload))
  :hook
        (dart-mode . (lambda ()
                       (if (string-match-p "_test\.dart$" buffer-file-name)
                           (flutter-test-mode)
                         (add-hook 'before-save-hook 'flutter-run-or-hot-reload nil t)
                           )
        ))
  )

(use-package json-reformat
;; Reformat tool for JSON
  )

(use-package json-snatcher
;; Get the path to a JSON element in Emacs
  )

(use-package jq-mode
;; Emacs major mode for editing jq queries, can also be used interactively in a JSON buffer
  :mode "\\.jq\\'"
  )

(use-package yaml-mode
;; The emacs major mode for editing files in the YAML data serialization format
  :mode "\\.yml\\'"
  )

(use-package dockerfile-mode
;; An emacs mode for handling Dockerfiles
  :mode "Dockerfile\\'"
  )

(use-package docker
;; Manage docker from Emacs
  :bind
        (
            ("C-c d k" . docker)
         )
  )

(use-package format-all
;; Auto-format source code in many languages with one command
  :bind
        (
            ("C-c f m" . format-all-buffer)
         )
  )

(use-package keyfreq
;; Track Emacs commands frequency
  :config
        (keyfreq-mode 1)
        (keyfreq-autosave-mode 1)
        ;; (setq keyfreq-excluded-commands '(
        ;;     forward-char
        ;;     backward-char
        ;;  ))
  :general
        (my-space-leader-def
            "Q" 'keyfreq-show
         )
  )

(use-package elmacro
  )

(use-package ace-window
;; Quickly switch windows in Emacs
  :bind
        (
            ("M-o" . ace-window)
         )
  :general
        (my-space-leader-def
            "]" 'ace-window
         )
  )

(use-package vlf
;; View Large Files in Emacs
  :config
        (require 'vlf-setup)
  )

(use-package add-node-modules-path
;; Adds the node_modules/.bin directory to the buffer exec_path. E.g. support project local eslint installations
  :config
        (eval-after-load
            'typescript-mode
            '(add-hook 'typescript-mode-hook #'add-node-modules-path))
  )

(use-package prettier-js
;; prettier-js is a function that formats the current buffer using prettier
  ;; :config
  ;;       (setq prettier-js-args '(
  ;;           "--trailing-comma" "all"
  ;;           "--single-quote"
  ;;       ))
  :hook
        (vue-mode . prettier-js-mode)
        (js-mode . prettier-js-mode)
        (typescript-mode . prettier-js-mode)
  )

(use-package vue-mode
;; Emacs major mode for vue.js based on mmm-mode
  :mode "\\.vue\\'"
  )

(use-package leetcode
;; An Emacs LeetCode client
  :config
        (setq leetcode-prefer-language "python3")
        (setq leetcode-prefer-sql "mysql")
        (setq leetcode-save-solutions t)
        (setq leetcode-directory "~/git/my_leetcode")
  )

(use-package typescript-mode
;; TypeScript-support for Emacs
  )

(use-package npm-mode
;; An Emacs minor mode for working with NPM projects
  ;; :mode "\\(\\.js\\|\\.ts\\|package\\.json\\)\\'"
  :custom
        (npm-mode-command-prefix "C-c m")
  )

(use-package restclient
;; HTTP REST client tool for emacs
  )

(use-package ob-restclient
;; An extension to restclient.el for emacs that provides org-babel support.
  :after
        (org)
  :config
        (org-babel-do-load-languages
            'org-babel-load-languages
            '((restclient . t)))
  )

(use-package ejc-sql
;; ejc-sql turns Emacs into a simple SQL client; it uses a JDBC connection to databases via clojure/java.jdbc lib
  )

(use-package vterm
;; A fully-fledged terminal emulator inside GNU Emacs based on libvterm
  :general
        (
            :states '(insert normal)
            :keymaps 'vterm-mode-map
            "TAB" 'vterm-send-tab
        )
  :custom
        (vterm-shell "/bin/zsh")
        (vterm-max-scrollback 10000)
  )

(use-package multi-vterm
;; Managing multiple vterm buffers in Emacs
  :general
        (my-space-leader-def
            ;; :prefix (concat my-space-leader " x")
            "x x" 'multi-vterm-dedicated-toggle
            "x o" 'multi-vterm
            "x j" 'multi-vterm-next
            "x k" 'multi-vterm-prev
         )
  )

(use-package w3m
;; An Emacs interface to w3m
  :bind
        (
            :map w3m-mode-map
            ("o" . w3m-goto-url)
            ("O" . w3m-goto-url-new-session)
            ("f" . w3m-lnum-follow)
            ("F" . w3m-lnum-goto)
            ("c" . w3m-submit-form)
            ("P" . w3m-print-current-url)
            ("p" . w3m-print-this-url)
            ("i" . w3m-view-this-url)
            ("g" . beginning-of-buffer)
            ("G" . end-of-buffer)
            ("D" . w3m-delete-buffer)
            ("m" . w3m-bookmark-view-new-session)
            ("M" . helm-firefox-bookmarks)
            ("V" . w3m-view-url-with-browse-url)
            ("u" . w3m-scroll-down-or-previous-url)
            ("y" . evil-yank)
            ("M-k" . evil-window-up)
            (":" . evil-ex)
            ("/" . evil-search-forward)
            (";" . evil-repeat-find-char)
            ("?" . evil-search-backward)
            ("n" . evil-search-next)
            ("w" . evil-forward-word-begin)
            ("b" . evil-backward-word-begin)
            ("v" . evil-visual-char)
            ("M-l" . evil-window-right)
            ("M-p" . w3m-previous-buffer)
            ("M-n" . w3m-next-buffer)
            ("C-j" . w3m-scroll-up)
            ("C-k" . w3m-scroll-down)
            ("x" . w3m-delete-buffer)
            ("X" . w3m-delete-other-buffers)
         )
  :config
        ;; Settings for proxy
        (setq w3m-command-arguments
            (nconc w3m-command-arguments
                    '("-o" "https_proxy=https://127.0.0.1:8118/")))
        (setq w3m-no-proxy-domains '(
                                        "stackoverflow.com"
                                        "stackexchange.com"
                                    ))
        ;; Change home page
        (setq w3m-home-page "https://github.com/xwzliang?tab=repositories")
        ;; Default download dir
        (setq w3m-default-save-directory "~/Downloads")

        ;; Default search engine
        (setq w3m-search-default-engine "google-en")
        ; Use gg to replace google-en engine
        (add-to-list 'w3m-uri-replace-alist
                        '("\\`gg:" w3m-search-uri-replace "google-en"))
        ;; Use cookies
        (setq w3m-use-cookies t)
        (setq w3m-cookie-file "~/.emacs.d/cookie")
  :hook
        (w3m-mode . (lambda ()
            (setq left-margin-width 5)
            (setq right-margin-width 5)
            ; Wrap lines in w3m
            (visual-line-mode 1)
            (face-remap-add-relative 'default
                                    :background "white"
                                    :foreground "black")
        ))
 )

(use-package helm-firefox
;; Display firefox bookmarks with emacs helm interface
  :disabled
  :config
        (cond ((string-equal system-type "darwin")
            (progn
                (setq helm-firefox-default-directory "~/Library/Application Support/Firefox/")
        )))
  )

(use-package emms
;; the Emacs Multi-Media System. Emms organizes playlists, allows browsing through track and album metadata, and plays files by calling external players
  :config
        (require 'emms-setup)
        (emms-all)
        (emms-default-players)
  :custom
        (emms-source-file-default-directory "~/Music/")
        (emms-player-list '(emms-player-mpv))
        (emms-player-mpv-parameters '(
                                      "--quiet"
                                      "--really-quiet"
                                      "--no-audio-display"
                                      "--fs"				;; Play video in full screen
                                      ))
  :hook
        ;; When I finish an episode, start a new one, tell siri to stop it.
        (emms-player-started . (lambda ()
            ;; (start-process-shell-command "siri" nil "echo 'ffplay -nodisp -autoexit ~/Dropbox/Sounds/Siri/siri_open_bedroom.m4a' | at now +1 minute")
            (emms-pause)
            (start-process-shell-command "siri" nil "cd ~/Dropbox/Sounds/Siri/; ffplay -nodisp -autoexit hey_siri.m4a; ffplay -nodisp -autoexit switch_tv.m4a")
        ))
  )

;; (use-package later-do
;; ;; execute lisp code ... later (required by emms-player-mpv)
;;   )

;; (use-package emms-player-simple-mpv
;; ;; an extension of emms-player-simple.el for mpv JSON IPC. It provides basic functions for interface defined in EMMS
;;   :general
;;         (
;;             :states 'normal
;;             :keymaps 'emms-playlist-mode-map
;;             "F" 'emms-player-simple-mpv-fullscreen
;;          )
;;   :config
;;         ;; This plugin provides control functions (e.g. ab-loop, speed, fullscreen).
;;         (require 'emms-player-simple-mpv-control-functions)
;;   )

(use-package pulseaudio-control
;; control PulseAudio volumes from Emacs, via pactl
  :bind
        (
            ("C-c m +" . pulseaudio-control-increase-volume)
            ("C-c m =" . pulseaudio-control-increase-volume)
            ("C-c m -" . pulseaudio-control-decrease-volume)
         )
  :custom
        (pulseaudio-control-use-default-sink t)
  )

(use-package mpv
;; control mpv for easy note taking
  :preface
        (defun my-mpv-play-at-point ()
            ;; Play current file in a dired buffer
            (interactive)
            (mpv-play (or (dired-get-filename nil t) default-directory))
        )

        (defun my-org-mpv-complete-link (&optional arg)
            (replace-regexp-in-string
                "file:" "mpv:"
                (org-link-complete-file arg)
                t t))

        (defun my-mpv-org-roam-play-video-at-note ()
          (interactive)
          (let (
                (mpv-video-directory (org-entry-get nil "MPV_VIDEO_DIRECTORY" t))
                (mpv-video-filename (org-entry-get nil "MPV_VIDEO_FILENAME" t))
                (mpv-video-position (org-entry-get nil "MPV_POSITION_START" t))
                )
            (if mpv-video-directory
                (if mpv-video-filename
                    (progn
                      (mpv-play (concat mpv-video-directory mpv-video-filename))
                      (if mpv-video-position
                          (mpv-seek (org-timer-hms-to-secs mpv-video-position))
                          )
                      )
                  (mpv-play mpv-video-directory)
                    )
              (error "Must be issued inside a heading")
                )
            )
          )
  :bind
        (
            ("C-c m v" . my-mpv-play-at-point)
            ("C-c m p" . mpv-playlist-prev)
            ("C-c m n" . mpv-playlist-next)
            ("C-c m l" . mpv-seek-forward)
            ("C-c m h" . mpv-seek-backward)
            ("C-c m x" . mpv-pause)
            ("C-c m X" . mpv-kill)
            ("C-c m i" . mpv-insert-playback-position)
            ("C-c m r" . mpv-seek-to-position-at-point)
            ("C-c m o" . my-mpv-org-roam-play-video-at-note)
         )
  :custom
        (mpv-seek-step 10)
  :config
        (org-link-set-parameters "mpv"
            :follow #'mpv-play
            :complete #'my-org-mpv-complete-link)
  )

(use-package elfeed
  ;; an extensible web feed reader for Emacs, supporting both Atom and RSS
  :bind
        (
            ("C-c m e" . elfeed)
         )
  :general
        (
            :states 'normal
            :keymaps 'elfeed-search-mode-map
            "r" 'elfeed-search-fetch
         )
  :config
        (setq elfeed-feeds '(
                ("http://nullprogram.com/feed/" blog emacs)
                ("https://planet.emacslife.com/atom.xml" blog emacs)
                ("http://emacstidbits.blogspot.com/atom.xml" blog emacs)
                ("https://mousecradle.wordpress.com/tag/emacs/feed/" blog emacs)
                ("http://oremacs.com/atom.xml" blog emacs)
                ("https://with-emacs.com/rss.xml" blog emacs)
                ("https://www.youtube.com/feeds/videos.xml?channel_id=UCAiiOTio8Yu69c3XnR7nQBQ" youtube emacs)
            ))
  )

(use-package exwm
  ;; EXWM (Emacs X Window Manager) is a full-featured tiling X window manager for Emacs built on top of XELB
  :preface
        (defun my-exwm-update-class ()
            (exwm-workspace-rename-buffer exwm-class-name)
        )
        (defun my-exwm-update-title ()
            (pcase exwm-class-name
              ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))
              ("qutebrowser" (exwm-workspace-rename-buffer (format "qutebrowser: %s" exwm-title)))
              )
        )
        (defun my-exwm-configure-window-by-class ()
            (interactive)
            (pcase exwm-class-name
                ("realvnc-vncserverui-service" (exwm-floating-hide))
            )
        )
  :config
        ;; (require 'exwm-config)
        ;; (exwm-config-example)

        ;; setup resolution
        ;; (require 'exwm-randr)
        ;; (exwm-randr-enable)
        ;; (start-process-shell-command "xrandr" nil "xrandr --output eDP --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off")

        ;; setup background image (wallpaper), if resolution needs to be set also, make sure resolution is set before background image
        (start-process-shell-command "feh" nil "feh --bg-scale ~/Dropbox/Devices_backup/WallPaper0.JPG")

        ;; setup keyboard
        (start-process-shell-command "xmodmap" nil "xmodmap ~/git/dot_emacs/exwm/Xmodmap")

        ;; Load the system tray
        ;; (require 'exwm-systemtray)
        ;; (setq exwm-systemtray-height 32)
        ;; (exwm-systemtray-enable)

        ;; Set Emacs transparency
        (defvar my-emacs-transparency '(90 . 90))
        (set-frame-parameter (selected-frame) 'alpha my-emacs-transparency)
        (add-to-list 'default-frame-alist `(alpha . ,my-emacs-transparency))
        ;; Maxmize Emacs by default
        (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
        (add-to-list 'default-frame-alist '(fullscreen . maximized))

        ;; These keys should always pass through to Emacs
        (setq exwm-input-prefix-keys '(
            ?\M-h
            ?\M-j
            ?\M-k
            ?\M-l
            ?\C-x
            ?\M-x
        ))
        ;; Ctrl+q will enable the next key to be sent directly
        (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

        ;; Use :bind or :general before :config won't work
        (my-space-leader-def
            "W f" 'counsel-linux-app
         )

        (setq exwm-input-global-keys `(
            ;; Switch to line-mode; exit fullscreen mode; refresh layout
            ([?\M-r] . exwm-reset)
            ([?\M-f] . exwm-layout-toggle-fullscreen)
            ([?\s-h] . exwm-floating-hide)
            ([?\s-\ ] . counsel-linux-app)
        ))

        ;; When window "class" updates, use it to set the buffer name
        (add-hook 'exwm-update-class-hook #'my-exwm-update-class)

        ;; When window title updates, use it to set the buffer name
        (add-hook 'exwm-update-title-hook #'my-exwm-update-title)

        ;; Configure windows as they're created
        (add-hook 'exwm-manage-finish-hook #'my-exwm-configure-window-by-class)

        ;; Put this to the last line
        (exwm-enable)
  )

(use-package desktop-environment
  ;; The package desktop-environment provides commands and a global minor mode to control your GNU/Linux desktop from Emacs.
  ;; With desktop-environment, you can control the brightness and volume as well as take screenshots and lock your screen
  :after exwm
  :config
        (desktop-environment-mode)
  :custom
        (desktop-environment-volume-get-command "pactl list sinks | grep '^[[:space:]]Volume:' | head -n 1 | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'")
        (desktop-environment-volume-set-command "pactl set-sink-volume @DEFAULT_SINK@ %s")
        (desktop-environment-volume-toggle-command "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        (desktop-environment-volume-normal-increment "+5%")
        (desktop-environment-volume-normal-decrement "-5%")
  )

(use-package aria2
  :straight
        (
            :host github
            :repo "LdBeth/aria2.el"
         )
  :custom
        (aria2-add-evil-quirks t)
  )


;; my packages with use-package

(use-package my_macros
  :straight nil
  ;; :commands my_macro_org_copy_agenda_link_line_to_journal_checklist
  ;; :bind
  ;;       (
  ;;           ("C-c m j" . my_macro_copy_all_agenda_items_link_to_journal)
  ;;           ("C-c m k" . my_macro_close_checklist_item_and_linked_todo_item)
  ;;           ("C-c m s" . my_macro_save_html_and_url)
  ;;        )
  :general
        (
            :keymaps 'org-mode-map
            :prefix "C-c o k"
            "k" 'my_macro_org_resolve_clock
         )
  )


(use-package faces
  :straight nil
  :after
        (clues-theme)
  :config
        ;; Change background color for modeline to dark orange
        (set-face-background 'mode-line my-modeline-color)
        (set-face-background 'mode-line-inactive my-modeline-color)
        ;; Change foreground color for active modeline to black
        (set-face-foreground 'mode-line "black")
        ;; Change color for prompt in mini-buffer
        (set-face-foreground 'minibuffer-prompt "white")
        ;; Change height of the font in modeline
        (set-face-attribute 'mode-line nil :height 102)
        (set-face-attribute 'mode-line-inactive nil :height 102)
  :custom-face
        ;; default font size
        (default ((t (:height 128))))
  )

(use-package dabbrev
  :straight nil
  :commands
        (dabbrev-expand)
  :bind
        (
            ("TAB" . dabbrev-expand)
            ;; Use shift tab (<backtab>) to insert tab
            ("<backtab>" . (lambda () (interactive) (insert "\t")))
         )
  :general
        (
            :states '(insert normal)
            "TAB" 'dabbrev-expand
        )
  )

(use-package whitespace
  :straight nil
  :commands
        (whitespace-mode)
  :bind
        (
            ("C-c w" . whitespace-mode)
         )
  :hook
        (before-save . whitespace-cleanup)
        ;; Don't expand tabs for sh-mode, otherwise bats won't work
        (sh-mode . (lambda () (remove-hook 'before-save-hook 'whitespace-cleanup)))
  )

(use-package simple
  :straight nil
  :commands
        (visual-line-mode)
  :bind
        (
            ("C-c v" . visual-line-mode)
         )
  :general
        (my-space-leader-def
            "v v" 'visual-line-mode
         )
  )

(use-package frame
  :straight nil
  :commands
        (toggle-frame-fullscreen)
  :bind
        (
            ("C-c m f" . toggle-frame-fullscreen)
         )
  :general
        (
            :prefix "C-a"
            "m" 'set-frame-name
         )
  :config
        (window-divider-mode)
  :custom
        (window-divider-default-right-width 10)
  :custom-face
        (window-divider ((t (:foreground ,my-modeline-color))))
        (window-divider-first-pixel ((t (:foreground ,my-modeline-color))))
        (window-divider-last-pixel ((t (:foreground ,my-modeline-color))))
  )

(use-package executable
  :straight nil
  :hook
        ;; Automatically give executable permissions if file begins with shebang
        (after-save . executable-make-buffer-file-executable-if-script-p)
  )

(use-package elec-pair
  :straight nil
  :config
        ;; Enable electric-pair-mode for automatic parens pairing
        (electric-pair-mode 1)
  )

(use-package autorevert
  :straight nil
  :config
        ;; Automatically reload changed file in buffer
        (global-auto-revert-mode t)
  )

(use-package gdb-mi
  :straight nil
  :config
        (setq gdb-many-windows t)
  )

(use-package cc-mode
  :straight nil
  :commands
        (c-set-style)
  :hook
        ;; Change code indentation style for C
        (c-mode . (lambda()
            (c-set-style "cc-mode")))
  )

(use-package sh-script
  :straight nil
  :mode
        ("\\.bats\\'" . sh-mode)
  :custom-face
        (sh-heredoc ((t (:foreground "color-136" :weight normal))))
  )

(use-package linum
  :straight nil
  :bind*
        (
            ("C-c [" . linum-mode)
         )
  :general
        (my-space-leader-def
            "[" 'linum-mode
         )
  :custom
        (linum-format " %3d ")
  :custom-face
        (linum ((t (:background "black" :foreground "#6a6a6a" :width condensed))))
  )

(use-package dired
  :straight nil
  :bind
        (
            :map dired-mode-map
            ; Use "C-c d e" to edit in dired mode.
            ("C-c d e" . wdired-change-to-wdired-mode)
         )
  :config
        (setq
            dired-dwim-target t            ; if another Dired buffer is visible in another window, use that directory as target for Rename/Copy
            dired-recursive-copies 'always         ; "always" means no asking
            dired-recursive-deletes 'top           ; "top" means ask once for top level directory
            dired-listing-switches "-lha"          ; human-readable listing
        )
        ;; if it is not Windows, use the following listing switches to group directories first.
        (when (not (eq system-type 'windows-nt))
            (setq dired-listing-switches "-lha --group-directories-first"))
  :hook
        ;; automatically refresh dired buffer on changes
        (dired-mode . auto-revert-mode)
  )

(use-package wdired
  :straight nil
  :config
        (setq
            wdired-allow-to-change-permissions t   ; allow to edit permission bits
            wdired-allow-to-redirect-links t       ; allow to edit symlinks
        )
  )

(use-package ibuffer
  :straight nil
  :bind
        (
            ("C-x C-b" . ibuffer)
         )
  :general
        (my-space-leader-def
            "B" 'ibuffer
         )
  :config
        (setq ibuffer-use-other-window t) ;; always display ibuffer in another window
  )

(use-package saveplace
  :straight nil
  :config
        ;; saveplace: remembers your location in a file when saving files
        (toggle-save-place-globally 1)
  )

(use-package compile
  :straight nil
  :bind*
        (
            ("C-c c" . compile)
         )
  :general
        (my-space-leader-def
            "c" 'compile
         )
  :config
        (setq compilation-ask-about-save nil          ; Just save before compiling
            compilation-always-kill t               ; Just kill old compile processes before starting the new one
            compilation-scroll-output 'first-error) ; Automatically scroll to first
  )

(use-package windmove
  :straight nil
  :general
        (
            :states '(normal motion emacs)
            ;; Override all other key bindings
            :keymaps 'override
            "M-h" 'windmove-left
            "M-l" 'windmove-right
            "M-j" 'windmove-down
            "M-k" 'windmove-up
         )
        (my-space-leader-def
            "h" 'windmove-left
            "l" 'windmove-right
            "j" 'windmove-down
            "k" 'windmove-up
         )
        (
            :prefix "C-a"
            "h" 'windmove-left
            "l" 'windmove-right
            "j" 'windmove-down
            "k" 'windmove-up
         )
  )

(use-package custom
  :straight nil
  :config
        (setq custom-file "~/.emacs.d/emacs-custom.el")
  )

;; (use-package simple
;;   :delight visual-line-mode
;;   )

(use-package fill
  :straight nil
  :general
        (my-comma-leader-def
            "f" 'fill-paragraph		;; Auto format and wrap long string
         )
  )

(use-package eldoc
  :straight nil
  :delight
  )

(use-package auth-source
  :straight nil
  :custom
        (auth-sources (quote (
            ;; "~/.authinfo"
            "~/Dropbox/org/keys/emacs/authinfo"
         )))
)

(use-package eshell
  :straight nil
  :bind
        (
            ("C-c e s" . eshell)
         )
  :config
        (with-eval-after-load 'em-prompt
          (el-patch-defun eshell-previous-prompt (n)
            "Move to end of Nth previous prompt in the buffer.
            See `eshell-prompt-regexp'."
            (interactive "p")
            (beginning-of-line)               ; Don't count prompt on current line.
            ;; PATCH beginning-of-line does not move across the prompt
            (el-patch-add (backward-char))
            (eshell-next-prompt (- n))))
  :preface
        ;; From spacemacs
        (defun protect-eshell-prompt ()
            "Protect Eshell's prompt like Comint's prompts.
            E.g. `evil-change-whole-line' won't wipe the prompt. This
            is achieved by adding the relevant text properties."
            (interactive)
            (let ((inhibit-field-text-motion t))
            (add-text-properties
              (point-at-bol)
              ;; (point)
              (eshell-bol)
              '(rear-nonsticky t
                inhibit-line-move-field-capture t
                field output
                read-only t
                front-sticky (field inhibit-line-move-field-capture)))))
  :hook
        ;; (eshell-after-prompt . protect-eshell-prompt)
        (eshell-mode . (lambda ()
                         (general-define-key
                          :states 'insert
                          :keymaps 'eshell-mode-map
                          "C-r" 'counsel-esh-history
                          "<escape>" (lambda () (interactive)
                                       (protect-eshell-prompt)
                                       (evil-normal-state)
                                       (evil-end-of-line)))))
        ;; Save command history when typing new command
        (eshell-pre-command . eshell-save-some-history)
  :custom
        (eshell-history-size 10000)
        (eshell-buffer-maximum-lines 10000)
        (eshell-hist-ignoredups t)
        (eshell-scroll-to-bottom-on-input t)
  :custom-face
        (eshell-prompt ((t (:foreground "green" :weight bold))))
  )

(use-package eww
  :straight nil
  :hook
        (eww-mode . (lambda ()
            (setq left-margin-width 5)
            (setq right-margin-width 5)
            (face-remap-add-relative 'default
                                    :background "white"
                                    :foreground "black")
        ))
)

(use-package hideshow
  :straight nil
  :hook
        (prog-mode . hs-minor-mode)
)

(use-package xref
  :straight nil
  :general
        (
            :states '(normal motion visual)
            "M-." 'xref-find-definitions
         )
)

(use-package descr-text
  :straight nil
  :bind
        (
            ("C-h c" . describe-char)
         )
)

(use-package elisp-mode
  :straight nil
  :general
        (my-space-leader-def
            "e b" 'eval-buffer
            "e d" 'eval-defun
            "e l" 'eval-last-sexp
            "e x" 'eval-expression
         )
)

(use-package vc
  :straight nil
  :general
        (my-space-leader-def
            "v u" 'vc-revert
         )
  :custom
        (vc-follow-symlinks t)
)

(use-package smerge-mode
  :straight nil
)

(use-package edebug
  :straight nil
  :bind
        (
            ("C-c d e" . edebug-defun)
         )
  )

(use-package ert
  :straight nil
  :preface
        (defun add-pwd-into-load-path ()
            "add current directory into load-path, useful for elisp developers"
            (interactive)
            (let ((dir (expand-file-name default-directory)))
                (if (not (memq dir load-path))
                    (add-to-list 'load-path dir)
                 )
                (message "Directory added into load-path:%s" dir)
             )
         )
        (defun my-ert-run ()
          "Add pwd to load path, eval current buffer and run ert"
                (interactive)
                (add-pwd-into-load-path)
                (eval-buffer)
                (ert t)
          )
  :bind
        (
            ("C-c t e" . my-ert-run)
         )
  )

(use-package files
  :straight nil
  ;; :general
  ;;       (my-space-leader-def
  ;;           "w" 'save-buffer
  ;;        )
)

(use-package term
  :straight nil
  :init
        (setq-default term-prompt-regexp "^[^$>»]*[#$>»] ")
)

(use-package browse-url
  :straight nil
  :custom
        (browse-url-browser-function (quote w3m-browse-url))
  )

(use-package bibtex
  :straight nil
  :config
        (setq bibtex-dialect 'biblatex)
        (setq bibtex-autokey-year-length 4)
        (setq bibtex-autokey-titleword-separator "")
        (setq bibtex-autokey-name-year-separator "_")
        (setq bibtex-autokey-year-title-separator "_")
        (setq bibtex-autokey-titleword-length 100)
        (setq bibtex-autokey-titlewords 3)
        ;; (setq bibtex-autokey-titlewords-stretch 1)
        ;; (setq bibtex-autokey-name-case-convert-function 'capitalize)
        (setq bibtex-autokey-titleword-case-convert-function 'capitalize)
        (setq bibtex-autokey-titleword-ignore
        '("A" "An" "The" "And"))
        ;; '("A" "An" "The" "[^[:upper:]].*" ".*[^[:upper:][:lower:]0-9].*"))
        ;; (setq bibtex-completion-pdf-open-function
        ;;     (lambda (fpath)
        ;;         (call-process "evince" nil 0 nil fpath)))
  )

(use-package desktop
  ;; :disabled my-system-is-mac
  :disabled t
  :straight nil
  :init
        (setq desktop-dirname (expand-file-name my-workspace-store-dir))
        ;; (setq desktop-dirname-default (expand-file-name "~/Dropbox/org/persp/default"))
  ;; :general
  ;;       (
  ;;           :prefix "C-a"
  ;;           "C-s" (lambda () (interactive) (desktop-save desktop-dirname))
  ;;           "C-l" (lambda () (interactive) (desktop-read desktop-dirname))
  ;;        )
  :config
        (setq desktop-dirname (expand-file-name my-workspace-store-dir))
        (desktop-save-mode 1)
        (save-place-mode 1)
        ;; restoring the desktop in daemon mode is somewhat problematic for other reasons: e.g., the daemon cannot use GUI features, so parameters such as frame position, size, and decorations cannot be restored. For that reason, you may wish to delay restoring the desktop in daemon mode until the first client connects
        (if (daemonp)
            (add-hook 'server-after-make-frame-hook 'desktop-read)
            )
  :custom
        (desktop-path (list "." desktop-dirname))
        (desktop-load-locked-desktop t)
        (desktop-base-file-name "emacs.desktop")
        (desktop-files-not-to-save nil)
        (desktop-save t)
        (desktop-restore-eager 5)
  :hook
        (desktop-after-read . (lambda ()
            (setq desktop-dirname (expand-file-name my-workspace-store-dir))
                ))
  )

(use-package desktop+
  ;; :disabled my-system-is-mac
  :disabled t
  :init
        (setq desktop+-base-dir (expand-file-name my-workspace-store-dir))
  :config
        (setq desktop+-base-dir (expand-file-name my-workspace-store-dir))
  )

(use-package time
  :straight nil
  :general
        (my-space-leader-def
            "t v" 'display-time-mode
         )
  :config
        (display-time-mode 1)
  :custom
        (display-time-format " %H:%M %d/%m/%Y")
  )

(use-package python
  :straight nil
  :custom
        (python-shell-interpreter "python3")
  )

(use-package emacs
  :straight nil
  :general
        (my-space-leader-def
            ;; Check for unbalanced parentheses in the current buffer
            "e p" 'check-parens
            "b" 'switch-to-buffer
         )
  )
