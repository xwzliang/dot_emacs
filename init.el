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

;; Settings for MacOS
(cond ((string-equal system-type "darwin")
       (progn
         ;; modify option and command key
         (setq mac-command-modifier 'super)
         (setq mac-option-modifier 'meta)
  )))

;; load paths
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my_inits"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my_packages"))


;; Package settings

;; use-package
(eval-when-compile
  (require 'use-package))
(require 'bind-key)


;; Third party packages with use-package

(use-package restart-emacs
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
		(general-create-definer my-prefix-key-evil-def :prefix "C-c e")
  )

(use-package clues-theme
  :init
		(load-theme 'clues t)
  )

(use-package macrostep
  )

(use-package persp-mode
  :init
  		(add-hook 'after-init-hook 'persp-mode)
  :config
		; Don't auto resume
		(setq persp-auto-resume-time 0)
		(persp-set-keymap-prefix (kbd "C-c r"))
  )

;; company-mode
(use-package company
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

(use-package evil
  :init
		(setq evil-want-keybinding nil)		;; required by evil-collection
  :bind
		(
			:map evil-motion-state-map
			; Use B,E to move to the beggining and end of line
			("B" . evil-beginning-of-line)
			("E" . evil-end-of-line)
			; Use C-b to evil-scroll-up instead of evil-scroll-page-up
			("C-b" . evil-scroll-up)
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

(use-package smartparens-config
  :commands
  		smartparens-mode
  ;; :config
  ;; 		(smartparens-global-mode 1)
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

(use-package git-gutter
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
  :bind-keymap
		("C-c h" . helm-command-prefix)
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

(use-package hydra
  )

(use-package projectile
  :bind-keymap
		("C-c p" . projectile-command-map)
  :bind
  		(
			("C-c TAB" . projectile-find-other-file)
			;; ("C-c P" . (lambda () (interactive)
			;; 			(projectile-cleanup-known-projects)
			;; 			(projectile-discover-projects-in-search-path)))
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
  )

(use-package iedit
  :bind
  		(
			("C-c s" . iedit-mode)
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

(use-package bookmark+
  :load-path
		"~/.emacs.d/custom/bookmark-plus/"
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
			("C-c g t" . magit-tag)
			:map magit-mode-map
			("o" . magit-file-checkout)
  		 )
  :hook
		(magit-post-refresh . git-gutter:update-all-windows)
		(after-save . magit-after-save-refresh-status)
  )

(use-package evil-magit
  :after
		(evil magit)
  )

(use-package forge
  :after
		(magit)
  )

(use-package insert-shebang
  :hook
		;; For file extension in my_insert_file_type_list and file has not been created yet, insert shebang, two newline and enter evil-insert-state
		(find-file . (lambda ()
			(setq my_insert_file_type_list (list
				"sh"
				"py"
				"bats"
				))
			(if (and (member (file-name-extension (buffer-name)) my_insert_file_type_list) (not (file-exists-p (buffer-name))))
				(progn
					(insert-shebang)
					(newline)
					(newline)
					(evil-insert-state)
					))))
  :custom
		(insert-shebang-file-types (quote
			(("py" . "python3")
			("sh" . "bash")
			("pl" . "perl")
			("bats" . "bats"))))
		(insert-shebang-ignore-extensions (quote (
			"txt"
			"org"
			"c"
		 )))
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
  :config
		(golden-ratio-mode 1)
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
			("C-c o j" . org-capture)
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
		(setq org-todo-keywords '((sequence "SOMEDAY(s)" "TODO(t!)" "NEXT(n!)" "WAITING(w@/!)" "|" "DONE(d@)" "CANCELED(c@)")))
		;; TODO state to which a repeater should return the repeating task.
		(setq org-todo-repeat-to-state "TODO")
		(setq org-tag-alist '(("Daily" . ?d) ("Research" . ?r) ("Learning" . ?l) ("Code" . ?c) ("URGENT" . ?u) ("optional" . ?o)))
		(setq org-capture-templates
		'(
			("e" "Journal Entry"
				entry (file+olp+datetree (lambda () (concat org-directory "/journal.org")))
				"* %?")
			("j" "Journal Checklist"
				checkitem (file+olp+datetree (lambda () (concat org-directory "/journal.org")))
				"[/]\n- [ ] %?")
			("c" "Checklist Item"
				plain (function (lambda nil (goto-char (point))))
				"*** Checklist\n- [ ] %?")
		))
  :hook
		(org-mode . (lambda ()
			(visual-line-mode)
			"Beautify Org Checkbox Symbol"
			(push '("[ ]" . "☐") prettify-symbols-alist)
			(push '("[X]" . "☑" ) prettify-symbols-alist)
			(prettify-symbols-mode)))
  )

(use-package org-id
  :after
		(org)
  :config
		; Need this to resolve id links
		(setq org-id-link-to-org-use-id t)
		;; (setq org-id-locations-file "~/Dropbox/org/.org-id-locations")
		(setq org-id-locations-file (concat org-directory "/.org-id-locations"))
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
  		 )
  :config
		; agenda files
		(add-to-list 'org-agenda-files org-directory)
  )

(use-package evil-org
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

(use-package org-ref
  :after
		(org)
  :config
		(setq org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib"))
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
			(org-expiry-deinsinuate) 	;; Don't log creation for anki-editor-mode
			(visual-line-mode)
			(anki-editor-reset-cloze-number)
		))
  )

(use-package my_macros
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
  )

(use-package simple
  :commands
		(visual-line-mode)
  :bind
		(
			("C-c v" . visual-line-mode)
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
			("C-c l" . linum-mode)
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
			; Use "C-c e" to edit in dired mode.
			("C-c e" . wdired-change-to-wdired-mode)
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
  )

(use-package custom
  :config
		(setq custom-file "~/.emacs.d/emacs-custom.el")
  )

(use-package auth-source
  :custom
		(auth-sources (quote (
			"~/.authinfo"
			"~/Dropbox/keys/emacs/authinfo"
		 )))
)

