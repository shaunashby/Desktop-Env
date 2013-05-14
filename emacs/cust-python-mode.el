;;
;; cust-python-mode.el
;;
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; Font-lock keywords:
(setq cust-python-font-lock-keywords 
      (list
       '("\\(print \\)" 1 'font-lock-warning-face t)      ;; Print commands
       '("^class \\([a-zA-Z0-9]*\\):" 1 'underline t)     ;; Class names
       '("\\(__name__\\)" 1 'bold-Aquamarine-face t)      ;;
       '("\\b\\(and\\|or\\|not\\)\\b" 1 'OrangeRed2-face t)  ;;
       '("\\(\\\\\n\\)" 1 'bold-Tan2-face t)                 ;;
       '("\\( % \\)" 1 'bold-Orange-face t)                  ;;
       '("\\(\\[\\|\\]\\)" 1 'Aquamarine-face t)             ;;
       '("\\(<<\\|>>\\) " 1 'IndianRed-face t)               ;;
       '("\\( < \\| > \\| <> \\|<>\\)" 1 'bold-Wheat2-face t)  ;;
       '("\\( == \\|==\\)"  1 'bold-Wheat2-face t)             ;;
       '("\\( != \\|!=\\)"  1 'bold-Wheat2-face t)             ;;
       '("\\( & \\)" 1 'bold-OrangeRed3-face t)                ;;
       '("\\( | \\)" 1 'bold-YellowGreen-face t)               ;;
       '("\\({\\|}\\)" 1 'bold-Thistle2-face t)                ;;
       '("\\(global \\)" 1 'Green3-face t)                     ;;
       '("\\(del \\)" 1 'Brown3-face t)                        ;;
       '("\\(try\\|except\\|finally\\)" 1 'SpringGreen3-face t) ;;
       '("\\(pass \\|break \\)" 1 'SlateBlue2-face t)           ;;
       '("\\(raise \\)" 1 'bold-Sienna2-face t)                 ;;
       '("\\([rR]?'''[^']*\\(\\('[^']\\|''[^']\\)[^']*\\)*'''\\|[rR]?\"\"\"[^\"]*\\(\\(\"[^\"]\\|\"\"[^\"]\\)[^\"]*\\)*\"\"\"\\|[rR]?'\\([^'\n\\]\\|\\\\.\\)*'\\|[rR]?\"\\([^\"\n\\]\\|\\\\.\\)*\"\\)" 1 'font-lock-string-face t)     ;;
       '("^#.*" 0 'font-lock-comment-face t)              ;;
       ))

(font-lock-add-keywords 'python-mode cust-python-font-lock-keywords)
;;
(setq auto-mode-alist (append '(("\\.i$" . python-mode)) 
			      auto-mode-alist))

;; Python function definition:
(defun insert-py-def (&optional defname args)
  "Insert a Python def block with a description header"
  (interactive)
  (setq defname (read-string "Def name: "))
  (setq args (read-string "Arg list: "))
  (insert 
   (format "\ndef %-15s " (concat (symbol-value 'defname) "(" (symbol-value 'args) "):"))
   "\n\"\"\""
   "\n" (make-string 45 ?-) " "
   (format "\n  Function:   %-30s   " (symbol-value 'defname))
   (format "\n  Created:    %-30s   " (current-time-string))
   (format "\n  Description: %-30s  " "")
   "\n " (make-string 45 ?-) " "
   "\n\"\"\""
   ))

;; Function to generate header:
(defun py-insert-file-header (&optional version) 
  (interactive)
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (setq version (read-string "Python version? "))
  (insert 
   "#!/usr/bin/python" (symbol-value 'version) "
##____________________________________________________________________ 
## File: " (buffer-name) "
##____________________________________________________________________ 
##  
## Author: " (user-full-name)  " <" user-mail-address ">
## Update: " (format-time-string "%Y-%m-%d %T%z") "
## Revision: $Id" "$ 
##
## Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
##
##--------------------------------------------------------------------
\n\n\n\n
"))
;;
(add-hook 'python-mode-hook
	  (function (lambda()
		      ;; Python keymap is called py-mode-map 
		      ;; not python-mode map
		      (define-key py-mode-map "\C-cs" 'insert-py-def)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (py-insert-file-header)
			     )))))
;;
;; End of cust-python-mode.el
;;
