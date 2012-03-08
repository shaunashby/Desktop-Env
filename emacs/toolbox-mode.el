;;____________________________________________________________________ 
;; File: toolbox-mode.el --- major mode for editing SCRAM ToolDocs
;;____________________________________________________________________ 
;;  
;; Author: Shaun Ashby <Shaun.Ashby@cern.ch>
;; Update: 2003-03-07 12:15:06+0100
;; Revision: $Id: toolbox-mode.el,v 1.9 2005/08/19 16:29:58 sashby Exp $ 
;;
;; Copyright: 2003 (C) Shaun Ashby
;;
;;--------------------------------------------------------------------
;;
;; Keywords:	CMS, configuration, SCRAM, ToolDoc 
;;
;; It is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; It is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your copy of Emacs; see the file COPYING.  If not, write
;; to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;
;; Information for use:
;; -----------------------------------------------
;; 
;; I didn't like the way font-locking was working when using HTML/SGML mode to
;; edit ToolDocs or Toolbox configuration files, so I decided to make my own mode.
;; To enable automatic selection of this mode when appropriate files are
;; visited, add the following to your favourite site or personal Emacs
;; configuration file:
;;
;;   (autoload 'toolbox-mode "toolbox-mode" "autoloaded" t)
;;   (add-to-list 'auto-mode-alist '("\\BuildFile\\'" . toolbox-mode))
;;   (add-to-list 'auto-mode-alist '("\\Configuration\\'" . toolbox-mode))
;;
;;

;; To handle regexps:
(require 'regexp-opt)
;; For menu:
(require 'easymenu)

;; Define some variables:
(defconst toolbox-mode-version-string "ToolBox 1.0 [02/12/03] (SFA)")

(defvar toolbox-dir (getenv "TOOLBOX_BASEDIR")
  "The directory from where, by default, toolboxes are accessed.")
(defvar toolbox-name-regexp "CMS_[1-9].*" "The REGEXP for the usual name of the toolbox directory.")

(defvar toolbox-mode-map nil
  "Keymap used in toolbox config mode buffers")

(defconst toolbox-mode-menu-main
  '("ToolBox"
    ["Environment" toolbox-tool-environment t]
    ["Tool" toolbox-tool-template t]
    "---"
    ["Insert architecture block" toolbox-define-arch t]
    ["Insert a <Use> tag" toolbox-insert-use t]
    ["Insert a <Lib> tag" toolbox-insert-lib t]
    "---"
    ("Templates"
     ["CMS Tool Block" toolbox-tools-cms t]
     ["Single Entry" toolbox-tool-entry t])
    ("BuildFile Specific Tags"
     ["Insert a <Group> tag " toolbox-insert-group t]
     "---"
     ["Define new group" toolbox-define-group t]
     ["Define build product" toolbox-define-product t]
     )
    ))

(unless toolbox-mode-map
  (setq toolbox-mode-map (make-sparse-keymap))
  (define-key toolbox-mode-map "\C-cv" 'toolbox-mode-show-version)
  (define-key toolbox-mode-map "\C-ct" 'toolbox-tool-template)
  (define-key toolbox-mode-map "\C-cc" 'toolbox-tools-cms)
  (define-key toolbox-mode-map "\C-ce" 'toolbox-tool-environment)
  (define-key toolbox-mode-map "\C-cn" 'toolbox-tool-entry)
  (easy-menu-define toolbox-mode-main toolbox-mode-map "ToolBox" toolbox-mode-menu-main))

(defvar toolbox-mode-syntax-table nil
  "toolbox config mode syntax table")

(defvar toolbox-mode-hook nil
  "*List of hook functions run by `toolbox-mode' (see `run-hooks')")

;; Stuff for font-lock-mode:
(defconst toolbox-font-lock-keywords 
  (list
   ;; Comments starting at beginning of lines
   '("^//.*" 0 'font-lock-comment-face t)
   '("^.*\\([^:]//.*\\)" 1 'font-lock-comment-face t)
   '("<!--.*-->" . font-lock-comment-face)
   '("<[^>]*>" . 'default)
   '(".*\=\\(.*[^>]\\)>.*<.*>$" 1 'Khaki3-face t)
   '(".*>\\(.*\\)<.*" 1 'secondary-selection t)
   '("<[^>=]*\\(href\\|src\\)[ \t\n]*=[ \t\n]*\"\\([^\"]*\\)\"" 
     2 font-lock-string-face t)
   '(">\\([^<]+\\)</a>" 1 font-lock-reference-face)
   '("</b>\\([^<]+\\)</b>" 1 bold)
   '("</i>\\([^<]+\\)</i>" 1 italic)
   '("\\(bin\\|library\\|module\\|application\\|app\\)" 1 'Sienna2-face t)
   '("\\(select\\|deselect\\)" 1 'Pink-face t) 
   '("\\(ignore\\|base\\|project\\|download\\)" 1 'Aquamarine3-face t) 
   '("\\([Ee]nvironment\\|[Gg]roup\\|[Uu]se\\|[Ee]xport\\|[Ll][Ii][Bb] \\)" 1 'Aquamarine2-face t)
   '("\\([Rr]untime\\)" 1 'Aquamarine3-face t)
   '("\\([Ee]xport\\)" 1 'italic t)
   '("\\([Dd]efine_[Gg]roup\\)" 1 'Orchid2-face t)
   '("\\([Ss]kip\\)" 1 'SeaGreen2-face t)
   '("\\([Tt]ool\\)" 1 'SkyBlue3-face  t)
   '(".*[^-]\\([Cc]lient\\)" 1 'SteelBlue2-face  t)
   '("\\(name\\|value\\|dir\\|default\\|version\\|url\\|type\\|[Uu]se\\|file\\|handler\\|swap\\|path\\)\=" 1 'SpringGreen3-face t)
   '("\=\\(bin\\|lib\\|module\\|application\\|python\\)" 1 'default t)
   '("\\( version\\)\=[a-zA-Z0-9\._-]" 1 'SpringGreen3-face t)
   '("\\([Aa]rchitecture\\)" 1 'SkyBlue-face  t)
   '("\\([Cc]lass[Pp]ath\\|[Pp]roduct[Ss]tore\\)" 1 'SkyBlue2-face  t)
   '(".*<ClassPath path=\\(.*\\)>.*" 1 'Gold-face t)
   '(".*<[Pp]roduct[Ss]tore name=\\([a-zA-Z0-9_]\\) " 1 'Coral-face t)
   '("=\\(\".*\"\\)" 1 'Wheat-face t)
   '("\\([Ff]lags \\)" 1 'Green-face t)
   '("[Ff]lags \\(.*\\)=\"" 1 'GreenYellow-face  t)
   '("[Ff]lags .*=\\(\".*\"\\)" 1 'Yellow-face  t)
   '("\\([Ii]nclude_path path\\)" 1 'Green-face  t)
   '("[Ii]nclude_path .*=\\(.*\\)" 1 'Yellow-face  t)
   '("\\([Mm]akefile\\)" 1 'PaleGreen-face  t)
   '("\\(.*::.*\\)>.*" 1 'Coral4-face t)
   '("\\([Ii]nfo .*\\)>.*" 1 'Coral3-face t)
   '("\\(RequirementsDoc\\|requirements\\)" 1 'Brown2-face  t)
   '("\\(include\\|download\\) url" 1 'PaleGreen-face t)
   '("<\\(require \\)" 1 'YellowGreen-face t)
   '(".*<\\(/require\\)>.*" 1 'YellowGreen-face t)
   '("\\(Config\\) dir" 1 'PaleGreen-face t)
   '(".* name\=\\([a-zA-Z0-9-_]*\\).*" 1 'bold-italic t)
   '(".* version\=\\([a-zA-Z0-9-_\.]*\\) .*" 1 'bold-italic t)
   '(".*<use name\=\\([a-zA-Z0-9-_/]*\\).*" 1 'bold-italic t)
   '("^#.*" 0 'font-lock-comment-face t)
   )
  "Basic expressions to highlight in toolbox config buffers.")

