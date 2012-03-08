;;; lat-editenv.el -- Lassi's general editor settings.

(setq
 display-time-day-and-date	t
 goal-column			nil
 inhibit-startup-message	t
 require-final-newline		'ask
 scroll-step			1
 lpr-switches			'("-P40-3d-cor")

 fill-column			70
 buffers-menu-max-size		nil
 dired-listing-switches		"-alpF"
 dired-ls-F-marks-symlinks	t
 display-time-24hr-format	t
 line-number-mode		t
 column-number-mode		t
 rlogin-password-paranoia	t
 search-highlight		t
 truncate-partial-width-windows	nil
 inhibit-default-init		t

 no-mail-string			""
 yes-mail-string		" ---Mail"
 beep-for-mail			nil
 suppress-day-of-week		t

 completion-ignore-case		t)

(show-paren-mode)
(display-time)
(global-font-lock-mode t)
(setq transient-mark-mode t)

(if window-system
    (progn
      (load-library "frame-status")
      (if (string-lessp "19" emacs-version)
	  (progn (load-library "mwheel") (mwheel-install))))
  (require 'xt-mouse))

;; I want ISO chars to show as printed
(standard-display-european 1)
(standard-display-8bit 160 255)

(defun terminal-8bit-able nil
  "Tell emacs my terminal can send and receive 8 bit chars."
  (interactive)
  (set-input-mode (car (current-input-mode))
		  (nth 1 (current-input-mode))
		  'accept-8bit-input))
(terminal-8bit-able)

;; Enable all sorts of novice stuff.
(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Activate edit server
;; (server-start nil)

;; Default modes and hooks
(setq default-major-mode 'text-mode)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'tex-mode-hook 'flyspell-mode)
(add-hook 'latex-mode-hook 'flyspell-mode)
(add-hook 'tex-mode (function (lambda () (setq ispell-parser 'tex))))
(add-hook 'latex-mode (function (lambda () (setq ispell-parser 'tex))))

(autoload 'granny "granny"
  "Display the result of the cvs annotate command using colors." t)
