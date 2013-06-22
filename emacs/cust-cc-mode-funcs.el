;;; cust-cc-mode-funcs.el --- Functions specific for C and C++ modes.
;;
;; Copyright (C) 2013  Shaun Ashby
;;
;; Author: Shaun Ashby <shaun@ashby.ch>
;; Keywords:
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;;; Code:

;; Function to insert a system header:
(defun system-include-header (&optional header)
  "Insert an #include for a system header"
  (interactive)
  (while (or (not header) (string= header ""))
    (setq header (read-string "Header name: ")))
  (insert "#include <" (symbol-value 'header) ">\n"))

;; function to insert a local header:
(defun local-include-header (&optional header)
  "insert an #include for a local header file"
  (interactive)
  (while (or (not header) (string= header ""))
    (setq header (read-string "header name (minus the .h): ")))
  (insert  "#ifndef " (upcase header) "_H\n"
	   "#define " (upcase header) "_H\n"
	   "#include \"" (symbol-value 'header) ".h\"\n"
	   "#endif\n"
	   ))

;; Add #ifdef __cplusplus header guards:
(defun insert-c-in-c++-hdr-guards (&optional d)
  "Add an #ifdef __cplusplus guard to current file"
  (interactive)
  ;; #ifdef __cplusplus
  ;; extern "C" {
  ;; #endif
  ;;
  ;; ... C code goes here ...
  ;;
  ;; #ifdef  __cplusplus
  ;; }
  ;; #endif
  ;;  
  (insert
   "#ifdef __cplusplus\n"
   "extern \"C\"\n{\n"
   "#endif\n"
   "\n")
  (end-of-buffer)
  (insert
   "#ifdef __cplusplus\n"
   "}\n"
   "#endif"))

;; Create new files from scratch for new class:
(defun new-class-templates (&optional name incdir srcdir)
  "Make two new files for a new class."
  (interactive)
  ;; Read the class name from the minibuffer:
  (while (or (not name) (string= name ""))
    ;; If that's not possible prompt user for it
    (setq name (read-string "Class name: ")))
  ;; Figure out where to put the header file:
  (if (not incdir)
      (setq incdir (read-string "Header directory (.): ")))
  (if (not srcdir)
      (setq srcdir (read-string "Source directory (.): ")))
  ;; Set default if user types C-j:
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
    ;; Save the file:
    (save-buffer)
    ;; Open the source file and make that current buffer:
    (if (not (string= incdir "."))
	(find-file (concat "../" source-name))
      (find-file source-name))
    ;; Insert some member functions (defaults- assume they're of type "void":
    (insert-member-funcs name)
    ;; Save the file:
    (save-buffer)
    ;; Write a message to user:
    (message "Class is in '%s' and '%s'" header-name source-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'cust-cc-mode-funcs)
;;; cust-cc-mode-funcs.el ends here
