;;
;; cust-emacs-lisp-mode.el
;;
;; Function to generate header and footer:
(defun insert-elisp-tmpl ( ) 
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
\n\n\n\n\n\n\n\n\n\n
;;
;; End of " (buffer-name) "
;;
") (goto-line 20))

;; Function template:
(defun elisp-fn-tmpl (&optional name info args)
(interactive)
"Inserts an Emacs lisp function template into current buffer."
(setq name (read-string "Function name: "))
(setq info (read-string "Description: "))
(setq args (read-string "Args: "))
(insert
"
(defun " (symbol-value 'name) " (&optional " (symbol-value 'args) ")
  (interactive)
  \"" (symbol-value 'info) "\"
  ;; Add as many of these as required to get the inputs from ARGS(" (symbol-value 'args) ") 
  (setq ARG (read-string \"text: \"))
  (insert
   \n\n
   )
)
"))

;; The mode hook:
(add-hook 'emacs-lisp-mode-hook
	  (function (lambda ()
		      (define-key emacs-lisp-mode-map "\C-cs" 'insert-elisp-tmpl)
		      (define-key emacs-lisp-mode-map "\C-ct" 'elisp-fn-tmpl)
		      )))
;;
;; End cust-emacs-lisp-mode.el
;;
