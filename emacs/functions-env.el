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

(defun xcode-template-macroize ()
  "*Search the current buffer for all upcase words 
   that are surrounded by << >> and replace the brackets
   with the current special chars."
  (interactive)
  (while (re-search-forward "\\(<<[A-Z]+>>\\)" nil t 1)
    (setq item (match-string 1))
    (setq end (- (length item) 2))
    (setq replacement (substring item 2 end))
    (replace-match (concat "Ç" replacement "È") t nil nil nil) 
    ))

;;
;; End of functions-env.el
;;
