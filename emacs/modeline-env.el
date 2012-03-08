;; modeline-env.el
;; Some modeline customizations
;;
(setq mode-line-system-identification  
      (substring (system-name) 0
		 (string-match "\\..+" (system-name))))
;;
(setq default-mode-line-format
      (list "  "
            "< "
            'mode-line-system-identification
            " >"
            "  %14b"
            "      "
            "%[(" 
            'mode-name 
            'minor-mode-alist 
            "%n" 
            'mode-line-process  
            ")%]    " 
	    "--L%l--"
            '(-3 . "%P")
            "-%-"))

;; Start with new default:
(setq mode-line-format default-mode-line-format)

;;
;; End of modeline-env.el
;;