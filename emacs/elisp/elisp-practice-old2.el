This buffer is for notes you don't want to save, and for Lisp evaluation.
If you want to create a file, visit that file with C-x C-f,
then enter the text in that file's own buffer.


(insert (make-string 75 ?=))
===========================================================================//
// File: Particle.cc                                                         //
//                                                                           //
// Created:   Mon Feb 24 13:05:38 2003                                       //
// Author:    Shaun Ashby                                                    //
// Revision:                                                                 //
//                                                                           //
// Description:                                                              //
//                                                                           //
//===========================================================================//




(defun c++-insert-header-info () 
  (interactive)
  "Inserts some lines for a header, including CVS Id, author, date copyright"
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
"))


(c++-insert-header-info)
//____________________________________________________________________ 
// elisp-practice.el
//____________________________________________________________________ 
//  
// Author: Shaun Ashby <Shaun.Ashby@cern.ch>
// Update: 2003-02-28 16:35:36+0100
// Revision: $Id: elisp-practice-old2.el,v 1.1 2005/08/19 09:57:16 sashby Exp $ 
//
// Copyright: 2003 (C) Shaun Ashby
//








//--------------------------------------------------------------------
// 
//____________________________________________________________________ 
//  
// Author: Shaun Ashby <Shaun.Ashby@cern.ch>
// Update: 2003-02-28 16:33:57+0100
// Revision: $Id: elisp-practice-old2.el,v 1.1 2005/08/19 09:57:16 sashby Exp $ 
//
// Copyright: 2003 (C) Shaun Ashby
//




//____________________________________________________________________ 
//  
// Author: Shaun Ashby <Shaun.Ashby@cern.ch>
// Update: 2003-02-26 15:38:28+0100
// Revision: $Id: elisp-practice-old2.el,v 1.1 2005/08/19 09:57:16 sashby Exp $ 
//
// Copyright: 2003 (C) Shaun Ashby
//


(defun tb-tool-entry (&optional name version url)
  "Insert an entry in a SCRAM toolbox configuration file."
  (interactive)
  (setq name (read-string "Tool name: "))
  (setq version (read-string "Tool version: "))
  (setq url (read-string "URL (path to tool from toolbox directory): "))
  (insert "<require name=" (symbol-value 'name) " version=" (symbol-value 'version) " url=\"cvs:\?module=SCRAMToolBox/" (symbol-value 'url) "/" (symbol-value 'name) "\">"))

(defun sfatest (&optional class desc) 
  "Do some stuff..." 
  (interactive)
  (setq class (read-string "Class name: "))
  (setq desc (read-string "Description: "))
  (insert "#ifndef __" (upcase class) "__\n"
          "#include <" (class) ">\n"
          "#endif\n")
  (insert "#ifndef __" (upcase desc) "__\n"
          "#include <" (desc) ">\n"
          "#endif\n"))

(sfatest)

//____________________________________________________________________ 
//  
// Author: Shaun Ashby <Shaun.Ashby@cern.ch>
// Update: 2003-02-26 13:21:30+0100
// $Id: elisp-practice-old2.el,v 1.1 2005/08/19 09:57:16 sashby Exp $ 
//
// Copyright: 2003 (C) Shaun Ashby
//



(defun insert-tool-template (&optional name version url libname)
  "Add a template for a new tool file."
  (interactive)
  (setq name (read-string "Tool name: "))
  (setq version (read-string "Tool version: "))
  (setq url (read-string "URL (location of useful info for this tool): "))
  (setq libname (read-string "Name of library: "))
  (insert "<doc type=BuildSystem::ToolDoc version=1.0>\n"
	  "<Tool name=" (symbol-value 'name) " version=" (symbol-value 'version) ">\n"
	  "<info url=http://" (symbol-value 'url) "> Site for useful " (symbol-value 'name) " info</info>\n"
	  "<Lib name=" (symbol-value 'libname) ">\n"
	  "<Client>\n"
	  "<Environment name=" (concat (upcase name) "_BASE") ">\n"
	  "</Environment>\n"
	  "<Environment name=BINDIR default=$" (concat (upcase name) "_BASE/bin" ) ">\n"
          "</Environment>\n"
	  "<Environment name=LIBDIR default=$" (concat (upcase name) "_BASE/lib" ) " type=lib>\n"
          "</Environment>\n"
	  "<Environment name=INCLUDE default=$" (concat (upcase name) "_BASE/include" ) ">\n"
          "</Environment>\n"
	  "</Client>\n"
	  "<Environment name=PATH value=$BINDIR type=Runtime_path>\n"
	  "</Environment>\n"
	  "<Environment name=LD_LIBRARY_PATH value=$LIBDIR type=Runtime_path>\n"
	  "</Environment>\n"
	  "</Tool>\n"
	  ))


(insert-tool-template)<doc type=BuildSystem::ToolDoc version=1.0>
<Tool name=Boost version=Boost_1_2_9>
<info url=http://boostsite.org/boost/1.2.9/Welcome.htm> Site for useful Boost info</info>
<Lib name=boostthread>
<Client>
<Environment name=Boost_BASE>
</Environment>
<Environment name=BINDIR default=$BOOST_BASE/bin>
</Environment>
<Environment name=LIBDIR default=$BOOST_BASE/lib type=lib>
</Environment>
<Environment name=INCLUDE default=$BOOST_BASE/include>
</Environment>
</Client>
<Environment name=PATH value=$BINDIR type=Runtime_path>
</Environment>
<Environment name=LD_LIBRARY_PATH value=$LIBDIR type=Runtime_path>
</Environment>
</Tool>


(defun frame-tan ()
  "Create a new frame with background TAN and foreground IVORY."
  (interactive)
  (message "Creating new frame with background TAN4")
  (make-frame '(
		(background-color . "tan4") 
		(foreground-color . "ivory")
		(mouse-color . "green")
		))

  )


(frame-tan)

(defun frame-wheat2 ()
  "Create a new frame with background WHEAT2 and foreground BLACK."
  (interactive)
  (message "Creating new frame with background WHEAT2")
  (make-frame '(
		(background-color . "wheat2") 
		(foreground-color . "black")
		(mouse-color . "dark blue")
		))
  )


