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
  :disabled
  :config
		(cond ((string-equal system-type "darwin")
			(progn
				(setq helm-firefox-default-directory "~/Library/Application Support/Firefox/")
		)))
  )

(use-package browse-url
  :custom
		(browse-url-browser-function (quote w3m-browse-url))
  )

(provide 'init_emacs-w3m)
