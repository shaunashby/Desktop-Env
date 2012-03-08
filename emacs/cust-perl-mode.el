;;
;; cust-perl-mode.el
;;

;; Perl subroutine header block:
(defun insert-sub-header (&optional subname)
  "Add a comment header block to a subroutine"
  (interactive)
  (setq subname (read-string "Subroutine name: "))
  (insert "\n   " (make-string 63 ?# )
	  "\n   #"(format " %-40s" (symbol-value 'subname)) (make-string 20 ? ) "#"
	  "\n   " (make-string 63 ?# )
	  "\n   # modified : " (format "%-24s" (current-time-string)) " / SFA " (make-string 18 ? ) "#"
	  "\n   # params   : " (make-string 49 ? ) "#"
	  "\n   #          : " (make-string 49 ? ) "#"
	  "\n   # function : " (make-string 49 ? ) "#"
	  "\n   #          : " (make-string 49 ? ) "#"
	  "\n   " (make-string 63 ?# )"\n\n" ))

;; Perl package template:
(defun new-perl-package (&optional pkgname constructor pod)
  "Insert a template for a new Perl package."
  (interactive)
  (setq pkgname (read-string "Package name (default is file name): "))
  ;; If the package name is empty, assume that the package name 
  ;; is the name of the buffer, minus the ending:
  (if (eq (length pkgname) 0) (setq pkgname (file-name-sans-extension (buffer-name))))
  (setq constructor (read-string "Constructor name (return for \"new\"): "))
  (if (eq (length constructor) 0) (setq constructor "new"))
  (insert "package " (symbol-value 'pkgname) ";\n")
  ;; Do we want to add POD documentation:
  (setq pod (read-string "Add POD skeleton? (default YES): "))
  (if (eq (length pod) 0) (perl-start-pod-skeleton))
  ;; 
  (insert "\n"	
	  "require 5.004;\n"
	  "use Exporter;\n"
	  "\n"
	  "\n"
	  "@ISA=qw(Exporter);\n"
	  "@EXPORT_OK=qw( );\n"
	  "\n\n\n"
	  "sub " (symbol-value 'constructor) "() {\n"
	  "   " (make-string 63 ?# ) "\n"
	  "   #"(format " %-40s" (symbol-value 'constructor)) (make-string 20 ? ) "#\n"
	  "   " (make-string 63 ?# ) "\n"
	  "   # modified : " (format "%-24s" (current-time-string)) " / SFA " (make-string 18 ? ) "#\n"
	  "   # params   : " (make-string 49 ? ) "#\n"
	  "   #          : " (make-string 49 ? ) "#\n"
	  "   # function : " (make-string 49 ? ) "#\n"
	  "   #          : " (make-string 49 ? ) "#\n"
	  "   " (make-string 63 ?# ) "\n"
	  "   my $proto=shift;\n"
	  "   my $class=ref($proto) || $proto;\n"
	  "   my $self={};\n"
	  "   bless $self,$class;\n"
	  "   $self->{DUMMY}=shift;\n"
	  "   return $self;\n"
	  "}\n"
	  "\n\n\n\n\n\n"
	  "1;\n\n"
	  "__END__\n\n"
	  )
  ;; Close off the POD documentation stuff:
  (if (eq (length pod) 0) (perl-end-pod-skeleton))
  )

;; Package creation function which both adds a package header
;; and adds the new package definition:
(defun perl-create-package()
  (interactive)
  "Create a new package in the current empty buffer."
  ;; First of all, add a simple file header:
  (perl-simple-header)
  ;; Insert the package:
  (new-perl-package)
  (message "New package created!")
  )

;; Functions to generate POD documentation skeletons:
(defun perl-start-pod-skeleton()
  (interactive)
  "Insert a skeleton layout for POD documentation."
  (let ((pkname))
    ;; Find the package name and use that value:
    (if (re-search-forward "package \\(.*\\);$" nil t)
	(setq pkname (match-string 1))
      (setq pkname nil))
    ;; Otherwise, fall back to asking:
    (while (or (not pkname) (string= pkname ""))
      (setq pkname (read-string "Enter the package name: ")))
    ;; Since the search for the package name puts the point at
    ;; the end of the match, we need to go back a line:
    (beginning-of-line)
    (insert 
     "\n"
     "\n"
     "=head1 NAME\n"
     "\n"
     (symbol-value 'pkname) " - <give desc here>\n"
     "\n"
     "=head1 SYNOPSIS\n"
     "\n"
     "\tmy $obj = " (symbol-value 'pkname) "->new();\n"
     "\n"
     "=head1 DESCRIPTION\n"
     "\n"
     "<describe the package here>\n"
     "\n"     
     "=head1 METHODS\n"
     "\n"
     "=over\n"
     "\n"
     "=cut\n"
     "\n"
     )))

(defun perl-end-pod-skeleton()
  (interactive)
  "Insert an end block for POD documentation."
  ;; Could jump ahead to find the end of the package, 
  ;; then do an insert, 
  ;;  (search-forward "__END__\n")
  ;;
  (insert 
   "\n"
   "=back\n"
   "\n"
   "=head1 AUTHOR/MAINTAINER\n"
   "\n"
   (user-full-name) "\n"
   "\n"
   "=cut\n"
   "\n"
   ))

(defun perl-add-pod-item()
  (interactive)
  "Add a POD doc item for a subroutine/method."
  (let ((subname))
    ;; Find the package name and use that value:
    (if (re-search-forward "sub \\(.*\\)()$" nil t)
	(setq subname (match-string 1))
      (setq subname nil))
    ;; Otherwise, fall back to asking:
    (while (or (not subname) (string= subname ""))
      (setq subname (read-string "Enter the subroutine name: ")))
    ;; Since the search for the package name puts the point at
    ;; the end of the match, we need to go back a line:
    (beginning-of-line)    
    (insert
     "\n"
     "=item C<" (symbol-value 'subname) "( {args} )>\n"
     "\n"
     "   DESCRIPTION  \n"
     "\n"
     "=cut\n\n"
     )))

;; Function to generate script header:
(defun perl-script-header (&optional args) 
  (interactive)
  "Inserts some info, including CVS Id, author, date and copyright."
  (setq args (read-string "Args to pass to Perl: "))
  (insert "#!/usr/bin/perl " (symbol-value 'args) "\n")
  (perl-simple-header)
  )

(defun perl-simple-header () 
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

;; Functions for inserts attached to menu:
(defun perl-ins-if (&optional cond)
  (interactive)
  "Insert a new perl IF statement."
  (setq cond (read-string "Condition: "))
  (insert "if (" (symbol-value 'cond) ") {       ; }"))

(defun perl-ins-ifelse (&optional cond)
  (interactive)
  "Insert a new perl IF..ELSE statement. "
  (setq cond (read-string "Condition: "))
  (insert "#\n if (" (symbol-value 'cond) ") {\n
             \n
           } else {\n\n
           }
           #\n"))

(defun perl-ins-while ()
  (interactive)
  "Insert a new perl WHILE loop."
  (insert "#\nwhile ($_ = <STDIN>) {\n\n\n\n
           }
           #"
	  ))

(defun perl-ins-for (&optional cond)
  (interactive)
  "Insert a new perl FOR loop. "
  (setq cond (read-string "Condition: "))
  (insert "#\n for ($i=1;" (symbol-value 'cond) ";$i++) {\n\n    
           }
           #\n"))

(defun perl-ins-do (&optional d)
  (interactive)
  "Insert a new perl DO loop. "
  (insert 
   "
# Match on line then extract matching part, storing in VAR:
/^(.*)/ && do {($VAR) = ($_ =~ /^(.*)/);};
"))

(defun perl-ins-foreach (&optional array)
  (interactive)
  "Insert a new perl FOREACH loop. "
  (setq array (read-string "Array: "))
  (insert "#\n foreach my $i(" (symbol-value 'array) ") {\n\n

           }
           #\n"))

(defun perl-print (&optional handle text)
  (interactive)
  "Insert a perl PRINT statement "
  (setq handle (read-string "Print to filehandle: "))
  (setq text (read-string "Enter text: "))
  (insert "print " (symbol-value 'handle) " \"" (symbol-value 'text) "\",\"\\n\";")
)

(defun perl-printf (&optional handle string vars)
  (interactive)
  "Insert a formatted perl print statement."
  (setq handle (read-string "Print to filehandle: "))
  (setq string (read-string "Formatted string: "))
  (setq vars (read-string "Variables to print: "))
  (insert 
   "printf " (symbol-value 'handle) " (\"" (symbol-value 'string) "\\n\"," (symbol-value 'vars) ");"
   ))

(defun perl-ins-subroutine (&optional subname)
  (interactive)
  "Insert a subroutine template at point."
  (setq subname (read-string "Subroutine name: "))
  (insert 
"
\n
sub " (symbol-value 'subname) "{\n"
"\n   " (make-string 63 ?# )
"\n   #"(format " %-40s" (symbol-value 'subname)) (make-string 20 ? ) "#"
"\n   " (make-string 63 ?# )
"\n   # modified : " (format "%-24s" (current-time-string)) " / SFA " (make-string 18 ? ) "#"
"\n   # params   : " (make-string 49 ? ) "#"
"\n   #          : " (make-string 49 ? ) "#"
"\n   # function : " (make-string 49 ? ) "#"
"\n   #          : " (make-string 49 ? ) "#"
"\n   " (make-string 63 ?# ) "\n"
"\n\n"
"}\n"
))

;; Font-lock keywords:
(setq cust-perl-font-lock-keywords
      (list
       '("(\\(\\sw+\\)," 1 'bold-Aquamarine-face t)              ;;
       '("(\\(\\sw+\\))" 1 'bold-Aquamarine-face t)              ;;
       '("\\(open\\|close\\)" 1 'font-lock-builtin-face t)       ;;
       '("\\(opendir\\|closedir\\)" 1 'font-lock-builtin-face t) ;;
       '("\\(sysopen\\)" 1 'SkyBlue2-face t)                     ;;
       '("\\(dbmopen \\|dbmclose \\)" 1 'Orange-face t)          ;;
       '("\\(tie \\)" 1 'Orchid-face t)                          ;;
       '("\\(print \\)" 1 'font-lock-warning-face t)             ;;
       '("\\(printf \\)" 1 'font-lock-warning-face t)            ;;
       '("\\(sprintf \\)" 1 'font-lock-warning-face t)           ;;
       '("\\( -> \\|->\\)" 1 'bold-Yellow3-face t)               ;;
       '("\\( => \\|=>\\)" 1 'bold-Yellow3-face t)               ;;
       '("\\( <=> \\|<=>\\)" 1 'bold-italic t)                   ;;
       '("\\( eq \\)" 1 'bold-YellowGreen-face t)                ;;
       '("\\( ne \\)" 1 'bold-YellowGreen-face t)                ;;
       '("\\( lt \\)" 1 'bold-YellowGreen-face t)                ;;
       '("\\( gt \\)" 1 'bold-YellowGreen-face t)                ;;
       '("\\( le \\)" 1 'bold-YellowGreen-face t)                ;;
       '("\\( ge \\)" 1 'bold-YellowGreen-face t)                ;;
       '("\\(::\\)" 1 'Plum2-face t)                             ;;
       '("\\(! \\)" 1 'bold-LightSteelBlue2-face t)              ;;
       '("\\( =~ \\| !~ \\)" 1 'bold-LightBlue3-face t)          ;;
       '("\\(<<\\|>>\\) " 1 'IndianRed-face t)                   ;;
       '("\\( < \\| > \\| <= \\| >= \\)" 1 'bold-Wheat2-face t)  ;;
       '("\\( == \\)"  1 'bold-Wheat2-face t)                    ;;
       '("\\( != \\)"  1 'bold-Wheat2-face t)                    ;;
       '("\\( && \\| and \\)" 1 'bold-OrangeRed3-face t)         ;;
       '("\\( || \\| or \\)" 1 'bold-OrangeRed3-face  t)         ;;
       '("\\( and \\| or \\)" 1 'OrangeRed2-face  t)             ;;
       '("\\(\+=\\|-=\\|\*=\\)" 1 'bold-Thistle2-face t)         ;;
       '("^#.*" 0 'font-lock-comment-face t)                     ;;
       ))

(font-lock-add-keywords 'perl-mode cust-perl-font-lock-keywords)
;;
(setq auto-mode-alist (cons '("\\.cgi\\'" . perl-mode) auto-mode-alist))
;;
(add-hook 'perl-mode-hook
	  (function (lambda()
		      (require 'easymenu)
		      (easy-menu-define perl-menu perl-mode-map "Perl Menu"
			'("Insert"
			  ["If..." perl-ins-if t]
			  ["If...else" perl-ins-ifelse t]
			  ["While" perl-ins-while t]
			  "---"
			  ["For" perl-ins-for t]
			  ["Do" perl-ins-do t]
			  ["Foreach" perl-ins-foreach t]
			  "---"
			  ["Print" perl-print t]
			  ["Print Formatted" perl-printf t]
			  "---"
			  ["New Subroutine Header" insert-sub-header t]
			  ["Insert New Subroutine" perl-ins-subroutine t]
			  ["Insert New Package" new-perl-package t]
			  "---"
			  ["Add a POD doc skeleton" perl-start-pod-skeleton t]
			  ["Add a POD doc item" perl-add-pod-item t]
			  ["End a POD doc skeleton" perl-end-pod-skeleton t]
			  "---"
			  ["Save Buffer and KILL" save-buffer-kill-buffer t]
			  ))
		      ;; Disable cust 19/10/06
		      ;; (setq perl-indent-level 0)
		      ;; (setq perl-continued-statement-offset 0)
		      ;; (setq perl-continued-brace-offset 3)
		      ;; (setq perl-brace-offset 3)
		      ;; (setq perl-brace-imaginary-offset 3)
		      ;; (setq perl-label-offset -3)
		      ;;
		      (define-key perl-mode-map "\C-m" 'newline-and-indent)
		      (define-key perl-mode-map "\C-cs" 'insert-sub-header)
		      (define-key perl-mode-map "\C-ns" 'perl-ins-subroutine)
		      (define-key perl-mode-map "\C-np" 'new-perl-package)
		      (define-key perl-mode-map "\C-xs" 'perl-start-pod-skeleton)
		      (define-key perl-mode-map "\C-xi" 'perl-add-pod-item)
		      (define-key perl-mode-map "\C-xe" 'perl-end-pod-skeleton)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     ;; If we're creating a new Perl package, run
			     ;; the functions to create the skeleton:
			     (if (string-match "\\.pm$" (buffer-file-name))
				 (perl-create-package)
			       ;; A simple script header only:
			       (perl-script-header))
			     )))))
;;
;; End of cust-perl-mode.el
;;