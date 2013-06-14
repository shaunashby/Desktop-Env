;;
;; cust-emacs-lisp-mode.el
;;

;; Function to generate header and footer:
(defun insert-elisp-header ( ) 
  (interactive)
  "Inserts some info, including VCS info, author, date and copyright."
  (insert 
";;____________________________________________________________________ 
;; File: " (buffer-name) "
;;____________________________________________________________________ 
;;  
;; Author: " (user-full-name)  " <" user-mail-address ">
;; Update: " (format-time-string "%Y-%m-%d %T%z") "
;; Revision: $Id" "$ 
;;
;; Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
;;
;;--------------------------------------------------------------------
"
))

;; The mode hook:
(add-hook 'emacs-lisp-mode-hook
	  (function (lambda ()
		      (define-key emacs-lisp-mode-map "\C-cs" 'insert-elisp-header)
		      )))
;;
;; End cust-emacs-lisp-mode.el
;;