;; Now a syntax table
(if toolbox-mode-syntax-table
    nil
  (setq toolbox-mode-syntax-table (copy-syntax-table nil))
  (modify-syntax-entry ?_   "_"     toolbox-mode-syntax-table)
  (modify-syntax-entry ?-   "_"     toolbox-mode-syntax-table)
  (modify-syntax-entry ?\(  "(\)"   toolbox-mode-syntax-table)
  (modify-syntax-entry ?\)  ")\("   toolbox-mode-syntax-table)
  (modify-syntax-entry ?\<  "(\>"   toolbox-mode-syntax-table)
  (modify-syntax-entry ?\>  ")\<"   toolbox-mode-syntax-table)
  (modify-syntax-entry ?\"   "\""   toolbox-mode-syntax-table))

;; Toolbox functions:
(defun toolbox-mode-show-version ()
  "Show the version of ToolBox-mode currently in use."
  (interactive)
  (message "*** This is version %s of ToolBox-mode ***" toolbox-mode-version-string))

(defun toolbox-tool-entry (&optional name version url)
  "Insert an entry in a SCRAM toolbox configuration file."
  (interactive)
  (setq name (read-string "Tool name: "))
  (setq version (read-string "Tool version: "))
  (setq url (read-string "URL (path to tool from toolbox directory): "))
  (insert "<require name=" (symbol-value 'name) " version=" (symbol-value 'version) " url=\"cvs:\?module=SCRAMToolBox/" (symbol-value 'url) "/" (symbol-value 'name) "\"></require>"))

