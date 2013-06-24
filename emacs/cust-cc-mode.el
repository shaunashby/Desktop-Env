;;
;; cust-cc-mode.el
;;

;; Load functions needed by c and cc modes:
(load-library "cust-cc-mode-funcs")
(load-library "cust-cc-mode-faces")
(load-library "cust-cc-extra-faces")

;; C++ keywords:
(font-lock-add-keywords 'c++-mode '(("\\(public\\|private\\|protected\\):" 1 'bold-LightSteelBlue2-face t)
				    ("\\(struct\\|union\\|enum\\|virtual\\)" 1 'GreenYellow-face)
				    ("\\(catch\\|try\\|throw\\)" 1 'Plum2-face t)
				    ("\\(case\\|goto\\)" 1 'SkyBlue-face t)
				    ("\\(friend\\|inline\\)" 1 'Sienna2-face t)
				    ("\\(include\\)" 1 'Brown-face t)
				    ))
;; Customize C style:
(setq ashby-c-style
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
	(c-basic-offset			. 2)
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
	(c-backslash-column		. 78)))

;;
(setq
 c-auto-newline			t
 auto-mode-alist (append '(("\\.cc\\'"     . c++-mode)
			   ("\\.cpp\\'"    . c++-mode)
			   ("\\.cxx\\'"    . c++-mode)
			   ("\\.C\\'"      . c++-mode)
			   ("\\.icc\\'"    . c++-mode)
			   ("\\.h\\'"      . c++-mode)
			   ("\\.h\\.in\\'" . c++-mode)
			   ("\\.y\\'"	. c++-mode)
			   ("\\.l\\'"	. c++-mode))
			 auto-mode-alist))

(defun ashby-c-mode-common-hook ()
  ;;  (setq next-line-add-newlines nil)
  (c-add-style "ashby" ashby-c-style t)
  (turn-on-font-lock))

;; Hooks for C and C++ mode customisations:
(add-hook 'c-mode-common-hook 'ashby-c-mode-common-hook)

(add-hook 'c++-mode-hook (function (lambda ()
				     (define-key c++-mode-map "\C-m"  'newline-and-indent)
				     (define-key c++-mode-map "\C-ih" 'insert-c-in-c++-hdr-guards)
				     (define-key c++-mode-map "\C-nc" 'new-class-templates)
				     )))

(autoload 'c++-mode "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode   "cc-mode" "C Editing Mode"   t)
;;
;; End of cust-cc-mode.el
;;
