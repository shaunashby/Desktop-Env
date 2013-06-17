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

;; Function to generate header:
(defun java-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert 
   "//____________________________________________________________________ 
// File: " (buffer-name) "
//____________________________________________________________________ 
//  
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$ 
//
// Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
//
//--------------------------------------------------------------------
"))

;;
(add-hook 'java-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define java-menu java-mode-map "Java Menu"
			'("Insert"
			  ["Insert File Header" java-insert-file-header t]
			  ))
		      ;;
		      (define-key java-mode-map "\C-m" 'newline-and-indent))))
;;
(setq auto-mode-alist (append '(("\\.java\\'" . java-mode))
			      auto-mode-alist))

;;
;; End of cust-java-mode.el
;;
