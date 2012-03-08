;;
;; cust-cc-faces.el --- Improved regular expressions for C++ font locking.
;;
(let* ((keywords
	(eval-when-compile
	  (concat
	   "\\<\\("
	   (regexp-opt
	    '("asm" "break" "case" "catch" "class" "const_cast" "continue"
	      "default" "delete" "do" "dynamic_cast" "else" "enum" "false" "for"
	      "goto" "if" "namespace" "new" "operator" "private" "protected"
	      "public" "reinterpret_cast" "return" "sizeof" "static_cast"
	      "struct" "switch" "template" "this" "throw" "true" "try" "typeid"
	      "typename" "union" "using" "while") t)
	   "\\)\\>")))
       (operators
	(eval-when-compile
	  (regexp-opt
	   '("+" "-" "*" "/" "%" "&" "|" "^" "~" "!" "=" "<" ">" "+=" "-=" "*="
	     "/=" "%=" "^=" "&=" "|=" "<<" ">>" "==" "!=" "<=" ">=" "&&" "||"
	     "++" "--" "->*" "->" "()" "[]" "and" "and_eq" "bitand" "bitor"
	     "or_eq" "or" "xor_eq" "xor" "not" "compl" "not_neq" "new" "new[]"
	     "delete" "delete[]"))))
       (specifiers
	(eval-when-compile
	  (concat
	   "\\<\\("
	   (regexp-opt
	    '("auto" "register" "static" "extern" "export" "mutable"
	      "friend" "typedef" "inline" "virtual" "explicit"
	      "const" "volatile" "restrict") t)
	   "\\)\\>")))
       (types
	`(mapconcat 'identity
	  (cons (,@ (eval-when-compile
		      (regexp-opt
		       '("char" "wchar_t" "bool" "short" "int" "long" "signed"
			 "unsigned" "float" "double" "void"))))
		    c++-font-lock-extra-types)
	  "\\|"))
       (template-args "[^,>\n]+\\(,[^,>\n]+\\)*")
       (template-params "[^,>\n]+\\(,[^,>\n]+\\)*")
       (opt-scope (concat "\\(\\sw+[ \t]*\\(<" template-params ">\\)?::\\)*"))
       (token (concat "\\sw+[ \t]*\\(<" template-params ">\\)?\\(::[ \t*~]*"
		      "\\sw+\\(<" template-params ">\\)?\\)*"))
       (return-value			; 9 groups
	(concat "^\\(\\sw+[ \t]+\\)?\\(\\sw+[ \t]+\\)?"
		"\\(" token "[ \t*&]*[ \t]+\\)?\\([*&]+[ \t]*\\)?"))
       (operator-name			; 8 groups
	(concat opt-scope "operator[ \t]*\\(" operators "\\|"
		"\\(\\sw+[ \t]+\\)?\\(\\sw+[ \t]+\\)?" token "[ \t*&]*\\)")))
  ;;
  (setq cust-c++-font-lock-keywords
	(list
	 ;;
	 ;; Fontify error directives.
	 '("^#[ \t]*error[ \t]+\\(.+\\)" 1 font-lock-warning-face prepend)
	 ;;
	 ;; Fontify filenames in #include directives as strings.
	 '("^#[ \t]*\\(include\\|import\\)[ \t]+\\(<[^>\"\n]*>?\\)"
	   2 font-lock-string-face)
	 ;;
	 ;; Fontify function-like macro names.
	 '("^#[ \t]*\\(define\\|undef\\)[ \t]+\\(\\sw+\\)("
	   2 font-lock-function-name-face)
	 ;;
	 ;; Fontify symbol names in #elif or #if ... defined preprocessor directives.
	 '("^#[ \t]*\\(elif\\|if\\)\\>"
	   ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
	    (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t)))
	 ;;
	 ;; Fontify otherwise as symbol names, and the preprocessor directive names.
	 '("^#[ \t]*\\(\\sw+\\)\\>[ \t]*\\(\\sw+\\)?"
	   (1 font-lock-reference-face) (2 font-lock-variable-name-face nil t))

	 ;;
	 ;; Fontity all type specifiers.
	 `(,specifiers 1 font-lock-type-face keep)
	 `(eval . (cons (concat "\\<\\(" (,@ types) "\\)\\>")
			'font-lock-type-face))
	 ;;
	 ;; Fontify all builtin keywords (except case, default and goto; see below).
	 `(,keywords 1 font-lock-keyword-face keep)
	 ;;
	 ;; Fontify case/goto keywords and targets, and case default/goto tags.
	 (list (concat "\\<\\(case\\|goto\\)\\>[ \t]*\\(-?" token "\\)")
	   2 'font-lock-reference-face nil t)
	 '(":" ("^[ \t]*\\(\\sw+\\)[ \t]*:\\($\\|[^:]\\)"
		(beginning-of-line) (end-of-line)
		(1 font-lock-reference-face)))
	 ;;
	 ;; Fontify structures, or typedef names, plus their items.
	 (list (concat "^[ \t]*}\\([ \t*]*\\(\\sw+\\)[ \t]*,?\\)+;")
	       2 'font-lock-function-name-face)
	 ;;
	 ;; Fontify global variables without a type.
	 '("^\\([_a-zA-Z0-9:~*]+\\)[ \t]*[[;={]" 1 font-lock-function-name-face)
	 ;;
	 ;; Fontify the names of functions being defined; this comes in two parts,
	 ;; first operators and then regular functions.  We assume that type specs
	 ;; are no more than 3 tokens.
	 (list (concat return-value "\\(" operator-name "\\)[ \t]*(")
	       10 'font-lock-function-name-face t)
	 (list (concat return-value "\\(" token "\\)[ \t]*(")
	       10 'font-lock-function-name-face)
	 ;;
	 ;; Fontify aggregates and enumerations
	 (list (concat "\\<\\(struct\\|union\\|enum\\|"
		       "\\(\\(virtual[ \t]+\\)?"
		       "\\(protected\\)"
		       "\\([ \t]+virtual\\)?\\([ \t]+typename\\)?\\)\\)"
		       "[ \t]+\\(" token "\\)[ \t]*[\n,:;{]")
	       7 'font-lock-function-name-face)
	 ;; Fontify numbers (use C++ preprocessing pp-number rule for simplicity)
	 '("\\<[+-]?\\.?[0-9]\\([0-9a-zA-Z_]\\|[eE][+-]\\)*\\>"
	   . 'font-lock-number-face)
	 '("::\\|:" . 'font-lock-warning-face))))

;; Add these keywords to font-lock-keywords:
(setq c++-font-lock-keywords-3 cust-c++-font-lock-keywords)

;;
;; End of cust-cc-faces.el
;;