(defun toolbox-tools-cms ()
  "Add a block for the CMS Configuration that contains CMS OO tools."
  (interactive)
  (insert "<require name=IGUANACMS version=IGUANACMS_1_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/IGUANACMS\">\n"
	  "</require>\n"
	  "<require name=IGUANA version=IGUANA_4_1_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/IGUANA\">\n"
	  "</require>\n"
	  "<require name=FAMOS version=FAMOS_0_9_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/FAMOS\">\n"
	  "</require>\n"
	  "<require name=OSCAR version=OSCAR_3_1_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/OSCAR\">\n"
	  "</require>\n"
	  "<require name=ORCA version=ORCA_8_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/ORCA\">\n"
	  "</require>\n"
	  "<require name=Geometry version=Geometry_1_6_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/Geometry\">\n"
	  "</require>\n"
	  "<require name=COBRA version=COBRA_8_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/COBRA\">\n"
	  "</require>\n"
	  "<require name=IGNOMINY version=IGNOMINY_1_7_ url=\"cvs:\?module=SCRAMToolBox/CMS/Tools/Ignominy\">\n"
	  "</require>\n"
	  ))

(defun toolbox-tool-template (&optional name version url libname)
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
	  " <Environment name=" (concat (upcase name) "_BASE") ">\n"
	  " </Environment>\n"
	  " <Environment name=BINDIR default=$" (concat (upcase name) "_BASE/bin" ) ">\n"
          " </Environment>\n"
	  " <Environment name=LIBDIR default=$" (concat (upcase name) "_BASE/lib" ) ">\n"
          " </Environment>\n"
	  " <Environment name=INCLUDE default=$" (concat (upcase name) "_BASE/include" ) ">\n"
          " </Environment>\n"
	  "</Client>\n"
	  "<Runtime name=PATH value=$BINDIR type=path>\n"
	  "<Runtime name=LD_LIBRARY_PATH value=$LIBDIR type=path>\n"
	  "</Tool>\n"
	  ))

