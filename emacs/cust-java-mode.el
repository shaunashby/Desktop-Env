;;
;; cust-java-mode.el
;;

;; Java keywords:
(setq cust-java-font-lock-keywords
      (list
       '("^class \\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
       '("\\(public\\|private\\|protected\\|package\\)" 1 'bold-LightSteelBlue2-face t)
       '("::" . 'Thistle2-face)
       '("\\<\\(catch\\|try\\|throw\\)" 1 'Plum2-face t)
       ))

(font-lock-add-keywords 'java-mode cust-java-font-lock-keywords)

;; Function to generate header:
(defun java-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert 
   "//____________________________________________________________________ 
// File: " (buffer-name) "
//____________________________________________________________________ 
//  
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$ 
//
// Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
//
//--------------------------------------------------------------------
"))

;; Insert class statement:
(defun insert-java-class (&optional classname)
  "Add a new Java class description and a main()"
  (interactive)
  (while (or (not classname) (string= classname ""))
    (setq classname (read-string "Class name: ")))
  (insert
   "\n"
   "class " classname " {\n"
   "   public static void main(String[] args) {\n"
   "\n"
   "   }\n"
   "} // End of " classname " definition\n\n"
   ))

;; To insert a new compile command:
(defun insert-java-compile-command (&optional compiler mname)
  (interactive)
  "Inserts a new compile-command block at end of a JAVA(tm) file."
  (if (not compiler)
      (setq compiler (read-string "Compiler name: ")))
  (if (not mname)
      (setq mname (read-string "Name of class main() function: ")))
  (if (eq (length compiler) 0) (setq compiler javadefault))
  (if (eq (length mname) 0) (setq mname (file-name-sans-extension (buffer-name))))
  (end-of-buffer)
  (insert
   "//\n"
   "//  Local variables:\n"
   "//  compile-command: \"" 
   (symbol-value 'compiler) " --main=" mname " -o " 
   (file-name-sans-extension (buffer-name)) " " (buffer-name) "\"\n"
   "//  End:\n"
   "//")
  (save-buffer))

;;
(add-hook 'java-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define java-menu java-mode-map "Java Menu"
			'("Insert"
			  ["Insert File Header" java-insert-file-header t]
			  "---"
			  ["Insert Java Class" insert-java-class t]
			  "---"
			  ["Insert Java Compile Command" insert-java-compile-command t]
			  ))
		      ;;
		      (define-key java-mode-map "\C-m" 'newline-and-indent)
		      (define-key java-mode-map "\C-cic" 'insert-java-class)
		      (define-key java-mode-map "\C-ccc" 'insert-java-compile-command)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (java-insert-file-header)
			     )))))
;;
(setq auto-mode-alist (append '(("\\.java\\'" . java-mode) 
				("\\.class\\'" . java-mode)
				)
			      auto-mode-alist))

;;
;; End of cust-java-mode.el
;;