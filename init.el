;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Enable debugging on error (this will cause describe-bindings not working)
;; (toggle-debug-on-error)

;; Back up settings
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

;; Disable bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(if (display-graphic-p)
    ; GUI
    (toggle-scroll-bar -1))

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

;; Settings for MacOS
(cond ((string-equal system-type "darwin")
       (progn
         ;; modify option and command key
         (setq mac-command-modifier 'super)
         (setq mac-option-modifier 'meta)
  )))

;; load paths
(let ((default-directory "~/.emacs.d/custom/"))
  (normal-top-level-add-subdirs-to-load-path))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my_inits"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my_packages"))


;; Package settings

;; use-package
(eval-when-compile
  (require 'use-package))
(require 'bind-key)


;; Third party packages with use-package

(use-package f
  )

(use-package delight
  )

(use-package el-patch
  )

(use-package fzf
  :bind
        (
            ("C-c f z" . fzf)
         )
  )

(use-package auto-package-update
  :config
        (setq package-archives '(
            ("gnu" . "http://elpa.gnu.org/packages/")
            ("melpa" . "https://melpa.org/packages/")
            ("org" . "https://orgmode.org/elpa/")
         ))
  )

(use-package general
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
            :states '(normal motion visual)
            :keymaps 'override
            :prefix my-space-leader
          )
        (general-create-definer my-comma-leader-def
            :states '(normal motion visual)
            :keymaps 'override
            :prefix my-comma-leader
          )
        (general-evil-setup)
        ;; Use ,, to <esc> keybinding in insert state (jk will cause my macro to be broken somehow)
        (general-imap ","
            (general-key-dispatch 'self-insert-command
                :timeout 0.25
                "," 'evil-normal-state))
  )

(use-package clues-theme
  :init
        (load-theme 'clues t)
  )

(use-package restart-emacs
  :general
        (my-space-leader-def
            "r r" 'restart-emacs
         )
  )

(use-package doom-modeline
  :config
        (doom-modeline-mode 1)
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
  )

(use-package macrostep
  )

(use-package transpose-frame
  :general
        (
            :prefix "C-c f"
            "t" 'transpose-frame
            "f" 'flip-frame
            "F" 'flop-frame
         )
  )

(use-package persp-mode
  :delight
  :init
        (add-hook 'after-init-hook 'persp-mode)
  :config
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
            "b" 'persp-switch-to-buffer
         )
  )

;; company-mode
(use-package company
  :delight
  :init
        (add-hook 'after-init-hook 'global-company-mode)
  :bind
        ("C-j" . company-select-next)
        ("C-k" . company-select-previous)
  :config
        (setq company-idle-delay 0)
        (setq company-backends
        '((company-files
            company-keywords
            company-capf	; completion-at-point-functions backend
            company-yasnippet
            )
            (company-abbrev company-dabbrev)))
        ; Solve the conflicts with yasnippet of tab key binding
        (advice-add 'company-complete-common :before (lambda ()
                                        (setq my-company-point (point))))
        (advice-add 'company-complete-common :after (lambda ()
                                        (when (equal my-company-point (point)) (yas-expand))))
  :custom-face
        (company-preview ((t (:background "black" :foreground "brightblack"))))
        (company-preview-common ((t (:inherit company-preview :foreground "brightblack"))))
        (company-scrollbar-bg ((t (:background "black"))))
        (company-scrollbar-fg ((t (:background "black"))))
        (company-tooltip ((t (:background "black" :foreground "white"))))
        (company-tooltip-annotation ((t (:foreground "yellow"))))
        (company-tooltip-common ((t (:foreground "gold3"))))
        (company-tooltip-selection ((t (:background "forestgreen"))))
  )

(use-package company-statistics
  :hook
        (after-init . company-statistics-mode)
  )

