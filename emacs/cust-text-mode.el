;;
;; cust-text-mode.el
;;

;; The hook:
(add-hook 'text-mode-hook 'turn-on-font-lock)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(add-hook 'text-mode-hook
	  (function (lambda ()
		      (define-key text-mode-map "\C-xc" 'xcode-template-macroize)
		      )))

(setq auto-mode-alist (cons '("\\.txt|\\.letter\\'" . text-mode) auto-mode-alist))

;;
;; End of cust-text-mode.el
;;