(frame-wheat2)


(defun new-perl-package (&optional name)
"Insert a template for a new Perl package"
(interactive)
(setq name (read-string "Package name: "))
(insert "\n\n" 
	"package " (symbol-value 'name)
	"require 5.004;"
	"\n\n"
	"use Utilities::Verbose;"
	"use Utilities::SCRAMUtils;"
	"\n"
	"@ISA=qw(XX::XX);\n"
	))


(new-perl-package)

package arserequire 5.004;

use Utilities::Verbose;use Utilities::SCRAMUtils;
@ISA=qw(XX::XX);



(defun new-perl-package (&optional name)
"Insert a template for a new Perl package"
(interactive)
(setq name (read-string "Package name: "))
(insert "\n\n" 
	"package " (symbol-value 'name) ";\n"
	"require 5.004;"
	"\n\n"
	"use XX::YY;"
	"use ZZ::AA;"
	"\n"
	"@ISA=qw(XX::YY);\n"
	"\n\n\n\n\n\n"
	"sub new {"
	"my $class=shift;"
	"my $self={};"
	"bless $self,$class;"
	"$self->{}=shift;"
	"return $self;"
	"}"
	"\n\n\n\n\n\n"
	"1;"
	))


;; Perl subroutine header block:
(defun insert-sub-header (subname)
  "Add a comment header block to a subroutine"
  (interactive "sSubroutine name: ")
  (insert "\n   " (make-string 63 ?# )
	  "\n   #"(format " %-40s" subname) (make-string 20? ) "#"
	  "\n   " (make-string 63 ?# )
	  "\n   # modified : " (format "%-24s" (current-time-string)) " / SFA " (make-string 18? ) "#"
	  "\n   # params   : " (make-string 49? ) "#\n   #          : " (make-string 49? ) "#" 
	  "\n   #          : " (make-string 49? ) "#\n   #          : " (make-string 49? ) "#"
	  "\n   # function : " (make-string 49? ) "#\n   #          : " (make-string 49? ) "#" 
	  "\n   #          : " (make-string 49? ) "#\n   #          : " (make-string 49? ) "#" 
	  "\n   " (make-string 63 ?# )"\n\n" ))

;; Perl package template:
(defun new-perl-package (&optional pkgname constructor)
"Insert a template for a new Perl package."
(interactive)
(setq pkgname (read-string "Package name: "))
(setq constructor (read-string "Constructor name (usually \"new\"): "))
(insert "\n\n"
	"package " (symbol-value 'pkgname) ";\n"
	"require 5.004;"
	"\n\n"
	"use XX::YY;\n"
	"use ZZ::AA;\n"
	"\n"
	"@ISA=qw(XX::YY);\n"
	"\n\n\n\n\n\n"
 	"sub " (symbol-value 'constructor) "\n"
	"  {\n"
 	"  " (make-string 63 ?# ) "\n"
 	"  #"(format " %-40s" (symbol-value 'constructor)) (make-string 20 ? ) "#\n"
 	"  " (make-string 63 ?# ) "\n"
 	"  # modified : " (format "%-24s" (current-time-string)) " / SFA " (make-string 18 ? ) "#\n"
 	"  # params   : " (make-string 49 ? ) "#\n"
 	"  #          : " (make-string 49 ? ) "#\n"
 	"  # function : " (make-string 49 ? ) "#\n"
 	"  #          : " (make-string 49 ? ) "#\n"
 	"  " (make-string 63 ?# ) "\n\n"
	"  my $class=shift;\n"
	"  my $self={};\n"
	"  bless $self,$class;\n"
	"  $self->{}=shift;\n"
	"  return $self;\n"
	"  }\n"
	"\n\n\n\n\n\n"
	"1;"
	))


(new-perl-package)




(defun insert-class (&optional classname)
  "Add a new class description"
  (interactive)
  (setq classname (read-string "Class name: "))
  (insert 
   "\n#ifndef " (format "%-20s" (concat (upcase classname) "_H"))
   "\n#define " (format "%-20s" (concat (upcase classname) "_H"))
   "\n"
   "\n// Define a new class:"
   "\nclass " (format "%-20s" classname)
   "\n{"
   "\npublic:                          // Public parts"
   "\n" (format "   %-30s" (concat classname "();")) "// Default constructor"
   "\n" (format "   %-30s" (concat "~" classname "();")) "// Default destructor"
   "\n\n   // Public methods"
   "\n\n\n\n"
   "\nprivate:                         // Private parts"
   "\n\n\n\n"
   "\nprotected:                       // Protected parts"
   "\n\n"
   "\n};"
   "\n\n#endif\n"
   ))



(insert-class)


(defun log-entry ()
"Insert an entry in my logbook."
(interactive)
(insert "--" (format-time-string " %Y/%m/%d %T%z") "\n\n\n\n----")
(search-backward-regexp "-- ")
(beginning-of-line 3)
(indent-to-column 3)
)




(defun add-log-entry ()
  "Shortcut for adding Time/Date stamped entry to log file"
  (interactive)
  (log-entry)
)



(add-log-entry)
-- 2003/02/27 17:43:57+0100

   

----






  (insert-string
   (concat (make-string 75 ?- ) "\n"
	   (format "Date   : %-64s \n" (current-time-string))
	   (make-string 75 ?- ) "\n"
           "Subject: \n"
	   (make-string 75 ?- ) "\n"
           "Comment: \n"        "\n"
	   (make-string 75 ?- ) "\n"
	   )))



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
    (insert "A test string...\n")
    ;; Save the file 
    (save-buffer)
    ;; Open the source file and make that current buffer
    (if (not (string= incdir "."))
	(find-file (concat "../" source-name))
      (find-file source-name))
    ;; Write the source skeleton
    (insert "Another test string...\n")
    ;; Save the file 
    (save-buffer)
    ;; Write a message to user
    (message "Class is in '%s' and '%s'" header-name source-name)))



(root-class)

(find-file "junk.h")


(log-entry)
-- 2003/02/27 17:39:26+0100



----





(defun insert-elisp-tmpl ( ) 
  (interactive)
  "Inserts some info, including CVS Id, author, date and copyright."
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
")
(goto-line 10))


(set (make-local-variable 'compile-command)
			       (concat "gcc -o "
				       (substring
					(file-name-nondirectory buffer-file-name)
					0
					(string-match
					 "\\.el$"
					 (file-name-nondirectory buffer-file-name)))
				       " "
				       (file-name-nondirectory buffer-file-name)))


;;;;;;;;;;;
(if (string-match "\\.el$" (file-name-nondirectory buffer-file-name))   
    (cond ((not (file-exists-p (buffer-file-name))) 
	   (message "File does not exist: ")))
(message "File exists: "))





;;;;;;;;;;;;;;;

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
"
))


(elisp-fn-tmpl)
(defun my-elisp-fn (&optional in anin)
  (interactive)
  "A test function."
  ;; Add as many of these as required to get the inputs from ARGS(in anin) 
  (setq ARG (read-string "text: "))
  (insert
   


   )
)



;; Functions for inserts attached to menu:
(defun perl-ins-while (r &optional f cond)
  (interactive "P")
  "Insert a new perl WHILE loop."
  (if (r (y-or-n-p "Read from filehandle?: "))
      (message "OK"))
  )



(defun perl-ins-do (&optional)
  (interactive)
  "Insert a new perl DO loop. "
  (insert 
   "
# Match on line then extract matching part, storing in VAR:
/^(.*)/ && do {($VAR) = ($_ =~ /^(.*)/);};
"))






(defun perl-printf (&optional handle string vars)
  (interactive)
  "Insert a formatted perl print statement."
  (setq handle (read-string "Print to filehandle: "))
  (setq string (read-string "Formatted string: "))
  (setq vars (read-string "Variables to print: "))
  (insert 
   "printf " (symbol-value 'handle) " (\"" (symbol-value 'string) "\\n\"," (symbol-value 'vars) ");"
   ))

(perl-printf)
printf fh ("this is a %s string\n",$junk);

printf fh ("this is a %s string\n");

(defun perl-ins-subroutine ()
  (interactive)
  "Insert a new perl subroutine."
(insert
"ARSE"
))


(defun perl-ins-subroutine(&optional subname)
  (interactive)
  "Insert a subroutine template at point."
  (setq subname (read-string "Subroutine name: "))
  (insert 
"
\n
sub " (symbol-value 'subname)
"\n   " (make-string 63 ?# )
"\n   #"(format " %-40s" (symbol-value 'subname)) (make-string 20 ? ) "#"
"\n   " (make-string 63 ?# )
"\n   # modified : " (format "%-24s" (current-time-string)) " / SFA " (make-string 18 ? ) "#"
"\n   # params   : " (make-string 49 ? ) "#"
"\n   #          : " (make-string 49 ? ) "#"
"\n   # function : " (make-string 49 ? ) "#"
"\n   #          : " (make-string 49 ? ) "#"
"\n   " (make-string 63 ?# ) "\n"
"   {

   }
"))


(pop-to-buffer "*scratch*")







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun munge-text ()
  (interactive)
  (shell-command-on-region (region-beginning)
                           (region-end)
                           "sed -e 's@a@X@g'"
                           current-prefix-arg
                           current-prefix-arg))


aaaaaaaaaaaaaaaaaaaaaaaaaaa

(munge-text)

(global-set-key [f5] 'munge-text)





(defun run-blah-command-on-region-display-other-window (begin end)
  "Run the hardcoded \"my_command\" on the region, display in other window."
  (interactive "r") ; automatically gets the start and end of the region for you
  (let* 
      ( (my_command "sort")  ; the hardcoded command
        (region-text (buffer-substring begin end))
        (run-command-temp-file 
         (make-temp-name        ; the pre-Gnu emacs 21 compatible method 
          (expand-file-name "run-command-on-region-display-other-window"
                            temporary-file-directory)))
        (original-buffer (current-buffer)))

    ; stash copy of region in temp file
    (find-file run-command-temp-file)
    (insert region-text)
    (basic-save-buffer)
    (kill-buffer (current-buffer))
    
    ; frame should display only original current buffer and the new output window
    (switch-to-buffer original-buffer)
    (delete-other-windows)
    (split-window-vertically)
    (other-window 1)
    (switch-to-buffer "*output my_command*")

    ; blank out any old stuff in the output buffer
    (mark-whole-buffer)
    (delete-region (mark) (point))

    (insert 
     (shell-command-to-string 
      (concat my_command " " (shell-quote-argument run-command-temp-file))
      ))

    ; clean-up
    (set-mark-command (point)) ; want to deactivate region
    (other-window 1)
    (delete-file run-command-temp-file)
    ))



My presumption was that you wanted a hardcoded command, 
so you'll have to change "sort" in 
  (my_command "sort") 
to the name of your perl script.

If you want a general function that'll prompt you for what
command to run, you'd just need to change the lines near the
top to something like this:

(defun run-shell-command-on-region-display-other-window (begin end my_command)
  "prompt for a shell command to run on the region, display in other window"
  (interactive "rsenter the name of the command to run on the region: ") 
  (let* 
      ( ;;; COMMENTING OUT PRIOR TO DELETE: (my_command "sort")  ; the hardcoded command
        (region-text (buffer-substring begin end))


Note: this passes the info through a temp file.  I did it
that way because it struck me as being fairly robust, and I
didn't feel like re-searching the shell programming methods
of piping in big chunks of data on the command line.  If you
felt like getting that working, you could probably simplfy
things quite a bit... if you try it don't forget to run the
shell-quote-argument function on the data.


;;
;;
;; http://www.phpexpert.org/forum
;;






;;; How can I run a program from emacs? ;;;;;
(setq cmdvar "~/scripts/ProcessInput")

(call-process cmdvar nil "bar" t)

(call-process-region 1 6 cmdvar nil t)


(call-process "grep" nil "bar" nil "ashby" "/etc/passwd")




(defun bfprocess (&optional d)
  (interactive)
  ;; Replace with group name:
  (while (re-search-forward ".*?ifdef GROUP_\\(.*\\)" nil t)
    (replace-match "<define_group name=\\1>" nil nil))
  (goto-line 1)
  ;; Replace all other closing tags with nothing:
  (while (re-search-forward "</lib>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  (while (re-search-forward "</external>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  (while (re-search-forward "</group>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  (while (re-search-forward "</use>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  ;; Close the group definition:
  (while (re-search-forward ".?[e][n][d][i][f].?" nil t)
    (replace-match "</define_group>" nil nil))
  (goto-line 1)
  )


(if (getenv "HOME")
    (concat "Jabber set"))

(defun cms-file-directory (&optional filename)
  "*Return the directory part of the FILENAME with links chased."
  (setq filename (or (and filename (file-name-directory
				    (file-chase-links filename)))
		     default-directory))
  (if (not (file-directory-p filename))
      (file-name-directory filename)
    filename))

(setq dirx "/home/sashby/work/Projects/CMS/CMSSW_0_0_1_pre3/src/SDCatalog/include")

cms-file-directory "test.h"
(setq path (concat (getenv "HOME") "/w1/Programming/emacs-lisp"))
(load-library (concat path "/cms-utils.el"))



(let ((home (getenv "HOME"))
      (basedir (getenv "LOCALRT"))
      (currentdir (getenv "PWD"))
      )
  
(or home (error "No LOCALRT set!"))
(setenv "TMPSFA" "\\")      
)

(defun cms-first-match (name pos &rest patterns)
  "*Find the first match in NAME starting at POS with PATTERNS.
Returns the index of the first matching position or nil if none
of PATTERNS matched."
  (save-excursion
    (setq case-fold-search nil)
    (let* ((start (string-match (car patterns) name pos))
	   (rest  (cdr patterns))
	   (min   start))
      (while rest
	(setq start (string-match (car rest) name pos))
	(setq rest  (cdr rest))
	(setq min   (cond ((not start)   min)
			  ((not min)     start)
			  ((> min start) start)
			  (t             min))))
      min)))

(defun cms-underscore-name (name)
  "*Insert underscores in NAME in word intervals."
  (let ((result "") (pos 0) (start nil))
    (while (setq start
		 (cms-first-match name pos
				  "\\([A-Z]\\)\\([A-Z0-9][a-z]\\)"
				  "\\([A-Z]\\)\\([A-Z][a-z]\\)"
				  "\\([0-9]\\)\\([A-Z][a-z]\\)"
				  "\\([a-z]\\)\\([0-9][A-Z]\\)"
				  "\\([a-z]\\)\\([A-Z]\\)"))
      (setq result (concat result (substring name pos (match-end 1)) "_"))
      (setq pos    (match-beginning 2)))
    (concat result (substring name pos))))

(defun cms-search-file-engine (indicator directory)
  "*Search for INDICATOR starting from DIRECTORY and return the cons pair
of the directory where found and the relative path for the subdirectory."
  (let ((dir directory) (subdir "") parent-dir)
    (while (and (not (file-exists-p (expand-file-name indicator dir)))
		(progn (setq parent-dir
			     (file-name-directory
			      (directory-file-name
			       (file-name-directory dir))))
		       ;; Give up if we are already at the root dir.
		       (not (string= dir parent-dir))))
      ;; Move up to the parent dir and try again
      (setq subdir (concat (file-name-as-directory
			    (file-name-nondirectory
			     (directory-file-name
			      (file-name-directory dir))))
			   subdir))
      (setq dir parent-dir))

    ;; If we found the indicator, use the directory, otherwise original.
    (if (file-exists-p (expand-file-name indicator dir))
	(cons dir subdir)
      (cons directory nil))))

cms-underscore-name "a test string haha"

(setq here "/afs/cern.ch/user/s/sashby")

cms-search-file-engine "emacs" here

(defun cms-search-file (indicator &optional filename)
  "*Search for INDICATOR starting from FILENAME and return the path found."
  (concat
   (car (cms-search-file-engine indicator (cms-file-directory filename)))
   indicator))


(cms-search-file "writeHits.ps" here)





(let* ((scram-dir (cms-search-file ".SCRAM" (buffer-file-name)))
       )
  (message "DIR %s" scram-dir)
  )

(setq sfa "A/B/C/D")
(cms-underscore-name sfa)

(upcase dirx)

(buffer-file-name)


(get-buffer-create "BuildFile")
(pop-to-buffer "BuildFile")


(defun create-package-buildfile()
  "Create a BuildFile for the curent package"
  (get-buffer-create "BuildFile")
  (switch-to-buffer "BuildFile")
  )

create-package-buildfile   


(get-buffer-create "BuildFile")
(switch-to-buffer-other-window "BuildFile")
;; (setq homedir "/tmp")
;; (setq homedir (getenv "HOME"))

(getenv "ARSE")
(setq thisdir (getenv "PWD"))
(setq thisdir "/tmp")
(setq scram-sourcedir "src")
(setq scram-admindir ".SCRAM")
(setq localtop (getenv "LOCALRT"))
(setq topdir (concat localtop "/" scram-sourcedir "/"))

(if (not (getenv "ARSE"))
    (message "LOCALRT not set.")
  )

;; Check to see if we are in a SCRAM project area:
(if (file-directory-p (concat localtop "/" scram-admindir))
    (if (string-match (concat "^" (regexp-quote topdir))
		      thisdir)
	(setq package (replace-match "" nil nil thisdir 0))
      )
(or (message "Not in SCRAM area"))
)

(message "THISDIR = %s" package)


(setq stest "/tmp/a/b/c")
(if (string-match "/" stest)
    (message "matched %s" (substring stest (match-end 0)))
)

;; (setq here (getenv "PWD"))
;;(string-match "\\([a-zA-Z0-9_\.-]*$\\|[a-zA-Z0-9_\.-]*/$\\)" here)
;;(match-string 0 here)
;; (setq mt (substring here 0 (match-beginning 0)))
;;(setq here (substring here 0 (match-beginning 0)))


(setq here (concat (getenv "PWD") "/" ))

(while (not (equal here ""))
  (if (file-directory-p (concat here scram-admindir))
      (setq localtop here)
    )
  (string-match "\\([a-zA-Z0-9_-\.]*$\\|[a-zA-Z0-9_\.-]*/$\\)" here)
  (setq here (substring here 0 (match-beginning 0)))
  )

(message "LOCALTOP = %s" localtop)

;;(get-buffer-create "*temp*")
;;(call-process "ls" nil "*temp*" nil "" (getenv "PWD"))

;; (setq dirlist
;;     (eval `(call-process "ls" nil nil nil, nil nil))
;; )

(setq ar "abcd")
(setq ra "")

(equal ra ar)


(defun find-localtop (&optional top)
  "*Find LOCALTOP from the current directory. Access the car() of the return."
  (interactive)
  ;; Start with current dir obtained from PWD environment
  ;; variable. Set localtop to empty string:
  (setq localtop "") 
  (setq startdir (concat (getenv "PWD") "/"))
  ;; Continue until the string for the dir is empty:
  (while (not (equal startdir ""))
    ;; See if .SCRAM dir exists from current location:
    (if (file-directory-p (concat startdir scram-admindir))
	(setq localtop startdir)
      )
    ;; Do a match to get the directory name less the last directory:
    (string-match "\\([a-zA-Z0-9_-\.]*$\\|[a-zA-Z0-9_\.-]*/$\\)" startdir)
    (setq startdir (substring startdir 0 (match-beginning 0)))
    )
  (cons localtop nil)
  )


(setq top (find-localtop))
(car top)
(perl-ins-subroutine)


(setq data (cms-search-file-engine ".SCRAM" (getenv "PWD")))

(car data)
(cdr data)


;; Create new files from scratch for new class:
(defun new-class-templates (&optional name incdir srcdir) 
  "Make two new files for a new class."
  (interactive)
  ;; Read the class name from the minibuffer:
  (while (or (not name) (string= name "")) 
    ;; If that's not possible prompt user for it
    (setq name (read-string "Class name: ")))
  ;; Figure out where to put the header file 
  (if (not incdir) 
      (setq incdir (read-string "Header directory (.): "))) 
  (if (not srcdir) 
      (setq srcdir (read-string "Source directory (.): ")))
  ;; Set default if user types C-j
  (if (eq (length incdir) 0) (setq incdir "."))
  (if (eq (length srcdir) 0) (setq srcdir "."))
  
  ;; Make file names:
  (let ((header-name) (source-name))
    (setq header-name (if (string= "." incdir) (concat name ".h") 
			(concat incdir "/" name ".h")))
    (setq source-name (if (string= "." srcdir) (concat name ".cc") 
			(concat srcdir "/" name ".cc"))) 
    ;; Check that files don't exist already:
    (if (file-exists-p header-name) 
	(error "Header file '%s' already exists - will not overwrite" 
	       header-name))
    (if (file-exists-p source-name) 
	(error "Source file '%s' already exists - will not overwrite" 
	       source-name))
    ;; Check files are writable:
    (if (not (file-writable-p header-name)) 
	(error "Cannot write header file '%s'" header-name))
    (if (not (file-writable-p source-name)) 
	(error "Cannot write source file '%s'" source-name))
    ;; Open the header file and make that current buffer:
    (find-file header-name)
    ;; Create the class template:
    (insert-class name) 
    ;; Save the file:
    (save-buffer)
    ;; Open the source file and make that current buffer:
    (if (not (string= incdir "."))
	(find-file (concat "../" source-name))
      (find-file source-name))
    ;; Add include for class.h:
    (insert "#include \"" (symbol-value 'name) "/" (symbol-value 'header-name) "\"\n\n")
    ;; Insert some member functions (defaults- assume they're of type "void":
    (insert-member-funcs name)
    ;; Save the file 
    (save-buffer)
    ;; Write a message to user
    (message "Class is in '%s' and '%s'" header-name source-name)))


(new-class-templates)