This buffer is for notes you don't want to save, and for Lisp evaluation.
If you want to create a file, visit that file with C-x C-f,
then enter the text in that file's own buffer.


(setq subname "arse")
(insert "\n%" (format " %-40s" subname) (make-string 10?\-)
	"\n% Checkpoints:\n% abcdefghijklmnopqrstuvwxyz\n")





(message "The name of this buffer is %s." (buffer-name))


(defun frame-tan ()
"Create a new frame with background TAN and foreground IVORY."
(message "Creating new frame with background TAN4")
(make-frame '(
	      (background-color . "tan4") 
	      (foreground-color . "ivory")
	      ))
)



(defun frame-grey ()
"Create a new frame with background GREY15 and foreground IVORY."
(message "Creating new frame with background GREY15")
(make-frame '(
	      (background-color . "grey15") 
	      (foreground-color . "ivory")
	      ))
)


(defun frame-wheat2 ()
"Create a new frame with background WHEAT2 and foreground BLACK."
(message "Creating new frame with background WHEAT2")
(make-frame '(
	      (background-color . "wheat2") 
	      (foreground-color . "black")
	      ))
)


(defun frame-wheat3 ()
"Create a new frame with background WHEAT3 and foreground BLACK."
(message "Creating new frame with background GREY15")
(interactive)
(make-frame '(
	      (background-color . "wheat3") 
	      (foreground-color . "black")
	      ))
)

frame-wheat ()

(defun test ()
  "test"
  (frame-tan)
  (frame-grey)
  (frame-wheat2)
  (frame-wheat3))

(test)



(defun testinput (&optional class description)
  "Test function: get two settings from the command-line"
  (interactive)
  (setq class (read-string "Class name: "))
  (setq description (read-string "Class description: "))
  (insert " blah blah blah
//
//
//
//
      Class: " (class) " 
Description: " (description) "
//
// "))



testinput ()



(defun root-insert-header-info () 
  (interactive)
  "Inserts some lines for a header, including CVS Id, author, date copyright"
  (insert 
"//____________________________________________________________________ 
//  
// $Id" "$ 
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
//
"))


(root-insert-header-info)//____________________________________________________________________ 
//  
// $Id: elisp-practice-old.el,v 1.1 2005/08/19 09:57:16 sashby Exp $ 
// Author: Shaun Ashby <sashby@pcitapi38.cern.ch>
// Update: 2003-02-10 17:01:28+0100
// Copyright: 2003 (C) Shaun Ashby
//




root-insert-header-info ( )
//____________________________________________________________________ 
//  
// $Id: elisp-practice-old.el,v 1.1 2005/08/19 09:57:16 sashby Exp $ 
// Author: Shaun Ashby <sashby@pcitapi38.cern.ch>
// Update: 2003-02-10 16:58:47+0100
// Copyright: 2003 (C) Shaun Ashby
//



(insert "Blah balhblha...")





(testinput ("blah" "load of junk"))






(defun sys-include-header (&optional header hd2) 
  "Insert an #include for a system header" 
  (interactive)
  (setq header (read-string "Header name: "))
  (setq hd2 (read-string "Header2 name: "))
  (insert "#ifndef __" (upcase header) "__\n"
          "#include <" (symbol-value 'header) ">\n"
          "#endif\n")
  (insert "#ifndef __" (upcase hd2) "__\n"
          "#include <" (symbol-value 'hd2) ">\n"
          "#endif\n"))



(sys-include-header)#ifndef __JUNK__
#include <junk>
#endif
#ifndef __JUNK2__
#include <junk2>
#endif



// Description: junk stuff here....                                             //





(defun sfatest (&optional class desc) 
  "Do some stuff..." 
  (interactive)
  (setq class (read-string "Class name: "))
  (setq description (read-string "Description: "))
  (insert "#ifndef __" (upcase class) "__\n"
          "#include <" (class) ">\n"
          "#endif\n")
  (insert "#ifndef __" (upcase description) "__\n"
          "#include <" (description) ">\n"
          "#endif\n"))


(sfatest)


(setq mode-name "emacs-lisp")

(defvar root-shell-font-lock-keywords 
  '(("root \\[[0-9]+\\]"        . font-lock-warning-face)
    ("Root>"                    . font-lock-warning-face)
    ("end with '}'>"            . font-lock-warning-face)
    ("\"[^\"]*\""               . font-lock-string-face)
    ("[+-]?[0-9]+\\.?[0-9]*[eE][+-]?[0-9]+[lL]?" . font-lock-constant-face)
    ("[+-]?[0-9]*\\.[0-9][eE][+-]?[0-9]+[lL]?" . font-lock-constant-face)
    ("\\([+-]?[0-9]+\\.?[0-9]*\\|[+-]?[0-9]*\\.[0-9]\\)[lL]?" .
     font-lock-constant-face)
    ("\\(//.*\\|/\\*.*\\*/\\)" . font-lock-comment-face)
    ("\\.[^ \\t\\n]+" . font-lock-builtin-face)
    ("\\sw+\\s-*(" . font-lock-function-name-face)
    ("\\(\\sw+_t\\|T[A-Z]\\sw+\\|E[A-Z]\\sw+\\)" . font-lock-type-face)
    ("\\(if\\|else\\|for\\|while\\|do\\|switch\\)" 
     . font-lock-keyword-face)
    ("\\(typedef\\|typename\\|case\\|class\\|struct\\)"
     . font-lock-keyword-face)
    ("\\(new\\|delete\\|sizeof\\|const\\|static\\|mutable\\)" 
     . font-lock-keyword-face)
    ("\\(private\\|protected\\|public\\|volatile\\|register\\)" 
     . font-lock-keyword-face)
    ("\\(cout\\|cerr\\|cin\\|endl\\|flush\\|setw\\setprecision\\)"
     . font-lock-variable-name-face)
    ("\\(gROOT\\|gStyle\\|gApplication\\|gPad\\)"
     . font-lock-variable-name-face)
    ("\\(char\\|int\\|float\\|double\\|short\\|long\\|unsigned\\)"
     . font-lock-type-face)
    ("\\(map\\|vector\\|list\\|iterator\\|exception[oi]+[f]?stream\\)"
     . font-lock-type-face)
    )
  "Additional expressions to highlight in ROOT intaractive mode.")



(setq mode-name "root-mode")



(load-path)

(setq junk (cons "~/emacs" load-path))

(insert (junk))

(getenv "LPDEST")
(setq lpr-switches '((concat "-P" (getenv "LPDEST"))))



(concat "xprint -P" (getenv "LPDEST"))


(insert (load-path))


(set-mouse-color "white")


