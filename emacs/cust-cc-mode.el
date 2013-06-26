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
;;
(setq
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

;; Create my personal style:
(defconst ashby-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 4)
    (c-hanging-braces-alist     . ((defun-open after)
				   (class-open after)
				   (class-close after)
				   (inline-open after)
				   (block-close . c-snug-do-while)
				   (substatement-open after)
				   (brace-list-open after)
				   (brace-list-close before)
				   (brace-list-intro after)
				   (brace-entry-open)
				   (extern-lang-open after)
				   (namespace-open after)
				   (module-open after)
				   (composition-open after)
				   (inexpr-class-open after)
				   (inexpr-class-close before)
				   (arglist-cont-nonempty)))
    (c-hanging-colons-alist     . ((access-label after)
				   (member-init-intro before)
				   (inher-intro after)))
    (c-cleanup-list             . (brace-else-brace
				   brace-elseif-brace
				   empty-defun-braces
				   defun-close-semi
				   scope-operator
				   compact-empty-funcall
				   comment-close-slash))
    ) "ASHBY C/C++ Programming Style")

(c-add-style "PERSONAL" ashby-c-style)

;; Customizations for all modes in CC Mode:
(defun ashby-c-mode-common-hook ()
  (c-set-style "PERSONAL")
  (setq tab-width 8
        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)
  ;; we like auto-newline, but not hungry-delete
  (c-toggle-auto-newline 1))

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
