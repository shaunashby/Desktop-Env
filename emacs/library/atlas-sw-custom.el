;; atlas-sw-custom.el --- Customisations for the ATLAS software.

;; This file defines various standard conventions and helpers for
;; those writing software.  Here is the list of the customisations it
;; performs:
;;   - defaults C++ header and source files to `cc-mode'; likewise
;;     for Objectivity DDL files.
;;   - in `cc-mode', sets the automatic indentatation to rules that
;;     are generally pleasing aesthetically and that conform to the
;;     ATLAS coding rules.
;;   - turns on `font-lock-mode' for all C/C++ code.
;;   - improved regular expressions for `font-lock-mode' in C++
;;
;;   - default `auto-insert' templates for C, C++ and configure.in
;;     files; these include for instance automatically inserted header
;;     file guards for `.h' files, `configure.in' files that
;;     automatically conform to SRT requirements, etc.
;;
;;   - customised faces (fonts) for `font-lock-mode'; for these to
;;     work properly, we recommend you to set the following resources
;;     in your `.Xdefaults':
;;	  Emacs*popup.background:             lemonchiffon
;;	  Emacs*popup.font:                   -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;	  Emacs*menubar.background:           lemonchiffon
;;	  Emacs*menubar.font:                 -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;	  Emacs*default.attributeFont:        -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;	  Emacs*EmacsScreen.foreground:       black
;;	  Emacs*EmacsScreen*cursorColor:      red
;;	  Emacs*EmacsScreen.borderWidth:      2
;;	  Emacs*EmacsScreen.background:       white
;;	  Emacs*EmacsScreen*pointerColor:     red
;;	  Emacs*modeline.attributeBackground: black
;;	  Emacs*modeline.attributeForeground: white
;;	  Emacs*foreground:                   black
;;	  Emacs*font:                         -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;	  Emacs*bitmapIcon:                   on
;;	  Emacs.geometry:                     80x50
;;	  Emacs*background:                   white

(load-library "autoinsert")

(defun atlas-copyright-owner ()
  "*Produce copyright owner string for the source files."
  nil) ;; (or (getenv "ORGANIZATION") "ATLAS Collaboration"))

