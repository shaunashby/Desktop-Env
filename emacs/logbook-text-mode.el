;;____________________________________________________________________ 
;; File: logbook-text-mode.el
;;____________________________________________________________________ 
;;  
;; Author: Shaun Ashby <Shaun.Ashby@cern.ch>
;; Update: 2005-11-24 13:45:42+0100
;; Revision: $Id$ 
;;
;; Copyright: 2005 (C) Shaun Ashby
;;
;;--------------------------------------------------------------------

;; Functions for logging (logbooks):
(defun add-log-entry (&optional subject)
  "Shortcut for adding Time/Date stamped entry to log file"
  (interactive)
  (setq subject (read-string "Subject (if any): "))
  (insert-string
   (concat (make-string 75 ?- ) "\n"
	   (format "Date   : %-64s \n" (current-time-string))
	   (make-string 75 ?- ) "\n"
           "Subject: " (symbol-value 'subject) "\n"
	   (make-string 75 ?- ) "\n"
	   )))

;; Single entry:
(defun log-entry ()
  "Insert an entry in my logbook."
  (interactive)
  (insert "--" (format-time-string " %Y/%m/%d %T%z") "\n\n\n\n----")
  (search-backward-regexp "-- ")
  (beginning-of-line 3)
  (indent-to-column 3)
  )

;; Keywords for font-lock:
(setq cust-text-mode-keywords
      (list
       '("\\<\\([dD]ate   \\):" 1 'Plum-face t)
       '("\\<[dD]ate   :\\(.*\\)[ ]*$" 1 'bold-Tan2-face t)
       '("\\(--\\)" 1 'bold-italic t)
       '("-- \\(.*\\)$" 1 'bold-GreenYellow-face t)
       '("\\<\\([sS]ubject\\)" 1 'SkyBlue-face t)
       '("\\<\\(Received\\):" 1 'Red-face t)
       '("\\<\\(From\\):" 1 'secondary-selection t)
       '("\\<\\(To\\):" 1 'Red-face t)
       '("\\<\\(Return-Path\\):" 1 'Red2-face t)
       '("\\<\\(OK\\)" 1 'Yellow-face t)
))

;; Regexps for menus:
(defvar text-imenu-generic-expression
  '(
    ("Date" "[dD]ate   :\\([A-Za-z ]*[0-9 ]*[0-9]*:[0-9]*:[0-9]*[ ][0-9][0-9][0-9][0-9]\\)[ ]*$" 1 )
    ("Time" "-- \\(.*\\)$" 1 )
    ("Subject" "[sS]ubject: \\(.*\\)$" 1 )
    )
  "Imenu generic expression for LogBook-style text mode.")

;; Add extra keywords:
(font-lock-add-keywords 'text-mode cust-text-mode-keywords)

;; The hook:
(add-hook 'text-mode-hook
	  (function (lambda ()
		      (define-key text-mode-map "\C-cs" 'add-log-entry)
		      (define-key text-mode-map "\C-cl" 'log-entry)
		      (define-key text-mode-map "\C-ci" 'imenu-add-menubar-index)
		      (font-lock-mode t)
		      (make-local-variable 'imenu-generic-expression)
		      (setq imenu-generic-expression text-imenu-generic-expression)
		      (setq imenu-case-fold-search nil)
		      (setq tmname "QuickSearch")
		      (imenu-add-to-menubar 'tmname)
		      (auto-fill-mode t)
		      )))

(setq auto-mode-alist (cons '("\\.logbook\\'" . text-mode) auto-mode-alist))

;;
;; End of logbook-text-mode.el
;;
