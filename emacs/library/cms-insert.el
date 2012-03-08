;; cms-insert.el --- Auto-insertions for the CMS software.

;; This file defines default `auto-insert' templates for C, C++ and
;; configure.in files; these include for instance automatically
;; inserted header file guards for `.h' files, etc.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install autoinsert.
(load-library "autoinsert")
(add-hook 'find-file-hooks 'auto-insert)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The customisation settings for a file should return a list of pairs
;; '((name . value) ...) where "name" is one of the values listed
;; below and value is an acceptable value.  Note that this is a
;; function and not a list so that the various values can be computed
;; if so required.  This probably should be cleaned up somehow...
;;
;;   * 'copyright-owner: String that identifies the copyright owner of
;;   this file.  If nil, no copyright statement is added to the file.
;;   Otherwise the value must be a string, and it will be used to to
;;   construct the boiler-plate comment as defined by the insertion
;;   template.  If this is non-nil, 'copyright-desc, 'copyright-year,
;;   'copyright-style, 'copyright-prefix and 'copyright-separator are
;;   also used.  A value can be provided automatically with a
;;   construct such as:
;;      (or (getenv "ORGANIZATION") "CMS Collaboration")
;;
;;   * 'copyright-desc: String that provides a short (one-line)
;;   description of the package that can be used in the boiler-plate
;;   comment added to the source file.  The value is used only if
;;   'copyright-owner is non-nil.  One way to obtain the value is
;;   (read-string "Short package description: ").  Of course you
;;   should do that only if you return non-nil 'copyright-owner!
;;
;;   * 'copyright-year: String that provides the copyright year
;;   for the file.  If nil and 'copyright-owner is non-nil, the
;;   current year is used.
;;
;;   * 'copyright-style: Type of copyright boiler-plate to add.  This
;;   can be either 'single-line for a compact one, 'multi-line for a
;;   multi-line one where the package description is separated by a
;;   line of 'copyright-separator characters from the year notice, or
;;   'none for no notice at all (equivalent to setting owner to nil).
;;
;;   * 'copyright-prefix: The prefix to use for the copyright lines.
;;   Normally a comment starter such as "//".
;;
;;   * 'copyright-separator: If non-nil, this should be a character
;;   that is used to separate the package description line from the
;;   actual copyright line.
;;
;;
;;   * 'header-dir-convention: Specifies the header directory
;;   convention for this source file location, typically by project
;;   convention.  The value must be one of 'interface (headers are in
;;   the "interface" subdirectory of the package), 'include (headers
;;   in the "include" subdirectory), 'package (headers are in a
;;   subdirectory with a name identical to the package name, or 'none
;;   (something else that the template should ignore).
;;
;;   * 'include-conf-file: Specifies the configuration header file
;;   #include convention.  The value must be one of 'none (no config
;;   header), 'in-source (the config header is included in source) or
;;   'in-header (the config header is included in header).
;;
;;   * 'conf-file-style: Defines how the configuration header file is
;;   found.  The value must be either 'global (there is only one
;;   global file), or 'local (there's a config file in every package).
;;
;;   * 'local-conf-file: String identifying the package local
;;   configuration header file.  Used only if 'conf-file-style is
;;   'local.
;;
;;   * 'global-conf-file: String identifying the project-global
;;   configuration header file.  If 'conf-file-style is 'local, this
;;   file is included by the local configuration file (and if nil, no
;;   file is included).  If 'conf-file-style is 'global, this is the
;;   file included.
;;
;;
;;   * 'package-convention: Specifies how package names are mentioned
;;   in #include directives.  Possible values are 'search (search up
;;   in the tree until 'package-area exists, and take the whole path
;;   up there) and 'one (only one level is added: the package include
;;   directory).
;;
;;   * 'package-root: Specifies a file whose presence indicates, while
;;   searching up from the current directory, that the root of the
;;   package has been found.  This is handy if packages have nested
;;   subdirectories that should appear in #include directives and
;;   header guards.  Note that 'package-area defines how the root of
;;   the area holding packages themselves is found, whereas this
;;   variable defines how to recognise subpaths within a package.  If
;;   left to the default nil, it is assumed packages don't have
;;   subdirectories (despite what the filename path is).
;;
;;   * 'package-area: Specifies a file whose presence indicates, while
;;   searching up from the current directory tree, that the root of
;;   the package area is found.  The path up from that defines the
;;   path to the package itself from the root of the working area.
;;   Note that 'package-root defines the directories within a package,
;;   whereas this variable defines the path above the package.  If
;;   left to the default nil, it is assumed there is no structure,
;;   which is hardly what you intended.
;;
;;   * 'package-prefix: Prefix to prepend to the package name computed
;;   with 'package-area.  This is useful if 'package-area is not even
;;   meant to match and you want to specify a hard-coded prefix.
;;
;;
;;   * 'windows-api: If non-nil, classes declaration in a header
;;   should get MS-Windows DLL API switching.  This usually implies
;;   'conf-file-style being 'local, the relevant macros for the
;;   package are automatically inserted if a "config.h" file is
;;   created in the same package.

