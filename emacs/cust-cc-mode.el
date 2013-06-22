;;
;; cust-cc-mode.el
;;

;; C++:
(font-lock-add-keywords
 'c++-mode
 '(("\\<FIXME:\\>" 0 'Orange-face t)
   ("^class \\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
   ("^class \\([a-zA-Z0-9]*\\):" 1 'bold-italic t)
   ("  class \\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
   ("  class \\([a-zA-Z0-9]*\\):" 1 'bold-italic t)
   ("\\(^public\\|^private\\|^protected\\):" 1 'bold-LightSteelBlue2-face t)
   ("\\(  public\\|  private\\|  protected\\):" 1 'bold-LightSteelBlue2-face t)
   ("::" . 'Thistle2-face)
   ("\\<\\(struct\\|union\\|enum\\|virtual[ \t]\\)" 1 'GreenYellow-face)
   ("\\<\\(catch \\|try \\|throw\\)" 1 'Plum2-face t)
   ("\\<\\(case\\|goto\\)" 1 'SkyBlue-face t)
   ("\\<\\(friend\\|inline\\)" 1 'Sienna2-face t)
   ("\\<\\(include\\)" 1 'Brown-face t)
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
    ;; Save the file:
    (save-buffer)
    ;; Open the source file and make that current buffer:
    (if (not (string= incdir "."))
	(find-file (concat "../" source-name))
      (find-file source-name))
    ;; Insert some member functions (defaults- assume they're of type "void":
    (insert-member-funcs name)
    ;; Save the file 
    (save-buffer)
    ;; Write a message to user
    (message "Class is in '%s' and '%s'" header-name source-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
(add-hook 'c++-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define cpp-menu c++-mode-map "C++ Menu"
			'("Insert"
			  ["New Class Templates" new-class-templates t]
			  "---"
			  ["Insert Header Guards" insert-c-in-c++-hdr-guards t]
			  ))
		      ;;
		      (define-key c++-mode-map "\C-m" 'newline-and-indent)
		      )))
;;
(setq auto-mode-alist (append '(("\\.cpp\\'" . c++-mode) 
				("\\.C\\'" . c++-mode)
				("\\.icc\\'" . c++-mode)
				("\\.h\\'"   . c++-mode)
				("\\.cxx\\'" . c++-mode)
				)
			      auto-mode-alist))
;;
;; End of cust-cc-mode.el
;;
