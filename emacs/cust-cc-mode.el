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

;; Function to insert a set of member functions:
(defun insert-member-funcs (&optional classname) 
  "Insert a set of member functions for given class." 
  (interactive)
  (if (not classname)
      (setq classname (read-string "Class name (or <ret> to use file name): ")))
  ;; Also get the package name for the include for this class defn.:
  (setq packagename (car (scram-package-name)))
  ;; If no classname given, user buffer name less the ending:
  (if (eq (length classname) 0) (setq classname (file-name-sans-extension (buffer-name))))
  ;; If no package name, use the class name:
  (if (eq (length packagename) 0) (setq packagename classname))
  ;;
  (insert "#include \"" packagename "/interface/" (symbol-value 'classname) ".h\"\n"
	  "#include <iostream>\n
"(symbol-value 'classname) "::" (symbol-value 'classname) "() \n{}\n
"(symbol-value 'classname) "::~" (symbol-value 'classname) "() \n{}\n
"(symbol-value 'classname) "::" (symbol-value 'classname) "(const " 
(symbol-value 'classname) "& i)\n{}\n
"(symbol-value 'classname) "& " (symbol-value 'classname) "::operator=(const " 
(symbol-value 'classname) "& rhs)
{
 if (this != &rhs)
    {
     
    }\n
 return *this;
}\n\n

// Overloaded stream operators:
std::ostream & operator<< (std::ostream & O, const " (symbol-value 'classname) " & o)
{
 // O << o.print() << std::endl;
 // O << o.m_data_ << std::endl; // If std::ostream is declared a 'friend'
 return O;
}
\n"
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

;; Insert class statement:
(defun insert-class (&optional classname)
  "Add a new class description"
  (interactive)
  (if (not classname)
      (setq classname (read-string "Class name (or <ret> to use file name): ")))
  ;; If no classname given, user buffer name less the ending:
  (if (eq (length classname) 0) (setq classname (file-name-sans-extension (buffer-name))))  
  ;;
  (setq mangledhdr (insert-mangled-header-guard classname))
  (insert
   "#ifndef " (format "%-20s" mangledhdr) "\n"
   "#define " (format "%-20s" mangledhdr) "\n"
   "\n"
   "#include <iosfwd>\n"
   "\n// New class declaration:"
   "\nclass " classname
   " {"
   "\npublic:"
   "\n" (format "  %-30s" (concat classname "();"))
   "\n" (format "  %-30s" (concat "~" classname "();"))
   "\n"
   "\n" (format "  %-30s" (concat classname "(const " classname " & r);"))
   "\n" (format "  %-30s" (concat classname "& operator=(const " classname " & r);"))
   "\n\n   // Public methods:"
   "\n\n"
   "\nprotected:"
   "\n\n"
   "\nprivate:"
   "\n\n"
   "};\n"
   "\n"
   "// Operators:\n"
   "std::ostream & operator<< (std::ostream & O, const " classname " & b);"
   "\n\n#endif // " (format "%-20s" mangledhdr) "\n"
   ))
  
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

;; To insert a new compile command:
(defun insert-cc-compile-command (&optional compiler)
  (interactive)
  "Inserts a new compile-command block at end of file."
  (if (not compiler)
      (setq compiler (read-string "Compiler name: ")))
  (if (eq (length compiler) 0) (setq compiler cxxdefault))
  (end-of-buffer)
  (insert
   "//\n"
   "//")
   (save-buffer))

(defun c++-create-class()
  (interactive)
  "Create a new class in the current empty buffer."
  ;; First of all, add a simple file header:
  (c++-insert-file-header)
  (setq classname (file-name-sans-extension (buffer-name)))
  ;; Insert the package:
  (insert-class classname)
  (message "New class (%s) created!" classname)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
(add-hook 'c++-mode-hook
	  (function (lambda ()
		      (require 'easymenu)
		      (easy-menu-define cpp-menu c++-mode-map "C++ Menu"
			'("Insert"
			  ["New Class Templates" new-class-templates t]
			  "---"
			  ["Insert Class" insert-class t]
			  ["Insert Member Functions" insert-member-funcs t]
			  "---"
			  ["Insert System Header" system-include-header t]
			  ["Insert Local Header" local-include-header t]
			  ["Insert Header Guards" insert-c-in-c++-hdr-guards t]
			  "---"
			  ["Insert Compile Command" insert-cc-compile-command t]
			  ))
		      ;;
		      (define-key c++-mode-map "\C-m" 'newline-and-indent)
		      (define-key c++-mode-map "\C-cic" 'insert-class)
		      (define-key c++-mode-map "\C-cnc" 'new-class-templates)
		      (define-key c++-mode-map "\C-cmf" 'insert-member-funcs)
		      (define-key c++-mode-map "\C-csh" 'system-include-header)
		      (define-key c++-mode-map "\C-clh" 'local-include-header)
		      (define-key c++-mode-map "\C-ccc" 'insert-cc-compile-command))))
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
