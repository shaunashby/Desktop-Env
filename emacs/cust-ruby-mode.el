;;____________________________________________________________________ 
;; File: cust-ruby-mode.el
;;____________________________________________________________________ 
;;  
;; Author: Shaun Ashby <Shaun.Ashby@cern.ch>
;; Update: 2006-01-06 16:20:10+0100
;; Revision: $Id$ 
;;
;; Copyright: 2006 (C) Shaun Ashby
;;
;;--------------------------------------------------------------------

;; To make scripts executable automatically:
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; Completions:
(require 'ruby-electric)

;; Function to generate script header:
(defun ruby-script-header (&optional args) 
  (interactive)
  "Inserts some info, including CVS Id, author, date and copyright."
  (setq args (read-string "Args to pass to Ruby: "))
  (insert "#!/usr/bin/ruby " (symbol-value 'args) "\n")
  (ruby-simple-header)
  )

(defun ruby-simple-header () 
  (interactive)
  "Inserts some info, including CVS Id, author, date and copyright."
  (insert "#____________________________________________________________________ 
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
"))

;;
(add-hook 'ruby-mode-hook
	  (function (lambda()
		      ;;
;;		      (font-lock-mode t)
;;		      (ruby-electric-mode t)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     ;; A simple script header:
			     (ruby-script-header)
			     )))))

(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))

;; Turn on syntax highlighting
;;(add-hook 'ruby-mode-hook 'turn-on-font-lock)

;;
;; End of cust-ruby-mode.el
;;
