;==============================================================================
; Dale's emacs init file.  27-Oct-1994
;
; PROBLEMS:
;  can not define Meta keys...
;
; TPU-emulation: (load "tpu-edt.elc")
;
; Color list on HP: /usr/lib/X11/rgb.txt
;
; GOOD COLOR SCHEME (from .Xdefaults):
; emacs*font:                 6x13
; emacs*Background:           tan
; emacs*geometry:             80x45
; emacs*foreground:           black
; emacs*iconName:             emacs
; emacs*cursorColor:          blue
; emacs*pointerColor:         blue
;
; To see a list of the defined faces: list-faces-display (!)
;
; 9-Jan-95 DSK added gt72col-face
;==============================================================================

; My favorite printer...
(setq lpr-switches '("-d545_prod"))

; Decide which major modes to use depending on the file suffix
(setq auto-mode-alist (cons '("\\.tex\\'" . latex-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bib\\'" . latex-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.car\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cra\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.inc\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.f.editing\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.c.editing\\'" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.for\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.F\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.FOR\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.f77\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.input\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ffr\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ffread\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.kumac\\'" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.emacs_mac\\'" . emacs-lisp-mode) auto-mode-alist))

;=========================== FAVORITE DEFAULTS ================================

; Show the line number
(line-number-mode 1)

; switch on X display of matching parentheses 
(load-library "paren")

