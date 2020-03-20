(use-package w3m
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
			("m" . w3m-bookmark-view)
			("M" . w3m-bookmark-view-new-session)
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
		(evil-set-initial-state 'w3m-mode 'normal)
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

;; key bindings
;; (define-key w3m-mode-map (kbd "o") 'w3m-goto-url)
;; (define-key w3m-mode-map (kbd "O") 'w3m-goto-url-new-session)
;; (define-key w3m-mode-map (kbd "f") 'w3m-lnum-follow)
;; (define-key w3m-mode-map (kbd "F") 'w3m-lnum-goto)
;; (define-key w3m-mode-map (kbd "c") 'w3m-submit-form)
;; (define-key w3m-mode-map (kbd "P") 'w3m-print-current-url)
;; (define-key w3m-mode-map (kbd "p") 'w3m-print-this-url)
;; (define-key w3m-mode-map (kbd "i") 'w3m-view-this-url)
;; (define-key w3m-mode-map (kbd "g") 'beginning-of-buffer)
;; (define-key w3m-mode-map (kbd "G") 'end-of-buffer)
;; (define-key w3m-mode-map (kbd "D") 'w3m-delete-buffer)
;; (define-key w3m-mode-map (kbd "m") 'w3m-bookmark-view)
;; (define-key w3m-mode-map (kbd "M") 'w3m-bookmark-view-new-session)
;; (define-key w3m-mode-map (kbd "V") 'w3m-view-url-with-browse-url)
;; (define-key w3m-mode-map (kbd "u") 'w3m-scroll-down-or-previous-url)
;; (define-key w3m-mode-map (kbd "y") 'evil-yank)
;; (define-key w3m-mode-map (kbd "M-k") 'evil-window-up)
;; (define-key w3m-mode-map (kbd ":") 'evil-ex)
;; (define-key w3m-mode-map (kbd "/") 'evil-search-forward)
;; (define-key w3m-mode-map (kbd ";") 'evil-repeat-find-char)
;; (define-key w3m-mode-map (kbd "?") 'evil-search-backward)
;; (define-key w3m-mode-map (kbd "n") 'evil-search-next)
;; (define-key w3m-mode-map (kbd "w") 'evil-forward-word-begin)
;; (define-key w3m-mode-map (kbd "b") 'evil-backward-word-begin)
;; (define-key w3m-mode-map (kbd "v") 'evil-visual-char)
;; (define-key w3m-mode-map (kbd "M-l") 'evil-window-right)
;; (define-key w3m-mode-map (kbd "M-p") 'w3m-previous-buffer)
;; (define-key w3m-mode-map (kbd "M-n") 'w3m-next-buffer)
;; (define-key w3m-mode-map (kbd "C-j") 'w3m-scroll-up)
;; (define-key w3m-mode-map (kbd "C-k") 'w3m-scroll-down)
;; (define-key w3m-mode-map (kbd "x") 'w3m-delete-buffer)
;; (define-key w3m-mode-map (kbd "X") 'w3m-delete-other-buffers)
;; (define-key w3m-mode-map (kbd "s") 'w3m-search)
;; (define-key w3m-mode-map (kbd "S") 'w3m-search-new-session)

(provide 'init_emacs-w3m)
