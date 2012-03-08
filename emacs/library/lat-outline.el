;;; lat-outline.el --- Lassi's outline mode preferences.

(setq outline-mode-hook
      (function
       (lambda()
	 (local-set-key "\M-F1"  'hide-body)
	 (local-set-key "\M-F2"  'show-all))))
