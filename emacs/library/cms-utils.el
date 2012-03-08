;; cms-utils.el --- Utilities for CMS software customisations.

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(defun cms-file-directory (&optional filename)
  "*Return the directory part of the FILENAME with links chased."
  (setq filename (or (and filename (file-name-directory
				    (file-chase-links filename)))
		     default-directory))
  (if (not (file-directory-p filename))
      (file-name-directory filename)
    filename))

(defun cms-search-subdirectory (indicator &optional filename)
  "*Search for INDICATOR from FILENAME and return the subdirectory from it."
  (cdr (cms-search-file-engine indicator (cms-file-directory filename))))

(defun cms-search-file (indicator &optional filename)
  "*Search for INDICATOR starting from FILENAME and return the path found."
  (concat
   (car (cms-search-file-engine indicator (cms-file-directory filename)))
   indicator))
