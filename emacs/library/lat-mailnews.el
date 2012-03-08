;;; lat-mailnews.el --- Lassi's mail and news preferences.

(add-hook 'mail-setup-hook 'lat::add-mail-headers)

(defun lat::add-mail-headers ()
  (save-excursion
    (mail-position-on-field "From")
    (insert "\"Lassi A. Tuura\" <Lassi.Tuura@cern.ch>")
    (mail-position-on-field "X-Charset")
    (insert "LATIN1")
    (mail-position-on-field "Content-type")
    (insert "text/plain; charset=ISO-8859-1")
    (mail-position-on-field "Content-Transfer-Encoding")
    (insert "8bit")
    ;;(lat::yank)
    ))

(defun lat::yank ()
  (defvar mail-yank-indent-string "> ")
  (defun mail-yank-original (arg)
    (interactive "P")
    (if mail-reply-buffer
	(let ((start (point)))
	  (delete-windows-on mail-reply-buffer)
	  (insert-buffer mail-reply-buffer)
	  (let ((beg (point)))
	    (re-search-forward "^$" (point-max) t)
	    (forward-line 1)
	    (delete-region beg (point)))
	  (goto-char (point-max))
	  (forward-line -8)
	  (let ((end (point)))
	    (goto-char (point-max))
	    (if (re-search-backward "^--$" end t)
		(progn
		  (delete-region (point) (point-max))
		  (backward-char 1)
		  (kill-line))))
	  (goto-char start)
	  (mail-yank-indent start)
	  (exchange-point-and-mark)
	  )))

  (defun mail-yank-indent (start)
    (save-excursion
      (goto-char start)
      (while (re-search-forward "^" (point-max) t)
	(replace-match mail-yank-indent-string))
      )))

;; GNUS
(setq mail-default-reply-to		"Lassi.Tuura@cern.ch"
      gnus-user-from-line		"\"Lassi A. Tuura\" <Lassi.Tuura@cern.ch>"
      gnus-user-full-name		"Lassi A. Tuura"
      gnus-user-login-name		"Lassi.Tuura"
      gnus-use-generic-from		"cern.ch"
      gnus-use-generic-path		"cern.ch"
      gnus-use-followup-to		'ask
      gnus-local-organization		"Northeastern University, Boston, USA"
      gnus-signature-file		(expand-file-name "~/.signature")
      gnus-group-use-permanent-levels	t
      gnus-group-line-format		"%M%S%p%L/%5y: %(%g%)\n"
      gnus-level-default-subscribed	5
      gnus-level-default-unsubscribed	6
      gnus-summary-gather-subject-limit	'fuzzy
      gnus-summary-make-false-root	'dummy
      gnus-auto-extend-newsgroup	t
      gnus-default-article-saver	'gnus-summary-save-in-file
      gnus-use-full-window		nil
      gnus-article-save-directory	"~/mail/local/News.sbd"
      gnus-use-long-file-name		t
      gnus-show-all-headers		nil
      gnus-auto-center-summary		nil
      gnus-suppress-duplicates		t
      mail-yank-prefix			"|> ")

(setq gnus-visual-mark-article-hook
  (lambda ()
    (gnus-article-highlight)))

;; Combine gnus-group-sort-by-level and gnus-group-sort-by-alphabet
(setq gnus-group-sort-function
  (lambda (info1 info2)
    (let ((level1 (nth 1 info1))
	  (level2 (nth 1 info2)))
      (or (< level1 level2)
	  (and (eq level1 level2)
	       (gnus-group-sort-by-alphabet info1 info2))))))

(setq news-replay-header-hook
  (lambda () (insert news-reply-yank-from " writes:\n\n")))


(add-hook 'gnus-exit-gnus-hook
	  '(lambda ()
	     ;; Kill news posting buffers
	     (and (get-buffer "*post-news*") (kill-buffer "*post-news*"))))

(add-hook 'gnus-prepare-article-hook
	  '(lambda ()
	     (gnus-article-to-latin1)
	     (gnus-article-word-wrap)
	     (gnus-article-remove-cr)
	     (gnus-article-de-quoted-unreadable)))