(defun toolbox-tool-environment (&optional envname envvalue)
  "Add an environment entry to a tool description."
  (interactive)
  (setq envname (read-string "Environment name: "))
  (setq envvalue (read-string "Value: "))
  (insert "<Environment name=" (symbol-value 'envname) " default=" (symbol-value 'envvalue)">\n"
	  "</Environment>\n"
	  ))

;; Other functions:
(defun toolbox-define-arch (&optional name)
  (interactive)
  "Inserts a new architecture-specific block in a SCRAM BuildFile."
  (if (not name)
      (setq name (read-string "Arch name: ")))
  (if (eq (length name) 0) (setq name "slc3_ia32_gcc323"))
  (insert
   "<architecture name=" (symbol-value 'name) ">\n" 
   "\n\n"
   "</architecture>\n"
   )
  (search-backward-regexp "<architecture")
  (beginning-of-line 2)
  (indent-to-column 2)
  (save-buffer)
  )

(defun toolbox-define-group (&optional name)
  (interactive)
  "Inserts a new group definition in a SCRAM BuildFile."
  (if (not name)
      (setq name (read-string "Group name: ")))
  (if (eq (length name) 0) (setq name "TEST"))
  (insert
   "<define_group name=" (symbol-value 'name) ">\n" 
   "\n\n"
   "</define_group>\n"
   )
  (search-backward-regexp "<define")
  (beginning-of-line 2)
  (indent-to-column 2)
  (save-buffer)
  )

(defun toolbox-insert-use (&optional name)
  (interactive)
  "Insert a <use> tag."
  (if (not name)
      (setq name (read-string "Package name: ")))
  (if (eq (length name) 0) (setq name "TEST"))
  (indent-to-column 2)
  (insert
   "<use name=" (symbol-value 'name) ">\n" 
   )
  (save-buffer)
  )

(defun toolbox-insert-lib (&optional name)
  (interactive)
  "Insert a <lib> tag."
  (if (not name)
      (setq name (read-string "Library name: ")))
  (if (eq (length name) 0) (setq name "TEST"))
  (indent-to-column 2)
  (insert
   "<lib name=" (symbol-value 'name) ">\n" 
   )
  (save-buffer)
  )

(defun toolbox-insert-group (&optional name)
  (interactive)
  "Insert a <group> tag."
  (if (not name)
      (setq name (read-string "Group name: ")))
  (if (eq (length name) 0) (setq name "TEST"))
  (indent-to-column 2)
  (insert
   "<group name=" (symbol-value 'name) ">\n" 
   )
  (save-buffer)
  )

(defun toolbox-define-product (&optional name)
  (interactive)
  "Inserts a new product block (binary, module, application) in a SCRAM BuildFile."
  (if (not name)
      (setq name (read-string "Product name (bin/module/app/library): ")))
  (if (eq (length name) 0) (setq name "library"))
  (insert
   "<" (symbol-value 'name) " file=    name=   >\n" 
   "\n\n"
   "</" (symbol-value 'name) ">\n"
   )
  (search-backward-regexp (concat "<" (symbol-value 'name)))
  (beginning-of-line 2)
  (indent-to-column 2)
  (save-buffer)
  )

;;;###autoload
(defun toolbox-mode ()
  "Major mode for editing toolbox configuration files.

\\{toolbox-mode-map}

\\[toolbox-mode] runs the hook `toolbox-mode-hook'."
  (interactive)
  (kill-all-local-variables)
  (use-local-map toolbox-mode-map)
  (set-syntax-table toolbox-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults)
       '(toolbox-font-lock-keywords t))
  (make-local-variable 'comment-start)
  (setq comment-start "# ")
  (make-local-variable 'comment-column)
  (setq comment-column 60)
  (setq mode-name "ToolBox")
  (setq major-mode 'toolbox-mode)
  (run-hooks 'toolbox-mode-hook))

;; Finish off:
(provide 'toolbox-mode)
;;
;; End of toolbox-mode.el
;;
