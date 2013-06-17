;;
;; cust-c-mode.el
;;


;; Function to generate header:
(defun c-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert 
   "/*********************************************************************
 File: " (buffer-name) "
---------------------------------------------------------------------- 
  
 Author: " (user-full-name)  " <" user-mail-address ">
 Update: " (format-time-string "%Y-%m-%d %T%z") "
 Revision: $Id" "$ 

 Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "

*********************************************************************/
#include <stdio.h>
"))

;;
(add-hook 'c-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define c-menu c-mode-map "C Menu"
			'("Insert"
			  ["Insert File Header" c-insert-file-header t]
			  "---"
			  ["Insert System Header" system-include-header t]
			  ["Insert Local Header" local-include-header t]
			  ))
		      ;;
		      (define-key c-mode-map "\C-csh" 'system-include-header)
		      (define-key c-mode-map "\C-clh" 'local-include-header)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (c-insert-file-header)))
		      (or (file-exists-p "makefile")
			  (file-exists-p "Makefile")
			  (set (make-local-variable 'compile-command)
			       (concat "gcc -o "
				       (substring
					(file-name-nondirectory buffer-file-name)
					0
					(string-match
					 "\\.c$"
					 (file-name-nondirectory buffer-file-name)))
				       " "
				       (file-name-nondirectory buffer-file-name)))))))

;;
;; cust-c-mode.el
;;
