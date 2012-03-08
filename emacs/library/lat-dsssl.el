;;; lat-dsssl.el --- Lassi's DSSSL mode preferences.

;; Set up DSSSL indentation.
(put 'element 'scheme-indent-function 1)
(put 'style 'scheme-indent-function 1)
(put 'root 'scheme-indent-function 1)
(put 'make 'scheme-indent-function 1)
(put 'with-mode 'scheme-indent-function 1)
(put 'mode 'scheme-indent-function 1)

;; Make font-lock recognise more DSSSL keywords.
;(if window-system
;    (progn
;      (setq lisp-font-lock-keywords lisp-font-lock-keywords-2)
;      (setq scheme-font-lock-keywords
;	    (cons '("(\\(make\\|element\\|style\\|mode\\|root\\|with-mode\\)[\t\n]\\([0-9a-z.-]+\\|([^)]+)\\)"
;		    (1 font-lock-keyword-face)
;		    (2 font-lock-function-name-face))
;		  scheme-font-lock-keywords))))