(use-package evil
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
            "J n" 'evil-jump-forward
            "J p" 'evil-jump-backward
            "u" 'evil-scroll-up
            "d" 'evil-scroll-down
            "<escape>" 'hydra-move/body
         )
  :config
        (evil-mode 1)
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
  :config
        ;; Don't use evil-collection in w3m
        (delete 'w3m evil-collection-mode-list)
        (evil-collection-init)
  :custom
        (evil-collection-setup-minibuffer t)
  )

(use-package linum-relative
  :general
        (my-space-leader-def
            ";" 'linum-relative-toggle
         )
  :config
        ;; Use `display-line-number-mode` as linum-mode's backend for smooth performance
        (setq linum-relative-backend 'display-line-numbers-mode)
  )

(use-package smartparens
  :config
        (require 'smartparens-config)
        (smartparens-global-mode 1)
  :hook
        (emacs-lisp-mode . show-smartparens-mode)
        (ielm-mode . show-smartparens-mode)
  )

(use-package evil-surround
  :config
        (global-evil-surround-mode 1)
  )

(use-package evil-exchange
  :config
        (evil-exchange-install)
  )

(use-package evil-replace-with-register
  :config
        (setq evil-replace-with-register-key (kbd "gr"))
        (evil-replace-with-register-install)
  )

(use-package evil-visualstar
  :config
        ;; allowing for repeated * or #
        (setq evil-visualstar/persistent t)
        (global-evil-visualstar-mode)
  )

(use-package evil-nerd-commenter
  :config
        (evilnc-default-hotkeys)
  )

(use-package evil-lion
  :config
        (evil-lion-mode)
  )

(use-package evil-numbers
  :bind
        (
            ("C-c +" . evil-numbers/inc-at-pt)
            ("C-c -" . evil-numbers/dec-at-pt)
         )
  )

(use-package evil-args
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
  :config
        (evil-indent-plus-default-bindings)
  )

(use-package evil-visual-mark-mode
  )

(use-package anzu
  :delight
  :config
        (global-anzu-mode)
  )

(use-package evil-anzu
  )

(use-package evil-mc
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
  )

;; This package provides the x text object to manipulate html/xml tag attributes.
(use-package exato
  )

;; This package provides h text objects for consecutive items with same syntax highlight.
(use-package evil-textobj-syntax
  )

;; Evil operator g~ to cycle text objects through camelCase, kebab-case, snake_case and UPPER_CASE.
(use-package evil-string-inflection
  )

;; This package provides the f,c,d text object
(use-package evil-cleverparens
  ;; :hook
  ;;        ((lisp-mode emacs-lisp-mode) . evil-cleverparens-mode)
  )

(use-package undo-tree
  :delight
  )

(use-package avy
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
            "z" 'avy-goto-char
         )
  :custom-face
        (avy-lead-face ((t (:background "blue" :foreground "white"))))
        (avy-lead-face-0 ((t (:background "blue" :foreground "white"))))
        (avy-lead-face-1 ((t (:background "blue" :foreground "white"))))
        (avy-lead-face-2 ((t (:background "blue" :foreground "white"))))
  )

(use-package git-gutter
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
         )
  :config
        (general-define-key
            :states 'normal
            :keymaps 'neotree-mode-map
            "s" 'neotree-enter-vertical-split
            "S" 'neotree-enter-horizontal-split
         )
  :custom
        (neo-confirm-create-directory (quote off-p))
        (neo-confirm-create-file (quote off-p))
  )


