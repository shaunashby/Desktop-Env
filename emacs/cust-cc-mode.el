;;
;; cust-cc-mode.el
;;

;; Load functions needed by c and cc modes:
(load-library "cust-cc-mode-funcs")
(load-library "cust-cc-mode-faces")

;; C++:
(font-lock-add-keywords
 'c++-mode
 '(("\\<FIXME:\\>" 0 'Orange-face t)
   ("^class \\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
   ("^class \\([a-zA-Z0-9]*\\):" 1 'bold-italic t)
   ("  class \\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
   ("  class \\([a-zA-Z0-9]*\\):" 1 'bold-italic t)
   ("\\(^public\\|^private\\|^protected\\):" 1 'bold-LightSteelBlue2-face t)
   ("\\(  public\\|  private\\|  protected\\):" 1 'bold-LightSteelBlue2-face t)
   ("::" . 'Thistle2-face)
   ("\\<\\(struct\\|union\\|enum\\|virtual[ \t]\\)" 1 'GreenYellow-face)
   ("\\<\\(catch \\|try \\|throw\\)" 1 'Plum2-face t)
   ("\\<\\(case\\|goto\\)" 1 'SkyBlue-face t)
   ("\\<\\(friend\\|inline\\)" 1 'Sienna2-face t)
   ("\\<\\(include\\)" 1 'Brown-face t)
   ))

;;
(setq
 c-tab-always-indent            nil
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
  ;;  (c-add-style "ashby" ashby-c-style t)
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
