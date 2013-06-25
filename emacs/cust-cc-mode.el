;;
;; cust-cc-mode.el
;;

;; Load functions needed by c and cc modes:
(load-library "cust-cc-mode-funcs")
(load-library "cust-cc-mode-faces")

;; C++ keywords:
(font-lock-add-keywords 'c++-mode '(("\\<FIXME" 0 font-lock-warning-face t)
				    ("\\(public\\|private\\|protected\\):" 1 'bold-LightSteelBlue2-face t)
				    ("\\(struct\\|union\\|enum\\|virtual\\)" 1 'GreenYellow-face)
				    ("\\(friend\\|inline\\)" 1 'Sienna2-face t)))
;; Customize C style:
(setq ashby-c-style
      '((c-offsets-alist                . ((string			. -1000)
					   (c		 	        . c-lineup-C-comments)
					   (defun-open		        . 0)
					   (defun-close		        . 0)
					   (defun-block-intro	        . 0)
					   (class-open			. 0)
					   (class-close		        . 0)
					   (inline-open		        . 0);; Change this!
					   (inline-close		. 0);; Change this!
					   (func-decl-cont		. -);; Change this!
					   (knr-argdecl-intro	        . +)
					   (knr-argdecl		        . 0)
					   (topmost-intro		. 0)
					   (topmost-intro-cont	        . 0)
					   (member-init-intro	        . +)
					   (member-init-cont	        . 0)
					   (inher-intro		        . +)
					   (inher-cont		        . c-lineup-multi-inher)
					   (block-open		        . 0)
					   (block-close		        . 0)
					   (brace-list-open		. 0)
					   (brace-list-close	        . 0)
					   (brace-list-intro	        . +)
					   (brace-list-entry	        . 0)
					   (statement		        . 0)
					   (statement-cont		. c-lineup-math);; +
					   (statement-block-intro	. +)
					   (statement-case-intro	. +)
					   (statement-case-open	        . +);; 0
					   (substatement		. +)
					   (substatement-open	        . 0);; +
					   (case-label		        . 0)
					   (access-label		. -)
					   (label			. -);; 2
					   (do-while-closure	        . 0)
					   (else-clause		        . 0)
					   (comment-intro		. c-lineup-comment)
					   (arglist-intro		. +)
					   (arglist-cont		. 0)
					   (arglist-cont-nonempty	. c-lineup-arglist)
					   (arglist-close		. +)
					   (stream-op		        . c-lineup-streamop)
					   (inclass			. +)
					   (cpp-macro		        . -1000)
					   (friend			. 0)
					   (extern-lang-open	        . 0)
					   (extern-lang-close	        . 0)
					   (inextern-lang		. +)
					   (template-args-cont	        . +)
					   ))
	;;
	(c-basic-offset			. 2)
	(c-comment-only-line-offset	. (0 . 0))
	;;
	(c-cleanup-list                 . (brace-else-brace
					   brace-catch-brace
					   brace-elseif-brace
					   defun-close-semi
					   empty-defun-braces
					   scope-operator
					   compact-empty-funcall))

	(c-hanging-braces-alist	        . ((brace-list-open after)
					   (substatement-open after)
					   (block-close . c-snug-do-while)))
	(c-hanging-colons-alist	        . ((member-init-intro before)
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
  (setq next-line-add-newlines nil)
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