(use-package helm
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
            :map helm-map
            ("C-l" . helm-select-action) ; list actions
            ("C-u" . helm-find-files-up-one-level)
            ("TAB" . helm-execute-persistent-action)
            :map minibuffer-local-map
            ("C-c C-l" . helm-minibuffer-history)
        )
  :general
        (
            :states '(insert normal)
            :keymaps 'helm-map
            "C-j" 'helm-next-line
            "C-k" 'helm-previous-line
        )
        (my-space-leader-def
            "SPC" 'helm-M-x
            "y" 'helm-show-kill-ring
            "s" 'helm-find-files
            "f" 'helm-occur
            "a" (general-simulate-key "C-c h")
        )
        (my-comma-leader-def
            :states '(normal motion visual insert)
            :keymaps 'helm-map
            "," 'helm-keyboard-quit
         )
  :config
        (require 'helm-config)
        (global-unset-key (kbd "C-x c"))
        (helm-mode 1)
        (setq
            ;; helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
            helm-ff-file-name-history-use-recentf t
            ;; helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
            ;; helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
            ;; helm-echo-input-in-header-line		t
        )
        ; Don't show the first two lines (current dir and parent dir)
        (advice-add 'helm-ff-filter-candidate-one-by-one
                :around (lambda (fcn file)
                        (unless (string-match "\\(?:/\\|\\`\\)\\.\\{1,2\\}\\'" file)
                            (funcall fcn file))))
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

(use-package helm-descbinds
  :config
        (helm-descbinds-mode)
  )

(use-package helm-swoop
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
  :bind
        (
            :map helm-command-map
            ("g g" . helm-ag)
            ("g d" . helm-do-ag)
            ("g b" . helm-do-ag-buffers)
            ("g p" . helm-do-ag-project-root)
         )
  :custom
        ;; Enable helm-follow-mode by default
        (helm-follow-mode-persistent t)
  )

(use-package helm-make
  :bind
        (
            :map helm-command-map
            ("k" . helm-make)
         )
  )

(use-package hydra
  :custom-face
        (hydra-face-red ((t (:foreground "green"))))
  )

(use-package projectile
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
  :config
        (helm-projectile-on)
        ;; (setq projectile-switch-project-action 'helm-projectile)
  :general
        (my-space-leader-def
            "p" 'helm-projectile-switch-project
         )
  )

(use-package iedit
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
  :after
        (evil iedit)
  :hook
        ;; Use evil-iedit-state when iedit-mode is enabled.
        (iedit-mode)
  )

(use-package ggtags
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
  :config
        (yas-global-mode 1)
  :custom
        ; Don't make aliases for the old style yas/ prefixed symbols
        (yas-alias-to-yas/prefix-p nil)
  )

(use-package helm-c-yasnippet
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

(use-package rg
  :config
        (rg-enable-default-bindings)
  :custom-face
        (rg-info-face ((t (:foreground "#0ff"))))
        (rg-line-number-face ((t (:foreground "#0ff"))))
        (rg-match-face ((t (:foreground "gold3"))))
  )

(use-package helm-rg
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
  :custom
        (bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
  )

(use-package bm
  )

(use-package expand-region
  :bind
        (
            ("M-+" . er/expand-region)
         )
  )

(use-package ibuffer-vc
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
  :bind
        (
            ("C-x g" . magit-status)
            ("C-c g l" . magit-log)
            ("C-c g c" . magit-blame)
            ("C-c g b" . magit-branch)
            ("C-c g s" . magit-status)
            :map magit-mode-map
            ("o" . magit-file-checkout)
         )
  :general
        (my-space-leader-def
            "g" 'magit-status
         )

  :hook
        (magit-post-refresh . git-gutter:update-all-windows)
        (after-save . magit-after-save-refresh-status)
  )

(use-package evil-magit
  :after
        (evil magit)
  )

(use-package magit-gitflow
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
  :after
        (magit)
  )

(use-package hl-todo
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
  )

(use-package gitconfig-mode
  )

(use-package gitattributes-mode
  )

(use-package git-timemachine
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
  :config
        (add-to-list 'company-backends 'company-c-headers)
        (add-to-list 'company-c-headers-path-system (getenv "unity_path"))
  )

(use-package golden-ratio
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
  :mode
        ("\\.pdf\\'" . doc-view-mode)
  :hook
        (doc-view-mode . (lambda ()
            (pdf-tools-install)
            ; Use HiDPI for pdf.
            (setq pdf-view-use-scaling t)
        ))
  )

(use-package org
  :init
        (setq org-directory "~/Dropbox/org")
  :bind
        (
            ("C-c o c" . org-capture)
            ("C-c o a" . org-agenda)
            ("C-c o l" . org-store-link)
            :map org-mode-map
            ("C-c a" . org-agenda)
            ("M-RET" . org-insert-todo-heading)
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
        (my-space-leader-def
            "o" (general-simulate-key "C-c o")
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
        ; Use other source code languages in org
        (org-babel-do-load-languages
            'org-babel-load-languages
            '(
                (shell . t)
                (dot . t)
            ))
        ; Don't ask for confirmation when execute the code block
        (setq org-confirm-babel-evaluate nil)
        ;; global Effort estimate values
        (setq org-global-properties
            '(("Effort_ALL" .
                "0:15 0:30 0:45 1:00 2:00 3:00 4:00 6:00 8:00")))
        (setq org-todo-keywords '((sequence "SOMEDAY(s)" "TODO(t!)" "NEXT(n!)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
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
  )

(use-package org-indent
  :delight
  )

(use-package org-id
  :after
        (org)
  :config
        ; Need this to resolve id links
        (setq org-id-link-to-org-use-id t)
        (setq org-id-locations-file (f-join org-directory ".org-id-locations"))
  )

(use-package org-agenda
  :after
        (org)
  :general
        (
            :states 'motion
            :keymaps 'org-agenda-mode-map
            "D" 'org-agenda-day-view
            "W" 'org-agenda-week-view
            "g a" 'org-agenda
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
  )

(use-package org-timeline
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
  :delight
  :after
        (evil org)
  :config
        (evil-org-set-key-theme '(navigation insert textobjects calendar))
  :hook
        (org-mode . evil-org-mode)
  )

(use-package evil-org-agenda
  :after
        (evil org org-agenda)
  :config
        (evil-org-agenda-set-keys)
  )

(use-package org-expiry
  :after
        (org)
  :config
        ;; Log creation time when a TODO item is added.
        (org-expiry-insinuate)
        ; Don't have everything in the agenda view
        (setq org-expiry-inactive-timestamps t)
  )

(use-package org-super-agenda
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
  )

(use-package calfw
  )

(use-package calfw-org
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
  :after
        (org)
  :hook
        (org-brain-visualize-mode . (lambda ()
            (evil-set-initial-state 'org-brain-visualize-mode 'emacs)))
  )

(use-package org-projectile
  :config
        ;; (setq org-projectile-projects-directory (f-join org-directory "projectile"))
        (setq org-projectile-projects-file (f-join org-directory "1_2_projects.org"))
        (push (org-projectile-project-todo-entry) org-capture-templates)
        ;; (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
        (setq org-confirm-elisp-link-function nil)
  )

(use-package org-ref
  :after
        (org)
  :config
        (setq org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib"))
  )

(use-package org-web-tools
  :general
        (
            :prefix "C-c o w"
            "u" 'org-web-tools-insert-link-for-url
            "w" 'org-web-tools-read-url-as-org
            "W" 'org-web-tools-insert-web-page-as-entry
            "v" 'org-web-tools-convert-links-to-page-entries
            "t" 'org-web-tools-archive-attach
            "V" 'org-web-tools-archive-view
         )
  )

(use-package org-download
  :hook
        (org-mode . org-download-enable)
  )

(use-package org-board
  :bind-keymap
        ("C-c o b" . org-board-keymap)
  )

(use-package org-pomodoro
  :after
        (org)
  :bind
        (
            ("C-c o t" . org-pomodoro)
         )
  )

(use-package hide-mode-line
  )

(use-package org-present
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

(use-package org-noter
  :general
        (
            :prefix "C-c n"
            "n" 'org-noter
            "i" 'org-noter-insert-note
            "." 'org-noter-sync-current-note
         )
  )

(use-package org-roam
  :general
        (
            :prefix "C-c n"
            "r" 'org-roam
            "f" 'org-roam-find-file
            "g" 'org-roam-show-graph
            "l" 'org-roam-insert
         )
        (my-space-leader-def
            "n" (general-simulate-key "C-c n")
         )
  :config
        (setq org-roam-completion-system 'helm)
  :hook
        (after-init . org-roam-mode)
  :custom
        (org-roam-directory (f-join org-directory "wiki"))
  )

(use-package org-journal
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
  :bind
        (
            ("C-c n d" . deft)
         )
  :config
        (setq deft-directory (f-join org-directory "wiki"))
        (setq deft-recursive t)
  :hook
        (deft-mode . (lambda ()
            (evil-set-initial-state 'deft-mode 'insert)))
  )

(use-package howm
  :config
        (setq howm-directory (f-join org-directory "howm"))
  :custom-face
        (howm-mode-title-face ((t (:foreground "#BDBA9F"))))
        (howm-reminder-today-face ((t (:foreground "#55C0D2"))))
  )

(use-package anki-editor
  :after
        (org org-expiry)
  :bind
        (
            ("C-c m i" . anki-editor-insert-note)
            ("C-c m p" . anki-editor-push-tree)
            ("C-c m P" . anki-editor-push-notes)
            ("C-c m z z" . anki-editor-cloze-dwim)
            ("C-c m z a" . anki-editor-cloze-region-auto-incr)
            ("C-c m z p" . anki-editor-cloze-region-dont-incr)
            ("C-c m z r" . anki-editor-reset-cloze-number)
         )
  :general
        (my-space-leader-def
            "m" (general-simulate-key "C-c m")
         )
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
  :bind
        (
            ("C-c m w" . define-word)
         )
  )

(use-package emamux
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
            :prefix (concat my-space-leader " x")
            "y" 'emamux:copy-kill-ring
            "p" 'emamux:yank-from-list-buffers
            "e" 'eshell
            "t" 'term
            "i" 'ielm
         )
  :custom
        (emamux:completing-read-type 'helm)
        (emamux:show-buffers-with-index nil)
        (emamux:get-buffers-regexp
            "^\\(buffer[0-9]+\\): +\\([0-9]+\\) +\\(bytes\\): +[\"]\\(.*\\)[\"]")
  )

(use-package aweshell
  :general
        (my-space-leader-def
            :prefix (concat my-space-leader " x")
            "x" 'aweshell-dedicated-toggle
         )
  )

(use-package eshell-prompt-extras
  :after aweshell
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
  )

(use-package eshell-up
  )

(use-package eshell-did-you-mean
  :config
        (eshell-did-you-mean-setup)
  )

(use-package fish-mode
  )

(use-package fish-completion
  :config
        (when (and (executable-find "fish")
                (require 'fish-completion nil t))
          (global-fish-completion-mode))
  )

(use-package which-key
  :delight
  :config
        (setq which-key-allow-evil-operators t)
        (setq which-key-show-operator-state-maps t)
        (which-key-mode)
  )

(use-package helpful
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
        (my-space-leader-def
            "i" (general-simulate-key "C-h")
         )
  )

(use-package undo-propose
  ;; :config
  ;;        (global-undo-tree-mode -1)
  :general
        (
            :states 'normal
            "U" 'undo-propose
         )
  )

(use-package eshell-z
  :hook
        (eshell-mode . (lambda ()
            (require 'eshell-z)
        ))
  )

(use-package popup
  :custom-face
        (popup-face ((t (:inherit company-tooltip))))
        (popup-menu-selection-face ((t (:inherit company-tooltip-selection :foreground "white"))))
        (popup-tip-face ((t (:background "lightgray" :foreground "black"))))
  )

(use-package company-quickhelp
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
  :config
        (company-quickhelp-terminal-mode 1)
  )

(use-package highlight-indentation
  :custom-face
        (highlight-indentation-face ((t (:background "color-235"))))
  )

(use-package elpy
  :general
        (
            :states 'normal
            :keymaps 'elpy-mode-map
            "M-." 'elpy-goto-definition
         )
  :config
        (setq elpy-rpc-python-command "python3")
        (setq python-shell-interpreter "python3")
  :hook
        (python-mode . (lambda ()
            (elpy-enable)
            ;; Don't enable highlight-indentation-mode by default
            (highlight-indentation-mode -1)
         ))
  )

(use-package blacken
  :config
        (setq blacken-line-length '88)
  :hook
        (python-mode . blacken-mode)
  )

(use-package py-isort
  :config
        (setq py-isort-options '("--lines=88" "-m=3" "-tc" "-ca"))
  :hook
        (python-mode . py-isort-before-save)
  )

(use-package python-docstring
  :config
        (python-docstring-install)
  )

(use-package sphinx-doc
  :hook
        (python-mode . sphinx-doc-mode)
  )

(use-package pyenv-mode
  :hook
        (python-mode . pyenv-mode)
  )

(use-package pippel
  :custom
        (pippel-python-command "python3")
  )

(use-package elisp-slime-nav
  :hook
        (emacs-lisp-mode . elisp-slime-nav-mode)
        (ielm-mode . elisp-slime-nav-mode)
  )

(use-package eros
  :hook
        (emacs-lisp-mode . eros-mode)
  )

(use-package realgud
  :general
        (
            :prefix "C-c d"
            "p" 'realgud:pdb
            "t" 'realgud:trepan3k
            "g" 'realgud:gdb
            "b" 'realgud:bashdb
            "z" 'realgud:zshdb
         )
        (my-space-leader-def
            "t d" (general-simulate-key "C-c d")
         )
  )

(use-package lsp-mode
  :init
        (setq lsp-keymap-prefix "C-c l")
  :config
        (setq lsp-prefer-capf t)
        (setq gc-cons-threshold 100000000)
        (setq read-process-output-max (* 1024 1024)) ;; 1mb
        ;; (setq lsp-log-io t)
  :hook
        (lsp-mode . lsp-enable-which-key-integration)
  )

(use-package helm-lsp
  )

(use-package emr
  :bind
        (
            ("C-c t r" . emr-show-refactor-menu)
         )
  :general
        (my-space-leader-def
            "t r" 'emr-show-refactor-menu
         )
  :custom
        (emr-popup-help-delay 3)
  )

(use-package list-environment
  )

(use-package company-web
  :hook
        (html-mode . (lambda ()
            (set (make-local-variable 'company-backends) '(company-web-html))
        ))
  )

(use-package proxy-mode
  :bind
        (
            ("C-c m u" . proxy-mode)
         )
  )

(use-package nix-mode
  :mode "\\.nix\\'"
  )

(use-package json-mode
  :mode "\\.json\\'"
  )

(use-package json-reformat
  )

(use-package json-snatcher
  )

(use-package jq-mode
  :mode "\\.jq\\'"
  )

(use-package dockerfile-mode
  :mode "Dockerfile\\'"
  )

(use-package docker
  :bind
        (
            ("C-c d k" . docker)
         )
  )

(use-package format-all
  :bind
        (
            ("C-c f m" . format-all-buffer)
         )
  )

(use-package keyfreq
  :config
        (keyfreq-mode 1)
        (keyfreq-autosave-mode 1)
        ;; (setq keyfreq-excluded-commands '(
        ;;     forward-char
        ;;     backward-char
        ;;  ))
  :general
        (my-space-leader-def
            "q" 'keyfreq-show
         )
  )

(use-package elmacro
  )

(use-package ace-window
  :bind
        (
            ("M-o" . ace-window)
         )
  :general
        (my-space-leader-def
            "]" 'ace-window
         )
  )


;; my packages with use-package

(use-package my_macros
  :commands my_macro_org_copy_agenda_link_line_to_journal_checklist
  :bind
        (
            ("C-c m j" . my_macro_copy_all_agenda_items_link_to_journal)
            ("C-c m k" . my_macro_close_checklist_item_and_linked_todo_item)
            ("C-c m s" . my_macro_save_html_and_url)
         )
  )

(use-package init_emacs-w3m
  )


;; built-in packages with use-package

(use-package faces
  :after
        (clues-theme)
  :config
        ;; Change background color for modeline to dark orange
        (set-face-background 'mode-line "#af5f00")
        (set-face-background 'mode-line-inactive "#af5f00")
        ;; Change foreground color for active modeline to black
        (set-face-foreground 'mode-line "black")
        ;; Change color for prompt in mini-buffer
        (set-face-foreground 'minibuffer-prompt "white")
  )

(use-package dabbrev
  :commands
        (dabbrev-expand)
  :bind
        (
            ("TAB" . dabbrev-expand)
            ;; Use shift tab (<backtab>) to insert tab
            ("<backtab>" . (lambda () (interactive) (insert "\t")))
         )
  )

(use-package whitespace
  :commands
        (whitespace-mode)
  :bind
        (
            ("C-c w" . whitespace-mode)
         )
  :hook
        (before-save . whitespace-cleanup)
  )

(use-package simple
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
  :commands
        (toggle-frame-fullscreen)
  :bind
        (
            ("C-c m f" . toggle-frame-fullscreen)
         )
  )

(use-package executable
  :hook
        ;; Automatically give executable permissions if file begins with shebang
        (after-save . executable-make-buffer-file-executable-if-script-p)
  )

(use-package elec-pair
  :config
        ;; Enable electric-pair-mode for automatic parens pairing
        (electric-pair-mode 1)
  )

(use-package autorevert
  :config
        ;; Automatically reload changed file in buffer
        (global-auto-revert-mode t)
  )

(use-package gdb-mi
  :config
        (setq gdb-many-windows t)
  )

(use-package cc-mode
  :commands
        (c-set-style)
  :hook
        ;; Change code indentation style for C
        (c-mode . (lambda()
            (c-set-style "cc-mode")))
  )

(use-package sh-script
  :mode
        ("\\.bats\\'" . sh-mode)
  :custom-face
        (sh-heredoc ((t (:foreground "color-136" :weight normal))))
  )

(use-package linum
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
  :config
        (setq
            wdired-allow-to-change-permissions t   ; allow to edit permission bits
            wdired-allow-to-redirect-links t       ; allow to edit symlinks
        )
  )

(use-package ibuffer
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
  :config
        ;; saveplace: remembers your location in a file when saving files
        (toggle-save-place-globally 1)
  )

(use-package compile
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
  )

(use-package custom
  :config
        (setq custom-file "~/.emacs.d/emacs-custom.el")
  )

;; (use-package simple
;;   :delight visual-line-mode
;;   )

(use-package eldoc
  :delight
  )

(use-package auth-source
  :custom
        (auth-sources (quote (
            "~/.authinfo"
            "~/Dropbox/keys/emacs/authinfo"
         )))
)

(use-package eshell
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
                          "<escape>" (lambda () (interactive)
                                       (protect-eshell-prompt)
                                       (evil-normal-state)
                                       (evil-end-of-line)))))
  :custom-face
        (eshell-prompt ((t (:foreground "green" :weight bold))))
  )

(use-package eww
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
  :hook
        (prog-mode . hs-minor-mode)
)

(use-package xref
  :general
        (
            :states '(normal motion visual)
            "M-." 'xref-find-definitions
         )
        (my-space-leader-def
            "." (general-simulate-key "M-.")
            "," (general-simulate-key "M-,")
         )
)

(use-package descr-text
  :bind
        (
            ("C-h c" . describe-char)
         )
)

(use-package elisp-mode
  :general
        (my-space-leader-def
            "e b" 'eval-buffer
            "e d" 'eval-defun
            "e l" 'eval-last-sexp
            "e x" 'eval-expression
         )
)

(use-package vc
  :general
        (my-space-leader-def
            "v u" 'vc-revert
         )
)

(use-package edebug
  :bind
        (
            ("C-c d e" . edebug-defun)
         )
  )

(use-package ert
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
  :general
        (my-space-leader-def
            "t e" 'my-ert-run
         )
  )

(use-package files
  :general
        (my-space-leader-def
            "w" 'save-buffer
         )
)

(use-package term
  :init
        (setq-default term-prompt-regexp "^[^$%>»]*[#$%>»] ")
)
