;;
;; cust-text-mode.el
;;

;; The hook:
(add-hook 'text-mode-hook 'turn-on-font-lock)

(add-hook 'text-mode-hook
	  (function (lambda ()
		      (define-key text-mode-map "\C-xc" 'xcode-template-macroize)
		      (font-lock-mode t)
		      (auto-fill-mode t)
		      )))

(setq auto-mode-alist (cons '("\\.txt\\'" . text-mode) auto-mode-alist))

;;
;; End of cust-text-mode.el
;;
