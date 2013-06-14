;;
;; cust-latex-mode.el
;;
;;
;;
;;

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
;; End of cust-latex-mode.el
;;
