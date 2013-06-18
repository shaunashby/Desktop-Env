;;
;; functions-env.el
;;

(defun get-file-description (&optional fdesc)
  "File description"
  (interactive)
  (setq fdesc (read-string "Description: "))
  (insert "\n" (format "// Description: %-62s " (symbol-value 'fdesc)) " //\n" ))

;; Misc functions:
(defun insert-percent-space ()
  "insert percent and space at the start of line, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (insert "\% ")
  (beginning-of-line 2)
  )

(defun insert-pound-space () 
  "insert pound-sign and space at the start of line, then go to next line" 
  (interactive) (beginning-of-line 1)
  (insert "\# ") (beginning-of-line 2) 
  )

(defun insert-semicolon-space ()
  "insert semi-colon and space at the start of line, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (insert "\; ")
  (beginning-of-line 2)
  )

(defun insert-Cspace ()
  "insert C and space at the start of line, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (insert "C ")
  (beginning-of-line 2)
  )

(defun insert-2spaces ()
  "insert two spaces at the start of line, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (insert "  ")
  (beginning-of-line 2)
  )

(defun delete-2chars ()
  "delete 2 characters at the start of line, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (delete-char 2)
  (beginning-of-line 2)
  )

(defun insert-asterisk-space ()
  "insert asterisk and space at the start of line, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (insert "\* ")
  (beginning-of-line 2)
  )

(defun insert-c-comment ()
  "insert c comment, then go to next line"
  (interactive)
  (beginning-of-line 1)
  (insert "/\* ")
  (end-of-line 1)
  (insert " \*/")
  (beginning-of-line 2)
  )

(defun search-gt72-columns ()
  "find a line starting with a number or blank which is >72 characters long"
  (interactive)
  (search-forward-regexp "^[^Cc*].......................................................................")
  )

;; Change prompt to just y or n:
(defun yes-or-no-p (prompt)
  (y-or-n-p prompt))

(defun mangle-packagename(&optional package)
  "Take the package name as SUB/PACKAGE and return as a mangled name SUB_PACKAGE."
  (interactive)
  ;; If we don't have a / it means that there's no 
  ;; subsystem. 
  (cond ((not (string-match "/" package))
	 (setq packagestring (upcase package)))	
	((string-match "^\\(.*\\)/\\(.*\\)$" package)
	 (setq subsystem (substring package 0 (match-end 1)))
	 (setq packagename (substring package (match-beginning 2) (match-end 2)))
	 (setq packagestring (upcase (concat subsystem "_" packagename)))
	 ))
  (cons packagestring nil)
  )

(defun insert-mangled-header-guard(&optional classname)
  "Insert a header guard for the source file."
  (interactive)
  (setq mangled "")
  ;; If this is a SCRAM package, the guard will have the form 
  ;; SUBSYSTEM_PACKAGE_H or PACKAGE_H. Otherwise, just use 
  ;; the name of the file:
  (if (string= "" (car (scram-package-name)))
      (progn
	;; If we didn't get a class name, get it from the file name:
	(if (not classname)
	    (setq classname (file-name-sans-extension (buffer-name))))
	(setq mangled (concat (car (mangle-packagename classname)) "_H" ))
	)
    ;; If we got an output from scram-package-name, proceed with the value:
    (progn (setq mangled (concat (car (mangle-packagename (car (scram-package-name)))) "_" (upcase classname) "_H" ))))
  )

;; Function to insert a system header:
(defun system-include-header (&optional header) 
  "Insert an #include for a system header" 
  (interactive) 
  (while (or (not header) (string= header "")) 
    (setq header (read-string "Header name: ")))
  (insert "#include <" (symbol-value 'header) ">\n"))

;; Function to insert a local header:
(defun local-include-header (&optional header) 
  "Insert an #include for a local header file" 
  (interactive)
  (while (or (not header) (string= header "")) 
    (setq header (read-string "Header name (minus the .h): ")))  
  (insert  "#ifndef " (upcase header) "_H\n"
	   "#define " (upcase header) "_H\n"
	   "#include \"" (symbol-value 'header) ".h\"\n"
	   "#endif\n"
	   ))

(defun first-match (name pos &rest patterns)
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

(defun underscore-name (name)
  "*Insert underscores in NAME in word intervals."
  (let ((result "") (pos 0) (start nil))
    (while (setq start
		 (first-match name pos
				  "\\([A-Z]\\)\\([A-Z0-9][a-z]\\)"
				  "\\([A-Z]\\)\\([A-Z][a-z]\\)"
				  "\\([0-9]\\)\\([A-Z][a-z]\\)"
				  "\\([a-z]\\)\\([0-9][A-Z]\\)"
				  "\\([a-z]\\)\\([A-Z]\\)"))
      (setq result (concat result (substring name pos (match-end 1)) "_"))
      (setq pos    (match-beginning 2)))
    (concat result (substring name pos))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun search-file-engine (indicator directory)
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

(defun file-directory (&optional filename)
  "*Return the directory part of the FILENAME with links chased."
  (setq filename (or (and filename (file-name-directory
				    (file-chase-links filename)))
		     default-directory))
  (if (not (file-directory-p filename))
      (file-name-directory filename)
    filename))

(defun search-subdirectory (indicator &optional filename)
  "*Search for INDICATOR from FILENAME and return the subdirectory from it."
  (cdr (search-file-engine indicator (file-directory filename))))

(defun search-file (indicator &optional filename)
  "*Search for INDICATOR starting from FILENAME and return the path found."
  (concat
   (car (search-file-engine indicator (file-directory filename)))
   indicator))

(defun xcode-template-macroize ()
  "*Search the current buffer for all upcase words 
   that are surrounded by << >> and replace the brackets
   with the current special chars."
  (interactive)
  (while (re-search-forward "\\(<<[A-Z]+>>\\)" nil t 1)
    (setq item (match-string 1))
    (setq end (- (length item) 2))
    (setq replacement (substring item 2 end))
    (replace-match (concat "�" replacement "�") t nil nil nil) 
    ))

;;
;; End of functions-env.el
;;
