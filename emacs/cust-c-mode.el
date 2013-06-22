;;
;; cust-c-mode.el
;;

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

;;
(add-hook 'c-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define c-menu c-mode-map "C Menu"
			'("Insert"
			  ["Insert System Header" system-include-header t]
			  ["Insert Local Header" local-include-header t]
			  ))
		      ;;
		      (define-key c-mode-map "\C-csh" 'system-include-header)
		      (define-key c-mode-map "\C-clh" 'local-include-header)
		      )))
;;
;; cust-c-mode.el
;;
