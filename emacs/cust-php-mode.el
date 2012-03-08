;; -*-emacs-lisp -*-
;; cust-php-mode.el
;;

;; Add mode hook for PHP mode:
(add-hook 'php-mode-hook
	  (function (lambda()
		      (auto-raise-mode 0)
		      )))
;;
;;(setq auto-mode-alist (cons '("\\.php\\'" . php-mode) auto-mode-alist))
;;(autoload 'php-mode "php-mode" "Major mode to edit PHP files." t)
;;
;; End of cust-php-mode.el
;;