(add-hook 'gnus-inews-article-header-hook
	  '(lambda ()
	     (goto-char (point-max))
	     (insert "X-Disclaimer: This message represents at most my opnions\n")))

(add-hook 'gnus-inews-article-hook
	  '(lambda ()
	     (interactive)
	     (point-to-register 'back)
	     (goto-char (point-min))
	     (if (or (equal gnus-nntp-server "otax.tky.hut.fi")
		     (re-search-forward "^Newsgroups: \\(fi\\|sf\\)net\\."
					(point-max) t))
		 (progn
		   (mail-position-on-field "Mime-Version")
		   (insert "1.0")
		   (mail-position-on-field "X-Charset")
		   (insert "LATIN1")
		   (mail-position-on-field "Content-type")
		   (insert "text/plain; charset=ISO-8859-1")
		   (mail-position-on-field "Content-Transfer-Encoding")
		   (insert "8bit")
		   (if (y-or-n-p "Convert 7 bits -> 8 bits? ")
		       (if (y-or-n-p "Blindly? ")
			   (sf7-to-latin1)
			 (sf7-to-latin1-query)))))
	     (register-to-point 'back)))

(setq gnus-message-archive-group
      '((if (message-news-p)
	    "News"
	  "Mails")))

(add-hook 'gnus-summary-mode-hook
	  '(lambda ()
	     (local-set-key "b" 'gnus-summary-prev-page)))

(add-hook 'gnus-article-mode-hook
	  '(lambda ()
	     (kill-local-variable 'global-mode-string)))

(defun gnus-article-to-sf7 ()
  (interactive)
  (set-buffer gnus-article-buffer)
  (latin1-to-sf7))

(defun gnus-article-to-latin1 ()
  (interactive)
  (set-buffer gnus-article-buffer)
  (goto-char (point-min))
  (if (and (or (equal gnus-nntp-server "otax.tky.hut.fi")
	       (string-match "\\(fi\\|sf\\)net\\."
			     (gnus-fetch-field "Newsgroups")))
	   (not (and (gnus-fetch-field "Mime-Version")
		     (string-match "charset=iso-8859-1"
				   (gnus-fetch-field "Content-Type")))))
      (sf7-to-latin1)))

(defun latin1-to-sf7 ()
  (interactive)
  (let ((buffer-read-only nil))
    (subst-char-in-region (point-min) (point-max) ?\344 ?\{ t)
    (subst-char-in-region (point-min) (point-max) ?\304 ?\[ t)
    (subst-char-in-region (point-min) (point-max) ?\345 ?\} t)
    (subst-char-in-region (point-min) (point-max) ?\305 ?\] t)
    (subst-char-in-region (point-min) (point-max) ?\366 ?\| t)
    (subst-char-in-region (point-min) (point-max) ?\326 ?\\ t)))

(defun sf7-to-latin1 ()
  (interactive)
  (let ((buffer-read-only nil))
    (subst-char-in-region (point-min) (point-max) ?\{ ?\344 t)
    (subst-char-in-region (point-min) (point-max) ?\[ ?\304 t)
    (subst-char-in-region (point-min) (point-max) ?\} ?\345 t)
    (subst-char-in-region (point-min) (point-max) ?\] ?\305 t)
    (subst-char-in-region (point-min) (point-max) ?\| ?\366 t)
    (subst-char-in-region (point-min) (point-max) ?\\ ?\326 t)))

(defun sf7-to-latin1-query ()
  (interactive)
  (let ((start (point-min)))
    (switch-to-buffer (current-buffer))
    (point-to-register 'back)
    (goto-char start) (query-replace "{" "\344")
    (goto-char start) (query-replace "[" "\304")
    (goto-char start) (query-replace "}" "\345")
    (goto-char start) (query-replace "]" "\305")
    (goto-char start) (query-replace "|" "\366")
    (goto-char start) (query-replace "\\" "\326")
    (register-to-point 'back)))
	   
(add-hook 'news-reply-mode-hook 'lat::yank)

(defun gnus-news () "Read news with GNUS." (interactive)
  (setq gnus-nntp-server "news.cern.ch"
        gnus-startup-file "~/.newsrc-news")
  (gnus))
