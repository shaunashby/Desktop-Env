;;
;; cust-latex-mode.el
;;
;;
;;
;;
(defvar TeX-print-command (concat "dvips -f %s | " lpr-command " -P%p")
  "*Command used to print a file. 

First %p is expanded to the printer name, then ordinary expansion is
performed as specified in TeX-expand-list.")
;;
;; Default printer list
;;
(defvar TeX-printer-list
  '(("default" (concat "dvips -f %s | " lpr-command) (concat lpr-command " -q"))
    ("40_5b_08" (concat "dvips -f %s | " lpr-command " -P40_5b_08") (concat lpr-command " -q -P40_5b_08"))
    ("40_3b_cor" (concat "dvips -f %s | " lpr-command " -P40_3b_cor") (concat lpr-command " -q -P40_3b_cor"))
    ("513-lps" (concat "dvips -f %s | " lpr-command " -P513-lps") (concat lpr-command " -q -P513-lps")))
  "*List of available printers.

The first element of each entry is the printer name.

The second element is the command used to print to this
printer.  It defaults to the value of TeX-print-command.

The third element is the command used to examine the print queue for
this printer.  It defaults to the value of TeX-queue-command.

Any occurrence of `%p' in the second or third element is expanded to
the printer name given in the first element, then ordinary expansion
is performed as specified in TeX-expand-list.")

;; Functions:
(defun latex-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert 
   "%%____________________________________________________________________ 
%% File: " (buffer-name) "
%%____________________________________________________________________ 
%%  
%% Author: " (user-full-name)  " <" user-mail-address ">
%% Update: " (format-time-string "%Y-%m-%d %T%z") "
%% Revision: $Id" "$ 
%%
%% Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
%%
%%--------------------------------------------------------------------
"))

(defun latex-insert-file-footer () 
  (interactive)
  "Inserts a footer at end of file."
  (insert 
   "%%____________________________________________________________________ 
%% End of " (buffer-name) "
%%____________________________________________________________________ 
%%  
"))

(defun latex-start-doc ()
  (interactive)
  "Define a new document."
  (insert
   "\\documentclass[12pt,twoside]{report}\n"
   "\\begin{document}\n"
   "\n\n\n\n"
   "\\end{document}\n"
   ))
  
;; Hooks:
(add-hook 'LaTeX-mode-hook
	  (function (lambda ()
		      (auto-fill-mode 1)
		      ;; "\chapter{}" style:
		      (set-face-font 'font-latex-title-1-face "-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1")
		      (set-face-foreground 'font-latex-title-1-face "ivory")
		      (set-face-background 'font-latex-title-1-face "DodgerBlue4")
		      ;; "\section{}" style:
		      (set-face-font 'font-latex-title-2-face "-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1")
		      (set-face-foreground 'font-latex-title-2-face "ivory")
		      (set-face-background 'font-latex-title-2-face "DodgerBlue4")		      
		      ;; "\subsection{}" style:
		      (set-face-font 'font-latex-title-3-face "-adobe-helvetica-bold-o-normal--12-120-75-75-p-69-iso8859-1")
		      (set-face-foreground 'font-latex-title-3-face "ivory")
		      (set-face-background 'font-latex-title-3-face "DodgerBlue4")		     
		      ;; "\subsubsection{}" and "\paragraph{}" style:
		      (set-face-font 'font-latex-title-4-face "-adobe-helvetica-bold-o-normal--12-120-75-75-p-69-iso8859-1")
		      (set-face-foreground 'font-latex-title-4-face "DodgerBlue")
		      (set-face-background 'font-latex-title-4-face "black")
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (latex-insert-file-header)
			     (latex-start-doc)
			     (latex-insert-file-footer)
			     ))
		      )))
;;
(setq auto-mode-alist (cons '("\\.tex\\'" . latex-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.lyx\\'" . latex-mode) auto-mode-alist))

;;
;; End of cust-latex-mode.el
;;
