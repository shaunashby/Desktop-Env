;;
;; cust-shell-mode.el
;;
;;
;; cust-shell-mode.el
;;

;; Function to generate script header:
(defun insert-script-header (&optional shell) 
  (interactive)
  "Inserts some info, including VCS info, author, date and copyright."
  (setq shell (read-string "Shell type (return for sh default): "))
  (if (eq (length shell) 0) (setq shell "sh"))
  (insert 
   "#!/bin/" (symbol-value 'shell) "
#____________________________________________________________________ 
# File: " (buffer-name) "
#____________________________________________________________________ 
#  
# Author: " (user-full-name)  " <" user-mail-address ">
# Update: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$ 
#
# Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
#
#--------------------------------------------------------------------
"))

;; Keywords:
(setq cust-sh-mode-font-lock-keywords
      (list
       '("\\( -eq \\)" 1 'bold-YellowGreen-face t)    
       '("\\( -ne \\)" 1 'bold-YellowGreen-face t)    
       '("\\( -lt \\)" 1 'bold-YellowGreen-face t) 
       '("\\( -gt \\)" 1 'bold-YellowGreen-face t) 
       '("\\( -le \\)" 1 'bold-YellowGreen-face t) 
       '("\\( -ge \\)" 1 'bold-YellowGreen-face t) 
       '("\\(<<\\|>>\\) " 1 'IndianRed-face t)
       '("\\( < \\| > \\)" 1 'bold-Wheat2-face t)  
       '("\\( = \\)"  1 'bold-Wheat2-face t)
       '("\\( != \\)"  1 'bold-Wheat2-face t)
       '("\\( && \\)" 1 'bold-OrangeRed3-face t)
       '("\\( || \\)" 1 'bold-OrangeRed3-face  t)
       ))

(font-lock-add-keywords 'sh-mode cust-sh-mode-font-lock-keywords)
;;
(setq auto-mode-alist (cons '("\\.sh\\'" . sh-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ksh\\'" . sh-mode) auto-mode-alist))
;;
(add-hook 'sh-mode-hook
	  (function (lambda()
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (insert-script-header)
			     )))))	      
;;
;; End of cust-shell-mode.el
;;
