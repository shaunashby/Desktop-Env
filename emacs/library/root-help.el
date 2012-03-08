;;; root-help.el --- Helper functions for ROOT 
;; -*- mode: emacs-lisp -*- 
;;
;; $Id: root-help.el,v 1.1 2005/08/19 16:30:01 sashby Exp $
;;
;;  Emacs lisp functions to help write ROOT based projects
;;  Copyright (C) 2002 Christian Holm Christensen 
;;
;;  This program is free software; you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation; either version 2 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program; if not, write to the Free Software
;;  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
;;
;; Author: Christian Holm Christensen <cholm@nbi.dk>
;; Maintainer: Christian Holm Christensen <cholm@nbi.dk>
;; Created: 20:34:51 Thursday 05/09/02 CEST
;; Version: 1.1
;; Keywords: oop programming
;; 
;;; Commentary:
;;
;;    The Emacs Lisp library `root-help.el' provides a number of
;;    function to easy the development of ROOT based classes and
;;    projects. 
;;
;;  Installation
;;   
;;    To use the Emacs Lisp library, download `root-help.el' and put
;;    it somewhere Emacs looks for Lisp libraries.  For people who
;;    have system operator privileges, the following directories are
;;    good candidates:
;;   
;;       /usr/share/emacs/site-lisp
;;       /usr/share/emacs/<version>/site-lisp
;;       /usr/local/share/emacs/site-lisp
;;       /usr/local/share/emacs/<version>/site-lisp
;;       /usr/lib/emacs/site-lisp
;;       /usr/lib/emacs/<version>/site-lisp
;;       /usr/local/lib/emacs/site-lisp
;;       /usr/local/lib/emacs/<version>/site-lisp
;;      
;;    where `<version>' is the version number of the Emacs you're
;;    using.
;;   
;;    For normal users, one should create the directory 
;;
;;       ${HOME}/share/emacs/site-lisp
;;   
;;    And add the line below to `~/.emacs':
;;   
;;       (setq load-path (cons "~/share/emacs/site-lisp" load-path))
;;   
;;    In any case, users that want to use the ROOT Emacs Lisp helper
;;    functions should add the line below to their `~/.emacs':
;;   
;;       (require 'root-help)
;;
;;    System operators may have some way of providing the library
;;    system wide.  For example on Debian systems, one can add the
;;    file `/etc/emacs/site-start.d/50root-help.el' with the contents
;;   
;;       (require 'root-help)
;;   
;;    and the library functions will be available system wide. See
;;    also your Emacs manual for more information.
;;   
;;  Functions
;;   
;;    All the functions in the library are invoked by typing 
;;   
;;       M-x <function>
;;   
;;    where `M-x' means "Meta key down and then `x'", where the Meta
;;    key is usually defined to `Alt' and `Esc', and `<function>' is
;;    the function to be invoked.
;;   
;;    No key-bindings have been setup per default, but this is easily
;;    done using the customisation support of Emacs.  Alternatively
;;    one can define key-bindings in ones `~/.emacs' file.  For
;;    example, one could bind the functions in C++ mode like this:
;;
;;       (defun root-c++-mode-hook ()
;;         "Hook for C++ mode - binding ROOT functions"
;;         (define-key c++-mode-map "\C-crc"  'root-class)
;;         (define-key c++-mode-map "\C-crh"  'root-header-skel)
;;         (define-key c++-mode-map "\C-crs"  'root-source-skel)
;;         (define-key c++-mode-map "\C-cri"  'root-include-header)
;;         (define-key c++-mode-map "\C-crm"  'root-main)
;;         (define-key c++-mode-map "\C-crl"  'root-insert-linkdef)
;;         (define-key c++-mode-map "\C-crp"  'root-insert-pragma)
;;         (define-key c++-mode-map "\C-crr"  'root-shell))
;;       (add-hook 'c++-mode-hook 'root-c++-mode-hook)
;;   
;;    root-class [NAME SCOPE INCDIR SRCDIR]  
;;     
;; 	Make two new files for a ROOT based class.  All arguments are
;; 	optional, and if not provided, the user will be prompted for
;; 	them.  `NAME' is the name of the class.  This can not be left
;; 	blank.  `SCOPE' the preprocessor scope for header guards, or
;; 	`ROOT' if left blank.  `INCDIR' is where the declaration file
;; 	will live, defaults to current directory.  `SRCDIR' is where
;; 	the definition file will live, defaults to current directory.
;;
;;    root-header-skel [SCOPE BASE DSCR] 
;;     
;; 	Insert a skeleton for a ROOT based class The class name is
;; 	derived from the current buffers file name, if possible,
;; 	otherwise the user is prompted for it.  All arguments are
;; 	optional.  If not specified, the user will be prompted for it.
;;
;; 	`SCOPE' is the preprocessor scope for header guards, and
;; 	`BASE' is the possible base class, and `DSCR' a short doc
;;      string 
;;
;;    root-source-skel [SCOPE DSCR]
;;     
;; 	Insert a skeleton for a ROOT based class The class name is
;; 	derived from the current buffers file name, if possible,
;; 	otherwise the user is prompted for it.  All arguments are
;; 	optional.  If not specified, the user will be prompted for it.
;;
;; 	`SCOPE' is the preprocessor scope for header guards, and DSCR
;;      a short description
;;
;;    root-include-header [HEADER SCOPE] 
;;     
;; 	Insert an `#include' statement with guards for a ROOT class
;;
;; 	`HEADER' is the name of the class to include a header for, and
;; 	`SCOPE' is the optional scope, which defaults to `ROOT'.  If
;; 	not given, `HEADER' is read from the minibuffer with
;; 	completion. The completion is based on the file names found in
;; 	`root-include-directory'.
;;        
;;    root-main
;;     
;; 	Insert a skeleton for a ROOT based program Two function will
;; 	be created - one which has the name of the current buffer with
;; 	out extensions, and which the user is to fill in, and a `main'
;; 	function that calls this function.  Like this, we can use the
;; 	file for both interactive input, due to use of guards, and as
;; 	a program.
;;
;; 	The user will be prompted for whether graphics is needed or
;; 	not.  If yes, then a `TApplication' object is created in the
;; 	`main' function.
;;
;;    root-insert-linkdef
;;     
;; 	Insert lines appropriate for a linkdef file into current
;; 	buffer
;;
;; 	The user will be prompted for classes to add to the linkdef
;; 	file.  An empty string ends the input.
;;
;;    root-insert-pragma [NAME NEED-PLUS] 
;;     
;; 	Insert a pragma linkdef line for a class All arguments are
;; 	optional.  If not given, the user will be prompted for them.
;; 	`NAME' is the name of class, and if `NEED-PLUS' is non-nil, an
;; 	`+' will be appended to the class name line.
;;
;;    root-shell
;;     
;; 	Start an interactive ROOT session in a buffer The executable
;; 	stored in `root-executable' is executed with the arguments
;; 	`root-executable-args'.  If Emacs is running in a non-graphics
;; 	terminal (like a VT100) `root-executable-args-nographics' is
;; 	passed to the executable
;;     
;;  Customisation
;;   
;;    The library depends on a number of variables that the user may
;;    customise using Emacs' regular customisation support.  All the
;;    customisation is in the sub-group `Root' of the group
;;    `Programming - Tools'
;;   
;;    root-include-directory
;;     
;; 	Where the ROOT headers reside.  If the `ROOTSYS' environment
;; 	variable is set, this defaults to `${ROOTSYS}/include',
;; 	otherwise to `/usr/include/root'
;;     
;;    root-executable
;;     
;; 	Full path to the ROOT interactive executable. If the `ROOTSYS'
;; 	environment variable is set, this defaults to
;; 	`${ROOTSYS}/bin/root', otherwise to `/usr/bin/root'
;;     
;;    root-executable-args
;;     
;; 	Arguments to pass to `root-executable'.  Per default this is
;; 	empty.
;;      
;;    root-executable-args-nographics
;;      
;; 	Arguments to pass to `root-executable' in case Emacs is
;; 	running in a non-graphics environment, like a VT100 terminal
;; 	or similar.  Per default this is set to `"-l -b"'
;;
;;____________________________________________________________________
;;
;;; Code:     

;;____________________________________________________________________
(require 'comint)

;;____________________________________________________________________
(defgroup root nil
  "ROOT's Object Oriented Technologies helper functions"
  :group 'programming
  :group 'tools)

;;____________________________________________________________________
(defcustom root-include-directory 
  (if (getenv "ROOTSYS") 
      (concat (getenv "ROOTSYS") "/include")
    "/afs/cern.ch/user/s/sashby/w1/work/LCG/ROOT/ROOT_3_0_5/include/root")
  "Where the ROOT headers reside"
  :group 'root)

;;____________________________________________________________________
(defcustom root-executable
  (if (getenv "ROOTSYS") 
      (concat (getenv "ROOTSYS") "/bin/root")
    "/afs/cern.ch/user/s/sashby/w1/work/LCG/ROOT/ROOT_3_0_5/bin/root")
  "Full path to the ROOT interactive executable"
  :group 'root)

;;____________________________________________________________________
(defcustom root-executable-args ""
  "Arguments passed to the \\[root-executable]"
  :group 'root)

;;____________________________________________________________________
(defcustom root-executable-args-nographics "-l -b"
  "Arguments passed to the \\[root-executable] in non-graphics environment"
  :group 'root)

;;____________________________________________________________________
(defun  root-class    (&optional name scope incdir srcdir) 
  "Make two new files for a ROOT based class. 

All arguments are optional, and if not provided, the user will be
prompted for them.  

NAME is the name of the class.  This can not be left blank.  SCOPE the
preprocessor scope for header guards, or 'ROOT' if left blank.  INCDIR 
is where the declaration file will live, defaults to current
directory.  SRCDIR is where the definition file will live, defaults
to current directory. 

Uses \\[root-header-skel] and \\[root-source-skel]" 
  (interactive)
  ;; Read the class name from the minibuffer is the user didn't supply
  ;; one 
  (while (or (not name) (string= name "")) 
    ;; If that's not possible prompt user for it
    (setq name (read-string "Class name: ")))
  ;; Get the preprocessor scope if not passed by user 
  (if (not scope) (setq scope (read-string "Scope: ")))
  ;; Figure out where to put the declaration file 
  (if (not incdir) 
      (setq incdir (read-string "Declaration directory (.): "))) 
  ;; Set default if user types C-j
  (if (eq (length incdir) 0) (setq incdir "."))
  ;; Figure out where to put the declaration file 
  (if (not srcdir) 
      (setq srcdir (read-string "Implementation directory (.): "))) 
  ;; Set default if user types C-j
  (if (eq (length srcdir) 0) (setq srcdir "."))
  ;; Make file names
  (let ((header-name) (source-name))
    (setq header-name (if (string= "." incdir) (concat name ".h") 
			(concat incdir "/" name ".h")))
    (setq source-name (if (string= "." srcdir) (concat name ".cxx") 
			(concat srcdir "/" name ".cxx"))) 
    ;; Check that files doesn't exist
    (if (file-exists-p header-name) 
	(error "Header file '%s' already exists - will not overwrite" 
	       header-name))
    (if (file-exists-p source-name) 
	(error "Source file '%s' already exists - will not overwrite" 
	       source-name))
    ;; Check files are writeable 
    (if (not (file-writable-p header-name)) 
	(error "Cannot write header file '%s'" header-name))
    (if (not (file-writable-p source-name)) 
	(error "Cannot write source file '%s'" source-name))
    ;; Open the header file and make that current buffer
    (find-file header-name) 
    (c++-mode)
    ;; Write the header skeleton
    (root-header-skel scope)
    ;; Save the file 
    (save-buffer)
    ;; Open the source file and make that current buffer
    (if (not (string= incdir "."))
	(find-file (concat "../" source-name))
      (find-file source-name))
    ;; Write the source skeleton
    (root-source-skel scope)
    ;; Save the file 
    (save-buffer)
    ;; Write a message to user
    (message "Class is in '%s' and '%s'" header-name source-name)))

;;____________________________________________________________________
(defun root-header-skel (&optional scope base dscr)
  "Insert a skeleton for a ROOT based class

The class name is derived from the current buffers file name, if
possible, otherwise the user is prompted for it.  All arguments are
optional.  If not specified, the user will be prompted for it.  

SCOPE is the preprocessor scope for header guards, BASE is the
possible base class, and DSCR is a short description of the class" 
  (interactive)
  (let (name)
    ;; Get the class name form the filename of the buffer 
    (setq name (file-name-sans-extension (buffer-name)))
    ;; If that failed, prompt the user for it
    (while (or (not name) (string= name "")) 
      ;; If that's not possible prompt user for it
      (setq name (read-string "Class name: ")))
    ;; If the scope isn't set, 
    (if (or (not scope) (string= "" scope)) (setq scope "ROOT"))
    ;; If the base file isn't set, prompt the user for it. 
    (if (or (not base) (string= "" base)) 
	(setq base (root-read-class "Base class: " "TObject")))
    ;; Get a description string 
    (if (or (not dscr) (string= dscr "")) 
	(setq base (root-read-class "Base class: " "DOCUMENT ME")))
    ;; Go to the top of the file
    (goto-char (point-min))
    (insert "// -*- mode: c++ -*- \n")
    (root-insert-header-info)
    (insert "#ifndef " scope "_" name "\n#define " scope "_" name "\n")  
    (if (and base (not (string= base ""))) (root-include-header base))
    (insert "\nclass " name)
    (if (and base (not (string= base ""))) (insert " : public " base))
    (insert "
{
private:
public:
  " name "();
  virtual ~" name "() {}

  ClassDef(" name ",0) //" dscr "
};

#endif
")
    (root-insert-bottom-info)
    (goto-char (point-min))))

;;____________________________________________________________________
(defun root-source-skel (&optional scope dscr)
  "Insert a skeleton for a ROOT based class

The class name is derived from the current buffers file name, if
possible, otherwise the user is prompted for it.  All arguments are 
optional.  If not specified, the user will be prompted for it.   

SCOPE is the preprocessor scope for header guards, and DSCR is a
description string."
  (interactive)  
  (let (name)
    ;; Get the class name form the filename of the buffer 
    (setq name (file-name-sans-extension (buffer-name)))
    ;; If that failed, prompt the user for it
    (while (or (not name) (string= name "")) 
      ;; If that's not possible prompt user for it
      (setq name (read-string "Class name: ")))
    ;; If the scope isn't set, 
    (if (or (not scope) (string= "" scope)) (setq scope "ROOT"))
    ;; Get a description string 
    (if (or (not dscr) (string= dscr "")) 
	(setq base (root-read-class "Base class: " "DOCUMENT ME")))
    (goto-char (point-min))
    ;; Insert a skeleton for the class description 
    (insert 
   "//____________________________________________________________________
//
// " dscr "
// 

")
  ;; Insert author, date, copyright information
    (root-insert-header-info)
    ;; Include the class declaration
    (root-include-header name scope)
    ;; Insert a dummy CTOR and class implementation macro 
    (insert "
//____________________________________________________________________
ClassImp(" name ");

//____________________________________________________________________
" name "::" name "()
{
  // Default constructor
}

")
    (root-insert-bottom-info)
    (goto-char (point-min))))

;;____________________________________________________________________
(defun root-insert-header-info () 
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

;;____________________________________________________________________
(defun root-insert-bottom-info () 
  "Inserts some lines for a footer"
  (insert 
"//____________________________________________________________________ 
//  
// EOF
//
"))

;;____________________________________________________________________
(defun root-include-header (&optional header scope) 
  "Insert an #include statement with guards for a ROOT class

HEADER is the name of the class to include a header for, and SCOPE is
the optional scope, which defauls to 'ROOT'.  If not given, HEADER is
read from the minibuffer _with_ completion.  The completion is based on
the file names found in \\[root-include-directory]"
  (interactive) 
  ;; Read the class name (with completion) from user if it isn't given
  ;; already 
  (if (not header) (setq header (root-read-class "Class name: " nil)))
  ;; If the scope ins't set, set it to ROOT 
  (if (or (not scope) (string= "" scope)) (setq scope "ROOT"))
  ;; Insert the lines we need 
  (insert "#ifndef " scope "_" header 
	  "\n#include \"" header ".h\"\n#endif\n"))

;;____________________________________________________________________
(defun root-main () 
  "Insert a skeleton for a ROOT based program

Two function will be created - one which has the name of the current
buffer with out extensions, and which the user is to fill in, and a
'main' function that calls this function.  Like this, we can use the
file for both interactive input, due to use of guards, and as a
program. 

The user will be prompted for wether graphics is needed or not.  If
yes, then a TApplication object is created in the main function."
  (interactive) 
  ;; 
  (let (name)
    (setq name (file-name-sans-extension (buffer-name)))
    (setq need-application (y-or-n-p "Do you need graphics "))
    (goto-char (point-min))
    (root-insert-header-info)
    (insert "//\n#ifndef __CINT__\n")
    (if need-application (root-include-header "TApplication"))
    (insert "// PUT HEADERS HERE
#endif

int " name "()
{
  // DEFINE YOUR MAIN FUNCTION HERE

  return 0;
}

#ifndef __CINT__
int main(int argc, char** argv)
{
  ")
    (if need-application  
	;; If we need an application, then we insert, that, store the
	;; return value of the function, run the application, and
	;; return the stored return value. 
	(insert "TApplication " name "App(\"" name "App\", &argc, argv);
  int retVal = " name "();
  " name "App.Run();
  return retVal;")
      ;; Otherwise we just insert the call 
      (insert "return " name "();"))
    ;; Closing brace
    (insert "\n}\n#endif\n\n")
    ;; Bottom of the file 
    (root-insert-bottom-info)
    (goto-char (point-min))))

;;____________________________________________________________________
(defun root-insert-linkdef () 
  "Insert lines appropiate for a linkdef file into current buffer

The user will be prompted for classes to add to the linkdef file.  An
empty string ends the input."
  (interactive)
  (insert "// -*- mode: c++ -*-\n")
  (root-insert-header-info)
  (insert "
#ifndef __CINT__
#error Not for compilation
#endif

#pragma link off all functions;
#pragma link off all globals;
#pragma link off all classes;

")
  ;; Let the user add classes right away 
  (while 
      (progn (setq name (read-string "Add a class: ")) 
	     (> (length name) 0))
    (root-insert-pragma name))
  ;; insert a new line and the end stuff
  (insert "\n")
  (root-insert-bottom-info)
  (goto-char (point-min)))

;;____________________________________________________________________
(defun root-insert-pragma (&optional name need-plus)
  "Insert a pramga linkdef line for a class

All arguments are optional.  If not given, the user will be prompted
for them.  NAME is the name of class, and if NEED-PLUS is non-nil, an
'+' will be appended to the class name line." 
  (interactive)
  ;; Read the class name 
  (while (or (not name) (string= name "")) 
    ;; If that's not possible prompt user for it
    (setq name (read-string "Class name: ")))
  ;; Check if we need a plus or not. 
  (if (not need-plus)  
      (setq need-plus (y-or-n-p "Do you schema evolution ")))
  ;; Insert the actual line 
  (insert "#pragma link C++ class " name)
  ;; insert the plus if we need it.
  (if need-plus (insert "+"))
  ;; and a final newline 
  (insert ";\n"))

;;____________________________________________________________________
(defun root-complete-class (name filter flag) 
  "Completition function for root-read-class.  

It looks up the passed name in the ROOT header directory set by
\\[root-include-directory], and does the matching on files there."
  (if flag 
      ;; Return a list of all possible completions 
      (let (files)
	(setq files 
	      (file-name-all-completions name root-include-directory))
	(if (not files) (error "no matches on '%s'" name))
      (mapcar 'file-name-sans-extension files))
    ;; Returns:
    ;; t if an exact match is found, 
    ;; nil if no possible match is found,  
    ;; completion if unique 
    ;; Longest possible completion if not
    (let (first) 
      (setq first (file-name-completion name root-include-directory))
      (if (and (stringp first) (string= first (concat name ".h"))) 
	  t
	(progn 
	  (if (stringp first)
	      (file-name-sans-extension first)))))))

;;____________________________________________________________________
(defun root-read-class (prompt default)
  "Interactively read the name of a ROOT class.  

Completion is done based  on the file names found in
\\[root-include-directory]" 
  (completing-read prompt 'root-complete-class nil nil default))

;;____________________________________________________________________
(defun sys-include-header (&optional header) 
  "Insert an #include for a system header" 
  (interactive) 
  (if (not header)
      (setq header (read-string "Header name: ")))
  (insert "#ifndef __" (upcase header) "__\n"
          "#include <" (symbol-value 'header) ">\n"
          "#endif\n"))

;;____________________________________________________________________
(defvar root-shell-mode-map nil
  "Major mode map for \\[root-shell-mode]")
(cond ((not root-shell-mode-map)
       (if (string-match "XEmacs\\|Lucid" emacs-version)
	   (let ((map (make-keymap)))
	     (set-keymap-parents map (list comint-mode-map))
	     (set-keymap-name map 'root-shell-mode-map)
	     (setq root-shell-mode-map map))
	 (setq root-shell-mode-map 
	     (nconc (make-sparse-keymap) comint-mode-map))))
      (define-key root-shell-mode-map "\t" 'root-insert-tab))

;;____________________________________________________________________
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

;;____________________________________________________________________
(defun root-insert-tab ()
  ""
  (interactive)
  (message "Tab completion not implmented"))

;;____________________________________________________________________
(defun root-shell-mode () 
  "Major mode for a ROOT interactive shell"
  (interactive)
  (comint-mode)
  (setq major-mode 'root-shell-mode)
  (setq mode-name "ROOT")
  (use-local-map root-shell-mode-map)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(root-shell-font-lock-keywords)))

;;____________________________________________________________________
(defun root-shell ()
  "Start an interactive ROOT session in a buffer

The executable stored in \\[root-executable] is executed with the 
arguments \\[root-executable-args].  If Emacs is running in a 
non-graphics terminal (like a VT100) \\[root-executable-args-nographics]
is passed to the executable" 
  (interactive)
  (if (not (comint-check-proc "*ROOT*"))
      (let* ((args) (root-shell-buffer))
	(setq args  (if (not window-system) 
			root-executable-args-nographics 
		      root-executable-args))
	(save-excursion
	  (set-buffer 
	   (if (or (not args) (string= args ""))
	       (make-comint "ROOT" root-executable)
	     (make-comint "ROOT" root-executable nil args))) 
	  (setq root-shell-buffer (current-buffer))
	  (root-shell-mode))
	(pop-to-buffer root-shell-buffer))
    (pop-to-buffer "*ROOT*")))

;;____________________________________________________________________
;; Identify this package	  
(provide 'root-help)

;;____________________________________________________________________
;;
;;; root-help.el ends here
;;
