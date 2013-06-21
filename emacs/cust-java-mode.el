;;
;; cust-java-mode.el
;;

;; Java keywords:
(setq cust-java-font-lock-keywords
      (list
       '("^class \\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
       '("\\(public\\|private\\|protected\\|package\\)" 1 'bold-LightSteelBlue2-face t)
       '("::" . 'Thistle2-face)
       '("\\<\\(catch\\|try\\|throw\\)" 1 'Plum2-face t)
       ))

(font-lock-add-keywords 'java-mode cust-java-font-lock-keywords)
;;
(add-hook 'java-mode-hook
	  (function (lambda ()
		      ;;
		      (define-key java-mode-map "\C-m" 'newline-and-indent))))
;;
;; End of cust-java-mode.el
;;
