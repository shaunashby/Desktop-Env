;; cms-cc-mode.el --- Customisations to `cc-mode' for the CMS software.

;; * Defaults C++ header and source files to `cc-mode'; likewise for
;;   Objectivity DDL files.
;; * Sets the automatic indentatation to rules that are generally
;;   pleasing aesthetically and that conform to the CMS coding rules.
;; * Turns on `font-lock-mode' for all C/C++ code.

(setq cms-c-style
      '((c-offsets-alist
	 . ((string			. -1000)
	    (c				. c-lineup-C-comments)
	    (defun-open			. 0)
	    (defun-close		. 0)
	    (defun-block-intro		. +)
	    (class-open			. 0)
	    (class-close		. 0)
	    (inline-open		. +);; Change this!
	    (inline-close		. 0);; Change this!
	    (func-decl-cont		. -);; Change this!
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
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
 c-tab-always-indent		nil
 c-recognize-knr-p		nil
 c-backslash-column		78
 c-progress-interval		1
 c-auto-newline			t

 auto-mode-alist		(append '(("\\.h\\'"	 . c++-mode)
					  ("\\.h\\.in\\'"  . c++-mode)
					  ("\\.y\\'"	 . c++-mode)
					  ("\\.l\\'"	 . c++-mode)
					  ("\\.ddl\\'"	 . c++-mode)
					  ("\\.g\\'"	 . c++-mode)
					  ("[Mm]akefile" . makefile-mode))
					auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cms-c-insert-guard ()
  (interactive)
  (let ((filename (buffer-file-name)))
    (insert (cms-header-guard filename (cms-source-convention filename)))))

(defun cms-c-mode-common-hook ()
  (define-key c-mode-base-map "\C-cg" 'cms-c-insert-guard)
  (setq next-line-add-newlines nil)
  (c-add-style "cms" cms-c-style t)
  (turn-on-font-lock))

(add-hook 'c-mode-common-hook 'cms-c-mode-common-hook)
(autoload 'c++-mode "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode "cc-mode" "C Editing Mode" t)
