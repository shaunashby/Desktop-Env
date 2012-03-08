;;
;; cust-makefile-mode.el
;;

;; Stuff for font-lock:
(setq cust-makefile-font-lock-keywords
      (list
       '("\\(^VPATH \\)=" 1 'Green-face t)
       '("\\(^vpath\\)"   1 'LimeGreen-face t)
       '("::" . 'Thistle2-face)
       '("\\<\\(wildcard \\|patsubst \\|filter \\|filter-out \\|subst \\)" 1 'Pink-face t)
       '("\\<\\(dir \\|notdir \\|suffix \\|basename \\|join \\)" 1 'Tan-face t)
       '("\\<\\(addsuffix \\|addprefix \\)" 1 'Tan3-face t)
       '("\\(override\\)" 1 'Sienna2-face t)
       '("\\(include \\|-include \\)" 1 'Violet-face t)
       '("\\(define\\|endef\\)" 1 'bold-italic t)
       '("^define \\(.*\\)" 1 'Definition-face t)
       '("^ *\\([^ \n\t#:=]+\\([ \t]+\\([^ \t\n#:=]+\\|\\$[({][^ \t\n#})]+[})]\\)\\)*\\)[ \t]*:\\([ \t]*$\\|\\([^=\n].*$\\)\\)" 1 'font-lock-function-name-face t)
       '("\\(\\[%.*?%\\]\\)" 1 'Template-face t)
       '("^#.*" 0 'font-lock-comment-face t)
       ))

(font-lock-add-keywords 'makefile-mode cust-makefile-font-lock-keywords)

;; Functions:
(defun makefile-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including CVS Id, author, date and copyright."
  (insert 
   "#____________________________________________________________________ 
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

.PHONY : 

# Variables:


#############

"))

(defun makefile-insert-file-footer () 
  (interactive)
  "Inserts a footer at end of file."
  (insert 
   "#____________________________________________________________________ 
# End of " (buffer-name) "
#____________________________________________________________________ 
#  
"))

;; If cond:
(defun makefile-if-loop ()
  (interactive)
  (insert
   "X := $(if cond,$(true_thing),$(else-thing))\n"
   ))

;; For loops:
(defun makefile-foreach-loop ()
  (interactive)
  "Inserts a single-line FOREACH loop."
  (insert
   "X := $(foreach tvar,$(tvars),$(wildcard $(tvar)/*))\n"
   ))


;; Hooks:
(add-hook 'makefile-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define mkf-menu makefile-mode-map "makefile Menu"
			'("Insert"
			  ["Insert File Header" makefile-insert-file-header t]
			  ["Insert File Footer" makefile-insert-file-footer t]
			  "---"
			  ["If .." makefile-if-loop t]
			  ["For Loop" makefile-foreach-loop t]
;;			  "---"
;;			  ["Insert Class" insert-class t]
;;			  ["Insert Member Functions" insert-member-funcs t]
;;			  "---"
;;			  ["Insert System Header" system-include-header t]
;;			  ["Insert Local Header" local-include-header t]
			  ))
		      ;;
;;		      (define-key makefile-mode-map "\C-m" 'newline-and-indent)
;;		      (define-key makefile-mode-map "\C-cic" 'insert-class)
;;		      (define-key makefile-mode-map "\C-cnc" 'new-class-templates)
;;		      (define-key makefile-mode-map "\C-cmf" 'insert-member-funcs)
;;		      (define-key makefile-mode-map "\C-csh" 'system-include-header)
;;		      (define-key makefile-mode-map "\C-clh" 'local-include-header)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (makefile-insert-file-header)
			     (makefile-insert-file-footer)
			     )))))

;; 
(setq auto-mode-alist (append '(("\\.mk\\'" . makefile-mode) 
				("\\.make\\'" . makefile-mode)
				("\\.Make\\'" . makefile-mode)
				)
			      auto-mode-alist))

;;
;; End of cust-makefile-mode.el
;;