; Use the keypad 7 and 8 keys to scroll
(define-key global-map [kp-7] 'scroll-down)
(define-key global-map [kp-8] 'scroll-up)

; Transient mark mode
(setq-default transient-mark-mode t)

; Goto line is cntl-c g now
(global-set-key "\C-cg" 'goto-line)

; Use regular expression searches
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-s" 'isearch-forward-regexp)

; Search forward is now also ctrl-f (ctrl-f is normally "forward-char")
(define-key global-map "\C-f" 'isearch-forward-regexp)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)

; Windows
(define-key global-map [S-mouse-1] 'delete-other-windows)
(define-key global-map [S-mouse-3] 'delete-window)

; Keys
(define-key global-map [kp-divide] 'Info-goto-emacs-key-command-node)
(define-key global-map [kp-multiply] 'Info-goto-emacs-command-node)
(define-key global-map [M-pause] 'Info-goto-emacs-key-command-node)
(define-key global-map [M-S-break] 'Info-goto-emacs-command-node)

; Replace functions
(define-key global-map [kp-0] 'query-replace)
(define-key global-map [kp-decimal] 'replace-string)

; Functions for using text mode
;(define-key global-map [C-kp-1] 'text-mode)

; Default insert
(global-set-key [?\C-#] 'insert-pound-space)
(global-set-key [?\C-%] 'insert-percent-space)
(global-set-key [?\C-*] 'insert-asterisk-space)
(global-set-key [?\C-\;] 'insert-semicolon-space)

; font-lock-mode stuff
(define-key global-map [f7] 'list-faces-display)
(define-key global-map [f8] 'font-lock-fontify-buffer-general)

; general stuff
(define-key global-map [f9] 'insert-pound-space)
(define-key global-map [f10] 'insert-2spaces)
(define-key global-map [f11] 'delete-2chars)
(define-key global-map [f12] 'insert-Cspace)
(define-key global-map [kp-1] 'insert-pound-space)
(define-key global-map [kp-2] 'insert-2spaces)
(define-key global-map [kp-3] 'delete-2chars)

; switch on auto-fill mode
(add-hook 'text-mode-hook
  '(lambda ()
     (if 
	 (not 
	  (or (eq major-mode 'latex-mode) (eq major-mode 'html-mode) ))
	 (setq font-lock-keywords my-text-font-lock-keywords))
     (auto-fill-mode 1)
   )
)

;******************************************************************************
;                          M A J O R   M O D E S                              *
;******************************************************************************

;============================= FUNDEMENTAL ====================================

;***  (make-face-unbold 'bold) ; NOT ON HPPLUS

  (set-face-background 'region "Grey80")
  (set-face-background 'highlight "yellow")
  (set-face-foreground 'highlight "red")
  (set-face-foreground 'italic "brown")
  (set-face-foreground 'bold "purple4")
; underline face is used for strings in strings, except in fortran
  (set-face-underline-p 'underline nil)
  (set-face-foreground 'underline "red")
; for strings in fortran
  (make-face 'string-face)
  (set-face-foreground 'string-face "red")
; face for $(...)
  (make-face 'eval-face)
  (set-face-foreground 'eval-face "blue2")
; YIKES
  (make-face 'yikes-face)
  (set-face-foreground 'yikes-face "black")   
  (set-face-background 'yikes-face "cyan")  
; extra spaces (i.e. in a makefile)
  (make-face 'extra-spaces-face)
  (set-face-foreground 'extra-spaces-face "black")   
  (set-face-background 'extra-spaces-face "green")  

(defconst my-general-font-lock-keywords
  '(
   ;; echo lines in scripts
   ("echo" 0 'message-face t)
   ;; comments in scripts -- do before strings
   ("^ *#.*$" 0 font-lock-comment-face t)
   ;; faces for strings in quotes
   ;; ?? ("[^#\n]*\\(\"[^\"]*\"\\)" 0 'string-face t)
   ;; for double-quote: 't' needed to handle default string def
   ("\"[^\"]*\"" 0 'string-face t)
   ; ?? ("[^\\]*\"\\([^\"]\\|\\\"\\)*[^\\]\"" 0 'string-face t)
   ;; for single quote:  no 't' --> this will not include comments  
   ("'[^']*'" 0 'string-face)  
   ;; strings for the shell to evaluate
   ("`.*`" 0 'eval-face t)
   ("\$([^\n)]*)" 0 'eval-face t)
   ;; comments in scripts -- do before strings
   ("^ *#.*$" 0 font-lock-comment-face t)
   ;; comments: (line must have the string "*", "C" or "c" in the first column)
   ;;("^\\(\\*\\|C \\|c \\).*$" 0 font-lock-comment-face t)
   ("^\\(\\*\\|C\\).*$" 0 font-lock-comment-face t)
   ;;fatman/dadlist lines
   ("^\\*\\(\\|FAT\\|DAD\\|FILE\\|READ\\|fat\\|dad\\|file\\|read\\).*$" 0 'eval-face t)
   ;; Yikes
   ("^.*[Yy][Ii][Kk][Ee][Ss].*$" 0 'yikes-face t)
   ("^.*[Yy][IiKeEe]+[IiKeEe]+[Ss].*$" 0 'yikes-face t)
   ("\\?\\?+" 0 'yikes-face t)
   ("^  *\t" 0 'extra-spaces-face t)
   ("\\\\$" 0 'backslash-eol-face)
   ("\\\\  *$" 0 'extra-spaces-face t)
   )
 "Dale's definition of specific character strings to be highlighted."
)

;========================== FORTRAN AND C MODE ================================

; face for INCLUDE statements
  (make-face 'include-face)
  (set-face-foreground 'include-face "blue2")
; face for EXTERNAL statements
  (make-face 'external-face)
  (set-face-foreground 'external-face "blue4")
; face for IMPLICIT statements
  (make-face 'implicit-face)
  (set-face-foreground 'implicit-face "purple4")
  (set-face-underline-p 'implicit-face 1)
; face for SWITCH statements
  (make-face 'switch-face)
  (set-face-foreground 'switch-face "purple4")
  (set-face-underline-p 'switch-face 1)
; face for precompiler commands
  (make-face 'precompiler-face)
  (set-face-foreground 'precompiler-face "DarkGreen")
; face for variable types
  (make-face 'variable-type-face)
  (set-face-foreground 'variable-type-face "DeepPink")
; face for new patchy patches
  (make-face 'patch-face)
  (set-face-foreground 'patch-face "black")   
  (set-face-background 'patch-face "green")  
; PAW: messages/itx
  (make-face 'message-face)
  (set-face-foreground 'message-face "DeepPink")
; PAW: plot options
  (make-face 'option-face)
  (set-face-foreground 'option-face "aquamarine4")
; end-of-line "\"
  (make-face 'backslash-eol-face)
  (set-face-foreground 'backslash-eol-face "red")   
; <72 columns
  (make-face 'gt72col-face)
  (set-face-background 'gt72col-face "white")   
  
;============================= FORTRAN MODE ===================================

(setq-default fortran-do-indent 2)
(setq-default fortran-if-indent 2)
(setq-default fortran-blink-matching-if t)
(setq-default fortran-electric-line-number nil)
(setq-default fortran-line-number-indent 4)
(setq-default fortran-continuation-string "+")
(setq-default fortran-continuation-indent 2)

(add-hook 'fortran-mode-hook
  (function (lambda ()

    (fortran-auto-fill-mode 1)

    ;; It takes too long to fontify long fortran files...  use F8 when desired.
    ;; (font-lock-mode 1)
    (make-local-variable 'font-lock-keywords)
    (setq font-lock-keywords my-fortran-font-lock-keywords)

    ;; Do not use the default fortran string highlighting, since it does not
    ;; handle unmatched quotes which are on a comment line! 
    (make-local-variable 'font-lock-string-face)
    (setq font-lock-string-face "default-face")

    (define-key fortran-mode-map [kp-1] 'insert-Cspace)
    (define-key fortran-mode-map [kp-2] 'insert-2spaces)
    (define-key fortran-mode-map [kp-3] 'delete-2chars)
    (define-key fortran-mode-map [kp-4] 'end-of-fortran-subprogram)
    (define-key fortran-mode-map [kp-5] 'beginning-of-fortran-subprogram)
    (define-key fortran-mode-map [kp-6] 'insert-asterisk-space)
    (define-key fortran-mode-map [kp-9] 'search-gt72-columns)
    (define-key fortran-mode-map [f8] 'font-lock-fontify-buffer-fortran)
    (define-key fortran-mode-map [f9] 'insert-Cspace)
    (define-key fortran-mode-map [f10] 'insert-2spaces)
    (define-key fortran-mode-map [f11] 'delete-2chars)
    (define-key fortran-mode-map [f12] 'fortran-auto-fill-mode)
    (define-key fortran-mode-map [C-return] 'fortran-split-line)

    ;; It takes too long to fontify long fortran files...  use F8 when desired.
    ;; (font-lock-fontify-buffer)
  )))

(defconst my-fortran-font-lock-keywords
  '(
   ;; faces for strings: Do NOT match across a newline!
   ("'[^'\n]*'" 0 'string-face t)
   ;; faces for variable declarations
   ("^ *\\(INTEGER\\|REAL\\|CHARACTER\\|LOGICAL\\|[Ii]nteger\\|[Rr]eal\\|[Cc]haracter\\|[Ll]ogical\\).*$" 0 'variable-type-face t)
   ;; face for the subprogram names
   ("^ *\\(.*FUNCTION [a-zA-Z0-9_]*\\|SUBROUTINE [a-zA-Z0-9_]*\\|PROGRAM [a-zA-Z0-9_]*\\|ENTRY [a-zA-Z0-9_]*\\|[a-zA-Z0-9_]*function [a-zA-Z0-9_]*\\|subroutine [a-zA-Z0-9_]*\\|program [a-zA-Z0-9_]*\\|entry [a-zA-Z0-9_]*\\).*$" 1 'title-face t)
   ("^\\(+deck\\|+DECK\\).*$" 0 'title-face t)
   ("^\\([Mm][Aa][Cc][Rr][Oo] [^ ]*\\).*$" 1 'title-face t)
   ;; face for the start of a new patch
   ("\\(+patch\\|+PATCH\\).*$" 0 'patch-face t)
   ;; use include-face for common and data statements
   ("^ *\\(COMMON\\|common\\) */.*/" 0 'include-face t)
   ("^ *\\(DATA\\|data\\) " 0 'include-face t)
   ;; external/save/parameter statements
   ("^ *\\(EXTERNAL\\|external\\|SAVE\\|save\\|PARAMETER\\|parameter\\).*$" 0 'external-face t)
   ;; implicit statements
   ("^ *\\(IMPLICIT.*$\\|implicit.*$\\|+SEQ,DECLARE\\|+seq,declare\\)" 1 'implicit-face t)
   ;; >72 columns
   ("^[^Cc*]....................................................................... *\\(.*\\)$" 1 'gt72col-face t)
   ;; comments: (line must have the string "*", "C" or "c" in the first column)
   ("^\\(\\*\\|C\\|c\\).*$" 0 font-lock-comment-face t)
   ;; comments at end-of-line using exclamation mark
   ("![ a-z0-9A-Z._%&|:;<>/\\()=+*-]*$" 0 font-lock-comment-face t)
   ;; comments in paw: (line must have the string "*" preceeded only by spaces)
   ("^ *\\*.*$" 0 font-lock-comment-face t)
   ;;fatman/dadlist lines
   ("^\\*\\(FAT\\|DAD\\|FILE\\).*$" 0 'include-face t)
   ;; precompiler statements (start with a # as the first non-blank)
   ("^ *#.*$" 0 'precompiler-face t)
   ;; faces for include statements
   ("^ *\\(INCLUDE\\|[#]*include\\|+seq\\|+SEQ\\|+keep\\|+KEEP\\).*$" 0 'include-face t)
   ;; faces +self patchy comments
   ("^ *\\(+self\\.\\|+SELF\\.\\).*$" 0 'comment-face t)
   ;; for PAW kumacs
   ("^ *\\(SET \\|OPT \\|IGSET \\|set \\|opt \\|igset \\).*$" 0 'option-face t)
   ("^ *\\([Mm]essage \\|MESSAGE \\|ITX \\|itx \\).*$" 0 'message-face t)
   ("^ *[Ss][Hh][Ee][Ll][Ll] .*$" 0 'include-face t)
   ;; YIKES face -- warning of something to look out for
   ("^.*[Yy][Ii][Kk][Ee][Ss].*$" 0 'yikes-face t)
   ("\\?\\?+" 0 'yikes-face t)
   ("MPC_" 0 'yikes-face t)
   )
 "Dale's definition of specific character strings to be highlighted in fortran"
)

;=============================== C MODE =======================================

(add-hook 'c-mode-hook
  (function (lambda ()
    (setq c-font-lock-keywords my-c-font-lock-keywords)
    (define-key c-mode-map [f8] 'font-lock-fontify-buffer-c)
    (define-key c-mode-map [f9] 'insert-c-comment)
    (define-key c-mode-map [f10] 'insert-2spaces)
    (define-key c-mode-map [f11] 'delete-2chars)
    (define-key c-mode-map [f12] 'font-lock-fontify-buffer)
    (font-lock-mode 1)

  )))

(defconst my-c-font-lock-keywords
  '(
   ;; precompiler statements (start with a # in the first column)
   ("^ *#.*$" 0 'precompiler-face t)
   ;; precompiler statements (start with a # in the first column)
   ("^#include.*$" 0 'include-face t)
   ;; faces for variable declarations
   ("^ *\\(extern\\|static\\).*$" 0 'variable-type-face t)
   ("^ *\\(int\\|double\\|long\\|short\\|float\\|char\\|struct\\|void\\|unsigned\\|FILE\\) .*; *$" 0 'variable-type-face t)
   ;; switch statements
   ("\\(switch\\|case.*:\\|break\\|default.*:\\)" 0 'switch-face f)
   ;; subprograms - can span a line break (do not end with a ;)
   ("^\\(static \\)*\\(\\int .*\\|main .*\\|double .*\\|char .*\\|void .*\\) *(" 2 'title-face t)
   ;; subprogram declarations - can span a line break (end with a ;)
   ;; (this must come after the subprogram line 
   ("^\\(static \\)*\\(\\int .*\\|main .*\\|double .*\\|char .*\\|void .*\\) *([^;)]*) *;$" 2 'variable-type-face t)
   ;; YIKES face -- warning of something to look out for
   ("^.*[Yy]\\(IKES\\|ikes\\).*$" 0 'yikes-face t)
   ("\\?\\?+" 0 'yikes-face t)
   )
 "Dale's definition of specific character strings to be highlighted in c"
)
   

;============================== TCL MODE ======================================

(add-hook 'tcl-mode-hook
  (function (lambda ()
    (define-key c-mode-map [f8] 'font-lock-fontify-buffer-tcl)
    (make-local-variable 'font-lock-keywords)
    (setq font-lock-keywords my-tcl-font-lock-keywords)
    (font-lock-mode 1)
  )))
   
(defconst my-tcl-font-lock-keywords
  '(
   ;; new processes
     ("^ *proc .*$" 0 'title-face t)
   ;; for global variables
     ("^ *global .*$" 0 'include-face t)
   ;; YIKES face -- warning of something to look out for
     ("^.*[Yy]\\(IKES\\|ikes\\).*$" 0 'yikes-face t)
     ("\\?\\?+" 0 'yikes-face t)
     ("\\\\  *$" 0 'extra-spaces-face t)
   )
 "Dale's definition of specific character strings to be highlighted in TCL"
)
;============================= LATEX MODE =====================================
; face for begin/end commands
  (make-face 'tex-begin-end-face)
  (set-face-foreground 'tex-begin-end-face "DeepPink3")
; face for newcommand commands
  (make-face 'tex-newcommand-face)
  (set-face-foreground 'tex-newcommand-face "DarkGreen")
; face for citations
  (make-face 'tex-cite-face)
  (set-face-foreground 'tex-cite-face "blue2")
; face for label/references
  (make-face 'tex-label-face)
  (set-face-foreground 'tex-label-face "aquamarine4")
; face for section titles
  (make-face 'title-face)
  (set-face-foreground 'title-face "blue4")   
  (set-face-background 'title-face "yellow")  
; footnotes
  (make-face 'footnote-face)
  (set-face-foreground 'footnote-face "purple")
; tex-problems
  (make-face 'tex-problems-face)
  (set-face-foreground 'tex-problems-face "black")   
  (set-face-background 'tex-problems-face "green")  
; doeument statements
  (make-face 'tex-document-face)
  (set-face-foreground 'tex-document-face "black")   
  (set-face-background 'tex-document-face "green")  
; face for \index statements
  (make-face 'tex-index-face)
  (set-face-foreground 'tex-index-face "purple4")
  (set-face-underline-p 'tex-index-face 1)
; face for \epsffile statements
  (make-face 'tex-epsffile-face)
  (set-face-foreground 'tex-epsffile-face "red")
  (set-face-underline-p 'tex-epsffile-face 1)

(add-hook 'LaTeX-mode-hook
  (function (lambda ()
    ; use my font-lock-keywords
      (make-local-variable 'font-lock-keywords)           ; hpplus
      (setq font-lock-keywords my-tex-font-lock-keywords) ; hpplus
      (make-local-variable 'font-lock-string-face)        ; hpplus
      (setq font-lock-string-face "string-face")          ; hpplus
      (setq tex-font-lock-keywords my-tex-font-lock-keywords)
    ; define some keys
      (define-key LaTeX-mode-map [kp-1] 'insert-percent-space)
      (define-key LaTeX-mode-map [kp-2] 'insert-2spaces)
      (define-key LaTeX-mode-map [kp-3] 'delete-2chars)
      (define-key LaTeX-mode-map [kp-4] 'tab)
      (define-key LaTeX-mode-map [kp-5] 'fig)
      (define-key LaTeX-mode-map [f8] 'font-lock-fontify-buffer)
      (define-key LaTeX-mode-map [f9] 'insert-percent-space)
      (define-key LaTeX-mode-map [f10] 'insert-2spaces)
      (define-key LaTeX-mode-map [f11] 'delete-2chars)
      (define-key LaTeX-mode-map [f12] 'font-lock-fontify-buffer)
    ; turn on font-lock mode
      (font-lock-mode 1)
    ; set strings (used for math mode) to be red          ;; HPPLUS ONLY
      (set-face-foreground 'font-lock-string-face "red")  ;; HPPLUS ONLY
    ; be sure the keyword-face (all \xxx) is not bold     ;; HPPLUS ONLY
      (make-face-unbold 'font-lock-keyword-face)          ;; HPPLUS ONLY
    ; turn on autofill
      (auto-fill-mode 1)
  )))
   
; Define specific character strings (keywords) to be highlighted in TeX mode
; (the order in which these are applied is from top to bottom!)
(defconst my-tex-font-lock-keywords
  '(
   ;; footnotes
     ("footnote *{\\([^}]*\\)}" 1 'footnote-face keep)
   ;; titles of section, etc.
      ("^\\\\\\([Ss]ection\\|[Ss]ubsection\\|[Ss]ubsubsection\\|part\\|chapter\\)" 0 'title-face) 
      ("^\\\\\\(documentstyle\\|begin{document}\\|end{document}\\).*$" 0 'tex-document-face) 
   ;; index statements
     ("\\\\index{[^}]*}" 0 'tex-index-face)
   ;; verbatim sections in color! (this will not work if it has a \ in it)
     ("\\\\begin{verbatim}\\([^\\]*\\)\\\\end{verbatim}" 1 'tex-begin-end-face)
   ;; arguments of \begin and \end statements
     ("\\\\\\(begin\\|end\\){\\([a-zA-Z0-9\\*]+\\)}" 2 'tex-begin-end-face)
   ;; arguments of \epsffile statements
     ("\\\\epsffile{\\([./_a-zA-Z0-9\\*\\-]+\\)}" 1 'tex-epsffile-face)
   ;; arguments of \tex-newcommand statements
     ("\\\\newcommand *{\\([a-zA-Z0-9\\*]+\\)}" 1 'tex-newcommand-face)
   ;; new commands defined in a "\def" 
     ("^[ \t\n]*\\\\def[\\\\@]\\(\\w+\\)" 1 'tex-newcommand-face)
   ;; arguments of \ref and \label statements
     ("\\\\\\(ref\\|label\\){\\([:_a-zA-Z0-9\\*\\-]+\\)}" 2 'tex-label-face)
   ;; arguments of \cite statements
     ("\\\\\\(cite\\){\\([^}]*\\)}" 2 'tex-cite-face)
   ;; mathmode text (i.e. enclosed within "$  $") 
   ;;  do not include \$ characters
     ("\\(^\\|[^\\]\\)\\$\\([^$]*[^\\]\\)\\$" 2 'string-face)
   ;; all tex commands (beginning with "\")
     ("\\(\\\\\\([a-zA-Z@]+\\|.\\|$\\)\\)" 1 font-lock-keyword-face)
   ;; YIKES face -- warning of something to look out for
     ("^.*[Yy]\\(IKES\\|ikes\\).*$" 0 'yikes-face t)
     ("\\?\\?+" 0 'yikes-face t)
   ;; underscores without a backslash - common tex problem!
     ("[^\\]\\(_\\)" 1 'tex-problems-face)
     ("\\\\being" 0 'tex-problems t)
   )
 "My definition of specific character strings to be highlighted in LaTeX"
)

;============================== LISP MODE =====================================

(add-hook 'emacs-lisp-mode-hook
  (function (lambda ()
    (make-local-variable 'font-lock-string-face)        ; hpplus
    (setq font-lock-string-face "string-face")          ; hpplus
    (define-key emacs-lisp-mode-map [kp-1] 'insert-semicolon-space)
    (define-key emacs-lisp-mode-map [kp-2] 'insert-2spaces)
    (define-key emacs-lisp-mode-map [kp-3] 'delete-2chars)
    (define-key emacs-lisp-mode-map [f8] 'font-lock-fontify-buffer)
    (define-key emacs-lisp-mode-map [f9] 'insert-semicolon-space)
    (define-key emacs-lisp-mode-map [f10] 'insert-2spaces)
    (define-key emacs-lisp-mode-map [f11] 'delete-2chars)
    (define-key emacs-lisp-mode-map [f12] 'font-lock-fontify-buffer)
    ;; turn on font-lock-mode
      (font-lock-mode 1)
    ;; set font-lock faces AFTER starting font-lock-mode              ;; HPPLUS ONLY
      (set-face-foreground 'font-lock-string-face "red")              ;; HPPLUS ONLY
      (set-face-foreground 'font-lock-keyword-face "blue2")           ;; HPPLUS ONLY
      (set-face-foreground 'font-lock-variable-name-face "DeepPink3") ;; HPPLUS ONLY
  )))

;============================== HTML MODE =====================================
; face for <html>,<head>,<body> statements
 (make-face 'html-head-face)
 (set-face-foreground 'html-head-face "aquamarine4")
; face for <title> statements
 (make-face 'html-title-face)
 (set-face-foreground 'html-title-face "black")
 (set-face-background 'html-title-face "green")
; face for sections
 (make-face 'html-section-face)
 (set-face-foreground 'html-section-face "black")
 (set-face-background 'html-section-face "yellow")
; face for <A...> statements
 (make-face 'html-hot-face)
 (set-face-foreground 'html-hot-face "blue2")
; face for <...> statements
 (make-face 'html-command-face)
 (set-face-foreground 'html-command-face "blue4")
; face for <p> statements
 (make-face 'html-return-face)
 (set-face-foreground 'html-return-face "red")
;
; html-mode adds tons of built-in functionality - click the right mouse 
; button to see.
;
(add-hook 'html-mode-hook
  '(lambda ()
    ;; use my font-lock-keywords
      (setq html-font-lock-keywords my-html-font-lock-keywords)
    ;; redefine < and > to be their normal meanings (not the html
    ;; versions: &lt; and &gt;)
      (local-set-key "<" 'self-insert-command)     
      (local-set-key ">" 'self-insert-command)  
    ;; define a f-key to list the faces 
      (define-key html-mode-map [f8] 'font-lock-fontify-buffer-html)
      (define-key html-mode-map [f12] 'list-faces-display)
    ;; turn on font-lock-mode
      (font-lock-mode 1)
    ;; change some of the default faces
      (set-face-foreground 'font-lock-string-face "DeepPink3")
      (set-face-underline-p 'font-lock-string-face nil)
      (set-face-foreground 'font-lock-comment-face "brown")
   ))
(defconst my-html-font-lock-keywords
  '(
   ;; Comments
     ("\\(<![^>]*>\\)+" 0 font-lock-comment-face)
   ;; returns
     ("<[Pp]>" 0 'html-return-face)
     ("<[Bb][Rr]>" 0 'html-return-face)
   ;; hot regions (clickable)
     ("<[Aa][^>\n]*>" 0 'html-hot-face)
   ;; title
     ("<[Tt][Ii][Tt][Ll][Ee]>[^>\n]*</[Tt][Ii][Tt][Ll][Ee]>" 0 'html-title-face)
   ;; sections
     ("<[Hh][1]>[^>\n]*</[Hh][1]>" 0 'html-section-face)
   ;; <html>,<head>,<body> statements
     ("<[/]*\\([Hh][Tt][Mm][Ll]\\|[Hh][Ee][Aa][Dd]\\|[Bb][Oo][Dd][Yy]\\)>" 0 'html-head-face)
   ;; commands
     ("<[^!][^>\n]*>" 0 'html-command-face)
   ;; Strings
     ("[Hh][Rr][Ee][Ff]=\"\\([^\"]*\\)\"" 1 font-lock-string-face t)
     ("[Ss][Rr][Cc]=\"\\([^\"]*\\)\"" 1 font-lock-string-face t)
   ;; YIKES face -- warning of something to look out for
     ("^.*[Yy]\\(IKES\\|ikes\\).*$" 0 'yikes-face t)
     ("\\?\\?+" 0 'yikes-face t)
   )
 "Dale's definition of specific character strings to be highlighted in html"
)

;============================== FUNCTIONS =====================================

(defun tab ()
   "get my table.tex"
   (interactive)
   (insert-file "/u/ws/koetke/tex/tools/table.tex"))
(defun fig ()
   "get my figure.tex"
   (interactive)
   (insert-file "/u/ws/koetke/tex/tools/table.tex"))

(defun font-lock-fontify-buffer-general ()
   "fontify the buffer using the general font-lock setup"
   (interactive)
   ;; Do not use the default fortran string highlighting, since it does not
   ;; handle unmatched quotes which are on a comment line! 
   (make-local-variable 'font-lock-string-face)
   (setq font-lock-string-face "default-face")
   ;; Start up font-lock
   (font-lock-mode 1)
   (setq font-lock-keywords my-general-font-lock-keywords)
   (font-lock-fontify-buffer) 
)

(defun font-lock-fontify-buffer-fortran ()
   "fontify the buffer using the fortran font-lock setup"
   (interactive)
   (font-lock-mode 1)
   (setq font-lock-keywords my-fortran-font-lock-keywords)
   (font-lock-fontify-buffer) 
)

(defun font-lock-fontify-buffer-c ()
   "fontify the buffer using the c font-lock setup"
   (interactive)
   (font-lock-mode 1)
   (setq font-lock-keywords my-c-font-lock-keywords)
   (font-lock-fontify-buffer) 
)

(defun font-lock-fontify-buffer-tcl ()
   "fontify the buffer using the tcl font-lock setup"
   (interactive)
   (font-lock-mode 1)
   (setq font-lock-keywords my-tcl-font-lock-keywords)
   (font-lock-fontify-buffer) 
)

(defun insert-percent-space ()
   "insert percent and space at the start of line, then go to next line"
   (interactive)
   (beginning-of-line 1)
   (insert "\% ")
   (beginning-of-line 2)
)

(defun insert-pound-space () "insert pound-sign and space at the start
   of line, then go to next line" (interactive) (beginning-of-line 1)
   (insert "\# ") (beginning-of-line 2) )

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
 
; functions for accessing opal cards/cradles files...

(defun bt ()
   "edit the most recent bt production cards file"
   (interactive)
   (find-file "/opal_code/rope/pro/car/bt110.car"))

(defun id ()
   "edit the most recent id production cards file"
   (interactive)
   (find-file "/opal_code/rope/pro/car/id112.car"))

(defun ocar ()
   "select the most recent production cards files"
   (interactive)
   (find-file "/opal_code/rope/pro/car/"))
(defun ocarold ()
   "select the most recent dev cards files"
   (interactive)
   (find-file "/opal_code/rope/old/car/"))
(defun ocardev ()
   "select the most recent dev cards files"
   (interactive)
   (find-file "/opal_code/rope/dev/car/"))

(defun ocra ()
   "select the most recent production cradles"
   (interactive)
   (find-file "/opal_code/rope/pro/car/"))
(defun ocraold ()
   "select the most recent dev cradles"
   (interactive)
   (find-file "/opal_code/rope/old/cra/"))
(defun ocradev ()
   "select the most recent dev cradles"
   (interactive)
   (find-file "/opal_code/rope/dev/cra/"))

;==============================================================================
;
;  WORKING EXAMPLES:
;
;(global-set-key "\C-z" 'insert-pound-space)
;(global-set-key [?\C-3] 'insert-pound-space)
;(global-set-key [?\C-#] 'insert-pound-space)