(defun atlas-boiler-plate-comment (line-prefix package-desc line-char)
  "*Produce a boilerplate comment string for inclusion in the beginning
of source files.  Each line is prefixed with LINE-PREFIX.  If not nil,
PACKAGE-DESC is used as a short package description; otherwise user is
queried interactively.  The function returns the used PACKAGE-DESC as
return value.  The copyright statement is separeted from the package
description by a line of LINE-CHARs if this argument is non-nil;
otherwise an empty line is inserted."
  (let* ((desc (or package-desc (read-string "Short package description: ")))
	 (copytext (atlas-copyright-owner))
	 (copyright (if copytext
			(concat "Copyright (C) " (substring (current-time-string) -4)
			        " by " copytext)))
	 (separator (if (and copytext line-char)
			(concat " " (make-string (max (length desc)
						      (length copyright))
						 line-char))
		      "")))
    (concat line-prefix " " desc "\n"
	    (if copytext (list line-prefix     separator "\n"
	    		       line-prefix " " copyright "\n")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar atlas-header-dir-convention 'interface
  "*Defines the package header directory naming convention.
Possible values are: 'interface, 'include, 'package-name.")
  
(defvar atlas-header-conf-convention 'in-source
  "*Defines the configuration header file convention.
Possible values are: 'none, 'in-source, 'in-header.")
  
(defvar atlas-header-conf-file-convention 'global
  "*Defines how the configuration header file is found.
Possible values are: 'global, 'local.")
  
(defvar atlas-header-conf-file-global
  "Ig_Utilities/IgConfiguration/interface/Architecture.h"
  "*Defines the project-global configuration header file.")

(defvar atlas-header-package-convention 'search
  "*Defines how package names are mentioned in include directives.
Possible values are: 'search, 'one.")

(defvar atlas-header-package-root-indicator "../.SCRAM"
  "*If this file or directory is found in a path, indicates that the
root directory for package root has been found.")

(defvar atlas-header-windows-api-convention nil
  "*If non-nil, classes should get MS-Windows DLL API switching.")

(defun atlas-search-file-engine (indicator directory)
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

(defun atlas-file-directory (&optional filename)
  "*Return the directory part of the FILENAME with links chased."
  (setq filename (or (and filename (file-name-directory
				    (file-chase-links filename)))
		     default-directory))
  (if (not (file-directory-p filename))
      (file-name-directory filename)
    filename))

(defun atlas-search-subdirectory (indicator &optional filename)
  "*Search for INDICATOR from FILENAME and return the subdirectory from it."
  (cdr (atlas-search-file-engine indicator (atlas-file-directory filename))))

(defun atlas-search-package-part (&optional filename)
  "*Try to determine the package part of the FILENAME."
  (let* ((dir (atlas-file-directory filename))
	 (part (atlas-search-subdirectory
		atlas-header-package-root-indicator dir)))
    (if part (directory-file-name part) dir)))

(defun atlas-search-file (indicator &optional filename)
  "*Search for INDICATOR starting from FILENAME and return the path found."
  (concat
   (car (atlas-search-file-engine indicator (atlas-file-directory filename)))
   indicator))

(defun atlas-first-match (name pos &rest patterns)
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

(defun atlas-underscore-name (name)
  "*Insert underscores in NAME in word intervals."
  (let ((result "") (pos 0) (start nil))
    (while (setq start
		 (atlas-first-match name pos
				    "\\([A-Z]\\)\\([A-Z0-9][a-z]\\)"
				    "\\([A-Z0-9]\\)\\([A-Z][a-z]\\)"
				    "\\([a-z]\\)\\([A-Z0-9]\\)"))
      (setq result (concat result (substring name pos (match-end 1)) "_"))
      (setq pos    (match-beginning 2)))
    (concat result (substring name pos))))

(defun atlas-header-package (filename)
  "*Return package name part of the FILENAME."
  (let* ((dir (atlas-search-package-part filename))
	 (dironly (file-name-nondirectory dir)))
    (if (or (string-equal "interface" dironly)
	    (string-equal "src" dironly)
	    (string-equal "test" dironly))
	dir)
      (directory-file-name (file-name-directory dir))))

(defun atlas-header-api (filename)
  "*Return package API name for FILENAME."
  (if atlas-header-windows-api-convention
      (concat (upcase (atlas-underscore-name
		       (file-name-nondirectory
		        (atlas-header-package filename))))
	      "_API ")
    ""))

(defun atlas-header-guard (filename)
  "*Convert FILENAME into a header file guard"
  (let ((pkg  (file-name-nondirectory (atlas-header-package filename)))
	(file (file-name-nondirectory (file-name-sans-extension filename)))
	(ext  (file-name-extension filename)))
    (concat (upcase (atlas-underscore-name pkg)) "_"
	    (upcase (atlas-underscore-name file)) "_"
	    (upcase ext))))

(defun atlas-header-configure (filename headerp)
  "*Give the configuration header file for FILENAME, treating it as a header
if HEADERP is non-nil."
  (let ((header-for-source
	 (cond ((eq atlas-header-conf-file-convention 'global)
		atlas-header-conf-file-global)
	       ((eq atlas-header-conf-file-convention 'local)
		(atlas-header-of-source filename "config.h"))
	       (t (error "Unknown atlas-header-conf-file-convention %s"
			 atlas-header-conf-file-convention)))))
    (cond ((eq atlas-header-conf-convention 'none) "")
	  ((and (eq atlas-header-conf-convention 'in-header) headerp)
	   (concat "\n# include \"" header-for-source "\"\n\n"))
	  ((and (eq atlas-header-conf-convention 'in-source) (not headerp))
	   (concat "#include \"" header-for-source "\"\n"))
	  (t ""))))

(defun atlas-header-dir-of (package)
  "*Give the header file directory of PACKAGE."
  (cond ((eq atlas-header-dir-convention 'interface)    "interface")
	((eq atlas-header-dir-convention 'include)      "include")
	((eq atlas-header-dir-convention 'package-name)
	 (file-name-nondirectory package))
	(error "Unrecognised atlas-header-dir-convention %s"
	       atlas-header-dir-convention)))

(defun atlas-header-of-source (filename &optional header)
  "*Convert source FILENAME into a corresponding header file name.
If HEADER is given, it is used as the file name.  Otherwise FILENAME's
basename is used and a header suffix added."
  (let ((pkg (atlas-header-package filename))
	(file (file-name-nondirectory (file-name-sans-extension filename))))
    (concat (file-name-as-directory
	     (concat (cond ((eq atlas-header-package-convention 'one) "")
			   ((eq atlas-header-package-convention 'search)
			    (file-name-as-directory pkg))
			   (t (error "Unknown atlas-header-package-convention %s"
				     atlas-header-package-convention)))
		     (atlas-header-dir-of pkg)))
	    (or header (concat file ".h")))))

(setq atlas-c-style
      '((c-offsets-alist
	 . ((string			. -1000)
	    (c				. c-lineup-C-comments)
	    (defun-open			. 0)
	    (defun-close		. 0)
	    (defun-block-intro		. +)
	    (class-open			. 0)
	    (class-close		. 0)
	    (inline-open		. +);; Change this!
	    (inline-close		. 0);; Change this!
	    (func-decl-cont		. -);; Change this!
	    (knr-argdecl-intro		. +)
	    (knr-argdecl		. 0)
	    (topmost-intro		. 0)
	    (topmost-intro-cont		. 0)
	    (member-init-intro		. +)
	    (member-init-cont		. 0)
	    (inher-intro		. +)
	    (inher-cont			. c-lineup-multi-inher)
	    (block-open			. 0)
	    (block-close		. 0)
	    (brace-list-open		. 0)
	    (brace-list-close		. 0)
	    (brace-list-intro		. +)
	    (brace-list-entry		. 0)
	    (statement			. 0)
	    (statement-cont		. c-lineup-math);; +
	    (statement-block-intro	. +)
	    (statement-case-intro	. +)
	    (statement-case-open	. +);; 0
	    (substatement		. +)
	    (substatement-open		. 0);; +
	    (case-label			. 0)
	    (access-label		. -)
	    (label			. -);; 2
	    (do-while-closure		. 0)
	    (else-clause		. 0)
	    (comment-intro		. c-lineup-comment)
	    (arglist-intro		. +)
	    (arglist-cont		. 0)
	    (arglist-cont-nonempty	. c-lineup-arglist)
	    (arglist-close		. +)
	    (stream-op			. c-lineup-streamop)
	    (inclass			. +)
	    (cpp-macro			. -1000)
	    (friend			. 0)
	    (objc-method-intro		. -1000)
	    (objc-method-args-cont	. c-lineup-ObjC-method-args)
	    (objc-method-call-cont	. c-lineup-ObjC-method-call)
	    (extern-lang-open		. 0)
	    (extern-lang-close		. 0)
	    (inextern-lang		. +)
	    (template-args-cont		. +)))
	(c-basic-offset			. 4)
	(c-comment-only-line-offset	. (0 . 0))
	(c-cleanup-list			. (empty-defun-braces
					   scope-operator
					   defun-close-semi
					   list-close-comma))
	(c-hanging-braces-alist		. ((brace-list-open after)
					   (class-open before after)
					   (substatement-open before after)
					   (block-close . c-snug-do-while)))
	(c-hanging-colons-alist		. ((member-init-intro before)
					   (access-label after)))
	(c-electric-pound-behavior	. (alignleft))
	(c-backslash-column		. 72)))
	

(setq
 compile-command		"gmake -k"

 c-tab-always-indent		nil
 c-recognize-knr-p		nil
 c-backslash-column		78
 c-progress-interval		1
 c-auto-newline			t

 gc-cons-threshold		8388607
 auto-mode-alist		(append '(("\\.h\\'"	 . c++-mode)
					  ("\\.h\\.in\\'"  . c++-mode)
					  ("\\.y\\'"	 . c++-mode)
					  ("\\.l\\'"	 . c++-mode)
					  ("\\.ddl\\'"	 . c++-mode)
					  ("\\.g\\'"	 . c++-mode)
					  ("[Mm]akefile" . makefile-mode))
					auto-mode-alist)

 auto-insert			t
 auto-insert-alist
 (append
  ;; C/C++ source files
  '((("\\.\\(cc\\|c\\|C\\|cpp\\|cxx\\)\\'" . "C/C++ Program File")
     nil
     '(setq confh  (atlas-header-configure (buffer-file-name) nil))
     '(setq header (atlas-header-of-source (buffer-file-name)))
     '(setq class  (file-name-nondirectory (file-name-sans-extension filename)))

     "//<<<<<< INCLUDES                                                       >>>>>>

" confh "#include \"" header "\"

//<<<<<< PRIVATE DEFINES                                                >>>>>>
//<<<<<< PRIVATE CONSTANTS                                              >>>>>>
//<<<<<< PRIVATE TYPES                                                  >>>>>>
//<<<<<< PRIVATE VARIABLE DEFINITIONS                                   >>>>>>
//<<<<<< PUBLIC VARIABLE DEFINITIONS                                    >>>>>>
//<<<<<< CLASS STRUCTURE INITIALIZATION                                 >>>>>>
//<<<<<< PRIVATE FUNCTION DEFINITIONS                                   >>>>>>
//<<<<<< PUBLIC FUNCTION DEFINITIONS                                    >>>>>>
//<<<<<< MEMBER FUNCTION DEFINITIONS                                    >>>>>>

" class "::" class " (" _ "void)
{
}
")

    ;; Package config.h
    (("config\\.h\\'" . "C/C++ Package Configuration Header File")
     nil
     '(setq guard  (atlas-header-guard (buffer-file-name)))
     '(setq confh  (atlas-header-configure (buffer-file-name) t))
     '(setq prefix (upcase (atlas-underscore-name
		            (file-name-nondirectory
		             (atlas-header-package (buffer-file-name))))))

     "#ifndef " guard "
# define " guard "

//<<<<<< INCLUDES                                                       >>>>>>

# include \"Ig_Infrastructure/IgCxxFeatures/interface/config.h\"

//<<<<<< PUBLIC DEFINES                                                 >>>>>>

/** @def " prefix "_API
  @brief A macro that controls how entities of this shared library are
         exported or imported on Windows platforms (the macro expands
         to nothing on all other platforms).  The definitions are
         exported if #" prefix "_BUILD_DLL is defined, imported
         if #" prefix "_BUILD_ARCHIVE is not defined, and left
         alone if latter is defined (for an archive library build).  */

/** @def " prefix "_BUILD_DLL
  @brief Indicates that the header is included during the build of
         a shared library of this package, and all entities marked
	 with #" prefix "_API should be exported.  */

/** @def " prefix "_BUILD_ARCHIVE
  @brief Indicates that this library is or was built as an archive
         library, not as a shared library.  Lack of this indicates
         that the header is included during the use of a shared
         library of this package, and all entities marked with
         #" prefix "_API should be imported.  */

# ifndef " prefix "_API
#  ifdef _WIN32
#    if defined " prefix "_BUILD_DLL
#      define " prefix "_API __declspec(dllexport)
#    elif ! defined " prefix "_BUILD_ARCHIVE
#      define " prefix "_API __declspec(dllimport)
#    endif
#  endif
# endif

# ifndef " prefix "_API
#  define " prefix "_API
# endif

#endif // " guard "
")

    ;; C/C++/DDL header files 
    (("\\.\\(h\\|ddl\\)\\'" . "C/C++ Header File")
     nil
     '(setq api   (atlas-header-api   (buffer-file-name)))
     '(setq guard (atlas-header-guard (buffer-file-name)))
     '(setq class (file-name-nondirectory (file-name-sans-extension filename)))
     '(setq confh (atlas-header-configure (buffer-file-name) t))

     "#ifndef " guard "
# define " guard "

//<<<<<< INCLUDES                                                       >>>>>>
" confh
"//<<<<<< PUBLIC DEFINES                                                 >>>>>>
//<<<<<< PUBLIC CONSTANTS                                               >>>>>>
//<<<<<< PUBLIC TYPES                                                   >>>>>>
//<<<<<< PUBLIC VARIABLES                                               >>>>>>
//<<<<<< PUBLIC FUNCTIONS                                               >>>>>>
//<<<<<< CLASS DECLARATIONS                                             >>>>>>

class " api class "
{
public:
    " class " (" _ "void);
    // implicit copy constructor
    // implicit assignment operator
    // implicit destructor
};

//<<<<<< INLINE PUBLIC FUNCTIONS                                        >>>>>>
//<<<<<< INLINE MEMBER FUNCTIONS                                        >>>>>>

#endif // " guard "
")

    ;; configure scripts
    (("configure\\.in\\'" . "autoconf script")
     nil
     "dnl Process this file with autoconf to produce a `configure' script.
AC_PREREQ(2.13)
AC_REVISION($Revision: 1.1 $)

dnl Initialisation
AC_INIT("
     (read-string "Unique file: ")
     ")\n"
     "AC_CONFIG_HEADER(" (read-string "config.h path (RET for none): ") & ")\n" | -17
     "SRT_INIT

dnl Configure locally and nested packages
SRT_CONFIG_LOCAL
"
     (if (y-or-n-p "Does the package contain other packages? ")
	 "SRT_CONFIG_PACKAGES\n"
       nil)

     "\n" _ "

dnl Generate output files
SRT_OUTPUT(GNUmakefile)
"))
  auto-insert-alist))

;; Reload a working faces and fonts (and hilit19, but this is later on).
(require 'faces)
(require 'font-lock)

;; Make my special faces
(message "Creating faces...")
(let ((default-font (if window-system (x-get-resource ".font" ".Font") nil)))
  (make-face 'atlas-face-normal) 
  (set-face-font 'atlas-face-normal default-font)
  
  (make-face 'atlas-face-bold)
  (set-face-font 'atlas-face-bold default-font)
  (make-face-bold 'atlas-face-bold nil t)
  
  (make-face 'atlas-face-italic)
  (set-face-font 'atlas-face-italic default-font)
  (make-face-italic 'atlas-face-italic nil t)
  
  (make-face 'atlas-face-bold-italic)
  (set-face-font 'atlas-face-bold-italic default-font)
  (make-face-bold-italic 'atlas-face-bold-italic nil t)
  
  (make-face 'atlas-face-string)
  (set-face-font 'atlas-face-string default-font)
  (set-face-background 'atlas-face-string "yellow")
  
  (make-face 'atlas-face-comment)
  (set-face-font 'atlas-face-comment default-font)
  (set-face-underline-p 'atlas-face-comment nil)
  (set-face-foreground 'atlas-face-comment "darkgreen")
  (make-face-bold 'atlas-face-comment nil t)

  (make-face 'atlas-face-reference)
  (set-face-font 'atlas-face-reference default-font)
  (make-face-bold 'atlas-face-reference nil t)
  (set-face-foreground 'atlas-face-reference "limegreen")
  
  (make-face 'atlas-face-type)
  (set-face-font 'atlas-face-type default-font)
  (set-face-foreground 'atlas-face-type "deepskyblue4")
  
  (make-face 'atlas-face-keyword)
  (set-face-font 'atlas-face-keyword default-font)
  (set-face-foreground 'atlas-face-keyword "mediumblue")
  
  (make-face 'atlas-face-function-name)
  (set-face-font 'atlas-face-function-name default-font)
  (set-face-foreground 'atlas-face-function-name "red")
  
  (make-face 'atlas-face-number)
  (set-face-font 'atlas-face-number default-font)
  (set-face-foreground 'atlas-face-number "violet")

  (make-face 'atlas-face-warning)
  (set-face-font 'atlas-face-warning default-font)
  (make-face-bold 'atlas-face-warning nil t)
  (set-face-foreground 'atlas-face-warning "red")
  (set-face-background 'atlas-face-warning "gray95"))
(message "Creating faces... done")

;; Set preferences for different faces to be used.
(setq font-lock-comment-face	'atlas-face-comment
      font-lock-reference-face	'atlas-face-reference
      font-lock-doc-string-face	'atlas-face-string
      font-lock-string-face	'atlas-face-string
      font-lock-function-name-face 'atlas-face-function-name
      font-lock-keyword-face	'atlas-face-keyword
      font-lock-type-face	'atlas-face-type
      font-lock-number-face	'atlas-face-number
      font-lock-warning-face	'atlas-face-warning)

(defun atlas-c-insert-guard ()
  (interactive)
  (insert (atlas-header-guard (buffer-file-name))))

(defun atlas-c-mode-common-hook ()
  (define-key c-mode-base-map "\C-cg" 'atlas-c-insert-guard)
  (setq next-line-add-newlines nil)
  (c-add-style "atlas" atlas-c-style t)
  (turn-on-font-lock))

(add-hook 'find-file-hooks 'auto-insert)
(add-hook 'c-mode-common-hook 'atlas-c-mode-common-hook)
(autoload 'c++-mode "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode "cc-mode" "C Editing Mode" t)

(let* ((keywords
	(eval-when-compile
	  (concat
	   "\\<\\("
	   (regexp-opt
	    '("asm" "break" "case" "catch" "class" "const_cast" "continue"
	      "default" "delete" "do" "dynamic_cast" "else" "enum" "false" "for"
	      "goto" "if" "namespace" "new" "operator" "private" "protected"
	      "public" "reinterpret_cast" "return" "sizeof" "static_cast"
	      "struct" "switch" "template" "this" "throw" "true" "try" "typeid"
	      "typename" "union" "using" "while") t)
	   "\\)\\>")))
       (operators
	(eval-when-compile
	  (regexp-opt
	   '("+" "-" "*" "/" "%" "&" "|" "^" "~" "!" "=" "<" ">" "+=" "-=" "*="
	     "/=" "%=" "^=" "&=" "|=" "<<" ">>" "==" "!=" "<=" ">=" "&&" "||"
	     "++" "--" "->*" "->" "()" "[]" "and" "and_eq" "bitand" "bitor"
	     "or_eq" "or" "xor_eq" "xor" "not" "compl" "not_neq" "new" "new[]"
	     "delete" "delete[]"))))
       (specifiers
	(eval-when-compile
	  (concat
	   "\\<\\("
	   (regexp-opt
	    '("auto" "register" "static" "extern" "export" "mutable"
	      "friend" "typedef" "inline" "virtual" "explicit"
	      "const" "volatile" "restrict") t)
	   "\\)\\>")))
       (types
	`(mapconcat 'identity
	  (cons (,@ (eval-when-compile
		      (regexp-opt
		       '("char" "wchar_t" "bool" "short" "int" "long" "signed"
			 "unsigned" "float" "double" "void"))))
		    c++-font-lock-extra-types)
	  "\\|"))
       (template-args "[^,>\n]+\\(,[^,>\n]+\\)*")
       (template-params "[^,>\n]+\\(,[^,>\n]+\\)*")
       (opt-scope (concat "\\(\\sw+[ \t]*\\(<" template-params ">\\)?::\\)*"))
       (token (concat "\\sw+[ \t]*\\(<" template-params ">\\)?\\(::[ \t*~]*"
		      "\\sw+\\(<" template-params ">\\)?\\)*"))
       (return-value			; 9 groups
	(concat "^\\(\\sw+[ \t]+\\)?\\(\\sw+[ \t]+\\)?"
		"\\(" token "[ \t*&]*[ \t]+\\)?\\([*&]+[ \t]*\\)?"))
       (operator-name			; 8 groups
	(concat opt-scope "operator[ \t]*\\(" operators "\\|"
		"\\(\\sw+[ \t]+\\)?\\(\\sw+[ \t]+\\)?" token "[ \t*&]*\\)")))
  (setq atlas-c++-font-lock-keywords
	(list
	 ;;
	 ;; Fontify error directives.
	 '("^#[ \t]*error[ \t]+\\(.+\\)" 1 font-lock-warning-face prepend)
	 ;;
	 ;; Fontify filenames in #include directives as strings.
	 '("^#[ \t]*\\(include\\|import\\)[ \t]+\\(<[^>\"\n]*>?\\)"
	   2 font-lock-string-face)
	 ;;
	 ;; Fontify function-like macro names.
	 '("^#[ \t]*\\(define\\|undef\\)[ \t]+\\(\\sw+\\)("
	   2 font-lock-function-name-face)
	 ;;
	 ;; Fontify symbol names in #elif or #if ... defined preprocessor directives.
	 '("^#[ \t]*\\(elif\\|if\\)\\>"
	   ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
	    (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t)))
	 ;;
	 ;; Fontify otherwise as symbol names, and the preprocessor directive names.
	 '("^#[ \t]*\\(\\sw+\\)\\>[ \t]*\\(\\sw+\\)?"
	   (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t))

	 ;;
	 ;; Fontity all type specifiers.
	 `(,specifiers 1 font-lock-type-face keep)
	 `(eval . (cons (concat "\\<\\(" (,@ types) "\\)\\>")
			'font-lock-type-face))
	 ;;
	 ;; Fontify all builtin keywords (except case, default and goto; see below).
	 `(,keywords 1 font-lock-keyword-face keep)
	 ;;
	 ;; Fontify case/goto keywords and targets, and case default/goto tags.
	 (list (concat "\\<\\(case\\|goto\\)\\>[ \t]*\\(-?" token "\\)")
	   2 'font-lock-reference-face nil t)
	 '(":" ("^[ \t]*\\(\\sw+\\)[ \t]*:\\($\\|[^:]\\)"
		(beginning-of-line) (end-of-line)
		(1 font-lock-reference-face)))
	 ;;
	 ;; Fontify structures, or typedef names, plus their items.
	 (list (concat "^[ \t]*}\\([ \t*]*\\(\\sw+\\)[ \t]*,?\\)+;")
	       2 'font-lock-function-name-face)
	 ;;
	 ;; Fontify global variables without a type.
	 '("^\\([_a-zA-Z0-9:~*]+\\)[ \t]*[[;={]" 1 font-lock-function-name-face)
	 ;;
	 ;; Fontify the names of functions being defined; this comes in two parts,
	 ;; first operators and then regular functions.  We assume that type specs
	 ;; are no more than 3 tokens.
	 (list (concat return-value "\\(" operator-name "\\)[ \t]*(")
	       10 'font-lock-function-name-face t)
	 (list (concat return-value "\\(" token "\\)[ \t]*(")
	       10 'font-lock-function-name-face)
	 ;;
	 ;; Fontify aggregates and enumerations
	 (list (concat "\\<\\(class\\|struct\\|union\\|enum\\|"
		       "\\(\\(virtual[ \t]+\\)?"
		       "\\(public\\|private\\|protected\\)"
		       "\\([ \t]+virtual\\)?\\([ \t]+typename\\)?\\)\\)"
		       "[ \t]+\\(" token "\\)[ \t]*[\n,:;{]")
	       7 'font-lock-function-name-face)
	 ;; Fontify numbers (use C++ preprocessing pp-number rule for simplicity)
	 '("\\<[+-]?\\.?[0-9]\\([0-9a-zA-Z_]\\|[eE][+-]\\)*\\>"
	   . font-lock-number-face)
	 ;;
	 ;; Fontify FIXMEs
	 '("\\<FIXME" 0 font-lock-warning-face t))))

(font-lock-add-keywords 'c-mode '(("\\<FIXME" 0 font-lock-warning-face t)))

(setq c++-font-lock-keywords-3 atlas-c++-font-lock-keywords)