(defun cms-source-convention (filename)
  "*Get the conventions for the file named FILENAME."
  (cond ((string-match "/classlib/" filename)
	 `((copyright-owner		. "Lassi A. Tuura <lat@iki.fi>")
	   (copyright-desc		. "C++ Class Library")
	   (copyright-year		. ,(concat "1993-"
						   (substring
						    (current-time-string) -4)))
	   (copyright-style		. single-line)
	   (copyright-prefix		. "//")
	   (copyright-separator		. nil)
	   (header-dir-convention	. none)
	   (include-conf-file		. in-header)
	   (conf-file-style		. global)
	   (global-conf-file		. "classlib/system.h")
	   (package-convention		. search)
	   (package-prefix		. "classlib")
	   (package-root		. "../COPYING")
	   (windows-api			. t)))

	((string-match "/IGUANA_" filename)
	 '((header-dir-convention	. interface)
	   (include-conf-file		. in-header)
	   (conf-file-style		. local)
	   (local-conf-file		. "config.h")
	   (global-conf-file
	    . "Ig_Infrastructure/IgCxxFeatures/interface/config.h")
	   (package-convention		. search)
	   (package-area		. "../.SCRAM")
	   (windows-api			. t)))

	(t
	 '((header-dir-convention	. interface)
	   (include-conf-file		. in-source)
	   (conf-file-style		. global)
	   (global-conf-file
	    . "Utilities/Configuration/interface/Architecture.h")
	   (package-convention		. search)
	   (package-area		. "../.SCRAM")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cms-form-copyright (args)
  "*Form a boilerplate copyright string for inclusion in the beginning
of source files as per conventions defined in ARGS.  Each line is prefixed
with 'copyright-prefix.  If not nil, 'copyright-desc is used as a package
description.  If 'copyright-style is 'single-line the copyright is made
as a single line; otherwise if it is 'multi-line, the message is separated
from the package description by a line of 'copyright-separator characters
if it is non-nil; otherwise an empty line is inserted; otherwise style."
  (let* ((style (cdr (assoc 'copyright-style args)))
	 (desc  (cdr (assoc 'copyright-desc args)))
	 (owner (cdr (assoc 'copyright-owner args)))
	 (year  (or (cdr (assoc 'copyright-year args))
		    (substring (current-time-string) -4)))
	 (pfx   (cdr (assoc 'copyright-prefix args)))
	 (sepch (cdr (assoc 'copyright-separator args)))
	 (right (if owner (concat "Copyright (C) " year " " owner)))
	 (sep   (if (and owner sepch)
		    (concat " " (make-string (max (length desc) (length right))
					     sepch))
		  "")))
    (cond ((or (not style) (eq style 'none)) "")
	  ((eq style 'single-line)
	   (concat pfx " " desc ", " right "\n\n"))
	  ((eq style 'multi-line)
	   (concat pfx " " desc "\n"
		   (if owner (list pfx sep "\n" pfx " " right "\n"))
		   "\n")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cms-search-package-part (filename args)
  "*Determine the portion of FILENAME that is the package part
according to conventions in ARGS."
  (let* ((dir (cms-file-directory filename))
	 (root (cdr (assoc 'package-area args)))
	 (part (cms-search-subdirectory (or root "") dir)))
    (if part (directory-file-name part) dir)))

(defun cms-search-subpath-part (filename args)
  "*Determine the portion of FILENAME that is within the package
according to conventions in ARGS."
  (let* ((dir (cms-file-directory filename))
	 (root (cdr (assoc 'package-root args)))
	 (part (cms-search-subdirectory (or root "") dir)))
    (if part (directory-file-name part) "")))

(defun cms-header-package (filename args)
  "*Return package name part of the FILENAME according to the
conventions defined in ARGS."
  (let* ((prefix  (cdr (assoc 'package-prefix args)))
	 (leader  (cms-search-package-part filename args)))
    (directory-file-name (concat (if prefix (file-name-as-directory prefix))
				 (file-name-directory leader)))))

(defun cms-header-subpath (filename args)
  "*Return from FILENAME the subdirectory part that is within the
package as specified by conventions in ARGS."
  (directory-file-name (cms-search-subpath-part filename args)))

(defun cms-header-api-prefix (filename args)
  "*Return package API prefix name for FILENAME using conventions ARGS."
  (upcase (cms-underscore-name (file-name-nondirectory
				(cms-header-package filename args)))))

(defun cms-header-api (filename args)
  "*Return package API name for FILENAME using conventions ARGS."
  (if (cdr (assoc 'windows-api args))
      (concat (cms-header-api-prefix filename args) "_API ")
    ""))

(defun cms-header-guard (filename args)
  "*Convert FILENAME into a header file guard using convetions ARGS."
  (let ((prefix  (file-name-nondirectory (cms-header-package filename args)))
	(trailer (cms-header-subpath filename args))
	(file    (file-name-nondirectory (file-name-sans-extension filename)))
	(ext     (file-name-extension filename)))
    (concat (upcase (cms-underscore-name prefix)) "_"
	    (if (not (string-equal trailer ""))
		(concat (upcase (cms-underscore-name trailer)) "_"))
	    (upcase (cms-underscore-name file)) "_"
	    (upcase ext))))

(defun cms-header-configure (filename from args)
  "*Give the configuration header file for FILENAME accessed from FROM
according to conventions ARGS.  FROM must be 'source (access from
source), 'header (access from header), or 'conf (access from
package-local config header)."
  (let* ((incl   (cdr (assoc 'include-conf-file args)))
	 (style  (cdr (assoc 'conf-file-style args)))
	 (global (cdr (assoc 'global-conf-file args)))
	 (local  (cdr (assoc 'local-conf-file args)))
	 (header (cond ((eq style 'global) global)
		       ((eq style 'local)
			(if (eq from 'conf) global
			  (cms-header-of-source filename local args)))
		       (t (error "Unknown conf-file-style %s" style)))))
    (cond ((eq incl 'none) "")
	  ((and (eq incl 'in-header) (not (eq from 'source)))
	   (concat "\n# include \"" header "\"\n\n"))
	  ((and (eq incl 'in-source) (eq from 'source))
	   (concat "#include \"" header "\"\n"))
	  (t ""))))

(defun cms-header-dir-of (package args)
  "*Give the header file directory of PACKAGE based on conventions ARGS."
  (let ((convention (cdr (assoc 'header-dir-convention args))))
    (cond ((eq convention 'interface) "interface")
	  ((eq convention 'include)   "include")
	  ((eq convention 'package)   (file-name-nondirectory package))
	  ((eq convention 'none)      "")
	  (t (error "Unrecognised header-dir-convention %s" convention)))))

(defun cms-header-of-source (filename header args)
  "*Convert source FILENAME into a corresponding header file name.  If
HEADER is non-nil, it is used as the file name.  Otherwise FILENAME's
basename is used and a header suffix added.  Uses conventions given in
ARGS."
  (let ((style   (cdr (assoc 'package-convention args)))
	(prefix  (cms-header-package filename args))
	(trailer (cms-header-subpath filename args))
	(file    (file-name-nondirectory (file-name-sans-extension filename))))
    (concat (file-name-as-directory
	     (concat
	      (cond ((eq style 'one) "")
		    ((eq style 'search) (file-name-as-directory prefix))
		    (t (error "Unknown package-convention %s" style)))
	      (cms-header-dir-of prefix args)))
	    (if (not (string-equal trailer ""))
		(file-name-as-directory trailer))
	    (or header (concat file ".h")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
 auto-insert			t
 auto-insert-alist
 (append
  ;; C/C++ source files
  '((("\\.\\(cc\\|c\\|C\\|cpp\\|cxx\\)\\'" . "C/C++ Program File")
     nil
     '(setq args   (cms-source-convention (buffer-file-name)))
     '(setq copy   (cms-form-copyright args))
     '(setq confh  (cms-header-configure (buffer-file-name) 'source args))
     '(setq header (cms-header-of-source (buffer-file-name) nil args))
     '(setq class  (file-name-nondirectory (file-name-sans-extension filename)))

     copy
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
     '(setq args   (cms-source-convention (buffer-file-name)))
     '(setq copy   (cms-form-copyright args))
     '(setq guard  (cms-header-guard (buffer-file-name) args))
     '(setq confh  (cms-header-configure (buffer-file-name) 'conf args))
     '(setq prefix (cms-header-api-prefix (buffer-file-name) args))

     copy
     "#ifndef " guard "
# define " guard "

//<<<<<< INCLUDES                                                       >>>>>>
" confh
"//<<<<<< PUBLIC DEFINES                                                 >>>>>>

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
     '(setq args  (cms-source-convention (buffer-file-name)))
     '(setq copy  (cms-form-copyright args))
     '(setq api   (cms-header-api   (buffer-file-name) args))
     '(setq guard (cms-header-guard (buffer-file-name) args))
     '(setq class (file-name-nondirectory (file-name-sans-extension filename)))
     '(setq confh (cms-header-configure (buffer-file-name) 'header args))

     copy
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
AC_PREREQ(2.53)
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
