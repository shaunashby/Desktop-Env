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

;; To insert a new compile command:
(defun insert-c-compile-command (&optional compiler)
  (interactive)
  "Inserts a new compile-command block at end of file."
  (if (not compiler)
      (setq compiler (read-string "Compiler name: ")))
  (if (eq (length compiler) 0) (setq compiler ccdefault))
  (end-of-buffer)
  (insert
   "/*\n"
   " *  Local variables:\n"
   " *  compile-command: \"" 
   (symbol-value 'compiler) " " (buffer-name) " -o " (file-name-sans-extension (buffer-name)) ".exe\"\n"
   " *  End:\n"
   " */")
   (save-buffer))

;; Style:
(defconst shaun-c-style
  '((c-tab-always-indent           . t)
    (c-hanging-braces-alist        . ((substatement-open before after)
                                      (brace-list-open)))
    (c-hanging-colons-alist        . ((member-init-intro before)
                                      (inher-intro)
                                      (case-label after)
                                      (label after)
                                      (access-label after)))
    (c-cleanup-list                . (scope-operator))
    (c-offsets-alist         . ((arglist-close         . c-lineup-arglist)
                                (defun-block-intro     . 1)
                                (substatement-open     . 3)
                                (statement-block-intro . 0)
                                (topmost-intro         . -1)
                                (case-label            . 0)
                                (block-open            . 0)
                                (knr-argdecl-intro     . -)))
    )
  "Shaun Programming Style")

;; CMS style:
(setq cms-c-style
      '((c-offsets-alist
	 . ((string			. -1000)
	    (c				. c-lineup-C-comments)
	    (defun-open			. 0)
	    (defun-close		. 0)
	    (defun-block-intro		. +)
	    (class-open			. 0)
	    (class-close		. 0)
	    (inline-open		. +)
	    (inline-close		. 0)
	    (func-decl-cont		. -)
	    (knr-argdecl-intro		. +)
	    (knr-argdecl		. 0)
	    (topmost-intro		. 0)
	    (topmost-intro-cont		. 0)
	    (member-init-intro		. +)
	    (member-init-cont		. 0)
	    (inher-intro		. +)
	    (inher-cont			. c-lineup-multi-inher)
	    (block-open			. 0)
	    (block-close		. 0)
	    (brace-list-open		. 0)
	    (brace-list-close		. 0)
	    (brace-list-intro		. +)
	    (brace-list-entry		. 0)
	    (statement			. 0)
	    (statement-cont		. c-lineup-math);; +
	    (statement-block-intro	. +)
	    (statement-case-intro	. +)
	    (statement-case-open	. +);; 0
	    (substatement		. +)
	    (substatement-open		. 0);; +
	    (case-label			. 0)
	    (access-label		. -)
	    (label			. -);; 2
	    (do-while-closure		. 0)
	    (else-clause		. 0)
	    (comment-intro		. c-lineup-comment)
	    (arglist-intro		. +)
	    (arglist-cont		. 0)
	    (arglist-cont-nonempty	. c-lineup-arglist)
	    (arglist-close		. +)
	    (stream-op			. c-lineup-streamop)
	    (inclass			. +)
	    (cpp-macro			. -1000)
	    (friend			. 0)
	    (objc-method-intro		. -1000)
	    (objc-method-args-cont	. c-lineup-ObjC-method-args)
	    (objc-method-call-cont	. c-lineup-ObjC-method-call)
	    (extern-lang-open		. 0)
	    (extern-lang-close		. 0)
	    (inextern-lang		. +)
	    (template-args-cont		. +)))
	(c-basic-offset			. 4)
	(c-comment-only-line-offset	. (0 . 0))
	(c-cleanup-list			. (empty-defun-braces
					   scope-operator
					   defun-close-semi
					   list-close-comma))
	(c-hanging-braces-alist		. ((brace-list-open after)
					   (class-open before after)
					   (substatement-open before after)
					   (block-close . c-snug-do-while)))
	(c-hanging-colons-alist		. ((member-init-intro before)
					   (access-label after)))
	(c-electric-pound-behavior	. (alignleft))
	(c-backslash-column		. 72)))

;; Add default style (mine) to the hook:
(defun shaun-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (c-add-style "SHAUN" shaun-c-style t)
  (c-add-style "CMSSW" cms-c-style t)
  ;; offset customizations not in shaun-c-style
  (c-set-offset 'member-init-intro '++)
  )

;; Disable style customizations 19/10/06
;;(add-hook 'c-mode-common-hook 'shaun-c-mode-common-hook)
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
			  "---"
			  ["Insert Compile Command" insert-c-compile-command t]
			  ))
		      ;;
		      (define-key c-mode-map "\C-csh" 'system-include-header)
		      (define-key c-mode-map "\C-clh" 'local-include-header)
		      (define-key c-mode-map "\C-ccc" 'insert-c-compile-command)
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

;; Add hook for Obj-C mode:
(add-hook 'objc-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define objc-menu objc-mode-map "ObjC Menu"
			'("Insert"
			  ["Insert File Header" c-insert-file-header t]
			  "---"
			  ["Insert System Header import" system-import-header t]
			  "---"
			  ["Insert System Header include" system-include-header t]
			  ["Insert Local Header include" local-include-header t]
			  "---"
			  ["Insert Compile Command" insert-c-compile-command t]
			  ))
		      ;;
		      (define-key objc-mode-map "\C-csi" 'system-import-header)
		      (define-key objc-mode-map "\C-csh" 'system-include-header)
		      (define-key objc-mode-map "\C-clh" 'local-include-header)
		      (define-key objc-mode-map "\C-ccc" 'insert-c-compile-command)
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
					 "\\.m$"
					 (file-name-nondirectory buffer-file-name)))
				       " "
				       (file-name-nondirectory buffer-file-name)))))))
;;
;; cust-c-mode.el
;;
