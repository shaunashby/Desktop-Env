This buffer is for notes you don't want to save, and for Lisp evaluation.
If you want to create a file, visit that file with C-x C-f,
then enter the text in that file's own buffer.

(defun insert-class (&optional classname)
  "Add a new class description"
  (interactive)
  (setq classname (read-string "Class name: "))
  (insert 
   "\n#ifndef " (format "%-20s" (concat (upcase classname) "_H"))
   "\n#define " (format "%-20s" (concat (upcase classname) "_H"))
   "\n"
   "\n// Define a new class:"
   "\nclass " (format "%-20s" classname)
   "\n{"
   "\npublic:                          // Public parts"
   "\n" (format "   %-30s" (concat classname "();")) "// Default constructor"
   "\n" (format "   %-30s" (concat "~" classname "();")) "// Default destructor"
   "\n\n   // Public methods"
   "\n\n\n\n"
   "\nprivate:                         // Private parts"
   "\n\n\n\n"
   "\nprotected:                       // Protected parts"
   "\n\n"
   "\n};"
   "\n\n#endif\n"
   ))

;;;;;;;;;;;
(if (string-match "\\.el$" (file-name-nondirectory buffer-file-name))   
    (cond ((not (file-exists-p (buffer-file-name))) 
	   (message "File does not exist: ")))
(message "File exists: "))



(defun munge-text ()
  (interactive)
  (shell-command-on-region (region-beginning)
                           (region-end)
                           "sed -e 's@a@X@g'"
                           current-prefix-arg
                           current-prefix-arg))

(defun run-blah-command-on-region-display-other-window (begin end)
  "Run the hardcoded \"my_command\" on the region, display in other window."
  (interactive "r") ; automatically gets the start and end of the region for you
  (let* 
      ( (my_command "sort")  ; the hardcoded command
        (region-text (buffer-substring begin end))
        (run-command-temp-file 
         (make-temp-name        ; the pre-Gnu emacs 21 compatible method 
          (expand-file-name "run-command-on-region-display-other-window"
                            temporary-file-directory)))
        (original-buffer (current-buffer)))

    ; stash copy of region in temp file
    (find-file run-command-temp-file)
    (insert region-text)
    (basic-save-buffer)
    (kill-buffer (current-buffer))
    
    ; frame should display only original current buffer and the new output window
    (switch-to-buffer original-buffer)
    (delete-other-windows)
    (split-window-vertically)
    (other-window 1)
    (switch-to-buffer "*output my_command*")

    ; blank out any old stuff in the output buffer
    (mark-whole-buffer)
    (delete-region (mark) (point))

    (insert 
     (shell-command-to-string 
      (concat my_command " " (shell-quote-argument run-command-temp-file))
      ))

    ; clean-up
    (set-mark-command (point)) ; want to deactivate region
    (other-window 1)
    (delete-file run-command-temp-file)
    ))


(defun bfprocess (&optional d)
  (interactive)
  ;; Replace with group name:
  (while (re-search-forward ".*?ifdef GROUP_\\(.*\\)" nil t)
    (replace-match "<define_group name=\\1>" nil nil))
  (goto-line 1)
  ;; Replace all other closing tags with nothing:
  (while (re-search-forward "</lib>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  (while (re-search-forward "</external>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  (while (re-search-forward "</group>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  (while (re-search-forward "</use>" nil t)
    (replace-match "" nil nil))
  (goto-line 1)
  ;; Close the group definition:
  (while (re-search-forward ".?[e][n][d][i][f].?" nil t)
    (replace-match "</define_group>" nil nil))
  (goto-line 1)
  )

(defun cms-file-directory (&optional filename)
  "*Return the directory part of the FILENAME with links chased."
  (setq filename (or (and filename (file-name-directory
				    (file-chase-links filename)))
		     default-directory))
  (if (not (file-directory-p filename))
      (file-name-directory filename)
    filename))

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

(defun cms-search-file (indicator &optional filename)
  "*Search for INDICATOR starting from FILENAME and return the path found."
  (concat
   (car (cms-search-file-engine indicator (cms-file-directory filename)))
   indicator))




(setq scram-admindir ".SCRAM")

(defun find-localtop (&optional top)
  "*Find LOCALTOP from the current directory. Access the car() of the return."
  (interactive)
  ;; Start with current dir obtained from PWD environment
  ;; variable. Set localtop to empty string:
  (setq localtop "") 
  (setq startdir (concat (getenv "PWD") "/"))
  ;; Continue until the string for the dir is empty:
  (while (not (equal startdir ""))
    ;; See if .SCRAM dir exists from current location:
    (if (file-directory-p (concat startdir scram-admindir))
	(setq localtop startdir)
      )
    ;; Do a match to get the directory name less the last directory:
    (string-match "\\([a-zA-Z0-9_-\.]*$\\|[a-zA-Z0-9_\.-]*/$\\)" startdir)
    (setq startdir (substring startdir 0 (match-beginning 0)))
    )
  (cons localtop nil)
  )


(setq top (find-localtop))
(car top)
(cdr top)

(setq data (cms-search-file-engine ".SCRAM" (getenv "PWD")))

(car data)
(cdr data)


(setq topdir "/home/sashby/work/Projects/TESTING_1.0")
(setq f (cms-search-file-engine "config" topdir))

(car f)
(cdr f)


(file-name-directory buffer-file-name)

;; Create package function:

(defun create-package(&optional name)
"Create a new SCRAM package"
(interactive)
(setq name (read-string "Package name: "))
(setq currentdir (
)


(defun create-package-buildfile(&optional dir)
  "Create a BuildFile for the current package"
  (interactive)
  (setq dir (read-string "Install dir: "))
  (if (string-match "BuildFile$" (file-name-nondirectory buffer-file-name))
      (cond ((not (file-exists-p (buffer-file-name))) 
	     (message "File does not exist: ")))
    (message "BuildFile already exists!"))
  
;;  (get-buffer-create "BuildFile")
;;  (switch-to-buffer-other-frame "BuildFile")
  ;;  (insert "hello there!")
  )

(create-package-buildfile)
(file-name-directory buffer-file-name)

(defun show-package-root(&optional proot)
  "Show the root of the current package dir."
  (interactive)
  (setq proot (directory-file-name (file-name-directory (buffer-file-name))))
  (message "Root: %s" proot)
  )

(show-package-root)


(defun current-dir-name ()
"* Display the current dir name."
(interactive)
(message "Current dir = %s"  (buffer-file-name))
)

(current-dir-name)

(setq args "dummy-args-1")
(start-process "DUMMY" "BuildFile" "dummy.pl" args)

(defun create-bf-stub (&optional pname)
  "Create Buildfile stub using an external script."
  (interactive)
  (setq pname (read-string "Package name: " ))
  (call-process "dummy.pl" nil "BuildFile" nil pname)
  (switch-to-buffer-other-frame "BuildFile")
  )


(create-bf-stub)

(if (string-match "$" (file-name-nondirectory buffer-file-name))
    (message "test"))

(setq thing "testing")

(if (string-match "\\.el$" (file-name-nondirectory buffer-file-name))
    (message "found")
  (message "not found")
  )



(let ((home (getenv "HOME"))
      (basedir (getenv "LOCALRT"))
      (currentdir (getenv "PWD"))
      ))





(setq pnam "TESTER::TESTER")

(perl-start-pod-skeleton pnam)


(defun perl-end-pod-skeleton()
  (interactive)
  "Insert an end block for POD documentation."
  (search-forward "__END__\n")
  (insert 
   "\n"
   "=back\n"
   "\n"
   "=head1 AUTHOR/MAINTAINER\n"
   "\n"
   (user-full-name) " L<mailTo:" user-mail-address ">\n"
   "\n"
   "=cut\n"
   "\n"
   ))


(perl-start-pod-skeleton)

=head1 NAME


(defun cc-local-testfunc()
  "Function tests" 
  (interactive) 
  (get-buffer-create "DummyFuncTests")
  (switch-to-buffer-other-frame "DummyFuncTests")
  (insert "## ---- This is a function testing buffer ---- ##\n")
  ;; 
  ;;   (let* ((scram-dir (search-file ".SCRAM" (buffer-file-name)))
  ;; 	 (root-dir  (and scram-dir (file-name-directory scram-dir)))
  ;; 	 (base      (and root-dir (file-name-nondirectory
  ;; 				   (directory-file-name root-dir))))
  ;; 	 (project   (and root-dir (substring base 0 (string-match "_" base)))))
  ;;     (if root-dir
  ;; 	(progn
  ;; 	  (make-local-variable 'test-base)
  ;; 	  (setq
  ;; 	   test-base		(concat root-dir "src")))
  ;;       (insert "BASE: " test-base))
  ;;     )
  ;;
  (setq filename "/afs/cern.ch/user/s/sashby/DUMMY/src/PK1/interface/TT.h")
  (setq startdir (search-file ".SCRAM" filename))
  (message "Starting from dir: %s" startdir)
  (string-match "\\([a-zA-Z0-9_-\.]*$\\|[a-zA-Z0-9_\.-]*/$\\)" startdir)
  (setq startdir (substring startdir 0 (match-beginning 1)))
  (insert startdir)
  )

(cc-local-testfunc)



(setq filename "/afs/cern.ch/user/s/sashby/DUMMY/src/PK1/interface/TT.h")
(setq startdir (search-file ".SCRAM" filename))


(string-match "\\([a-zA-Z0-9_-\.]*$\\|[a-zA-Z0-9_\.-]*/$\\)" startdir)
(setq idx (string-match "\\([a-zA-Z0-9_-\.]*$\\|[a-zA-Z0-9_\.-]*/$\\)" startdir))


(setq startdir (substring startdir 0 (match-beginning 1)))


(substring startdir 0 (match-end 1))


(defun is-scram-project ()
  "Determine whether the current area is a SCRAM project area."
  (setq found (search-file ".SCRAM" (buffer-file-name)))
  (if (file-directory-p found)
      (cons found nil)
    (cons nil nil))
  )


(length (car (is-scram-project)))

(cc-wk-testfunc)

(setq filepath "/afs/cern.ch/user/s/sashby/.env/emacs/src/S/P/src/TT.cc")
(setq scramdir (search-file ".SCRAM" filepath))
(string-match "\\(/.SCRAM\\|/.SCRAM/\\)" scramdir)
(setq localtop (substring scramdir 0 (match-beginning 1)))
(string-match ".*src/\\(.*\\)/\\(src\\|interface\\|include\\)/.*$" filepath)
(substring filepath (match-beginning 1) (match-end 1))

(if (not (eq (car (find-localtop)) nil))
    (message "found localtop")
  (message "localtop not found."))

(scram-package-name)


(setq package "subsys/packa")
(string-match "^\\(.*\\)/\\(.*\\)$" package)
(substring package 0 (match-end 1))
(substring package (match-beginning 2) (match-end 2))

  

(car (mangle_packagename "mp"))
(insert (car (mangle_packagename "mp")))




(insert (insert-mangled-header-guard))
23

(defun scram-package-name()
  "Return the SCRAM package name for the current filename."
  (interactive)
  (setq package "")
  (cond ((car (find-localtop))
	 ;; The path of current file:
	 (setq filepath (buffer-file-name))
	 ;; Look for a "src/x/y/src":
	 (if (string-match ".*src/\\(.*\\)/\\(src\\|interface\\|include\\)/.*$" filepath)	   
	     (setq package (substring filepath (match-beginning 1) (match-end 1))))
	 ))
  (cons package nil)
  )

(defun cond-test(&optional switch)
  (interactive)
  (cond ((string= "A" switch)
	 (insert "do 1")
	 (insert "do 2"))
	
	((string= "B" switch)
	 (insert "dothisinstead1"))
	)
  )

(cond-test "B")


(setq scram-package-name (cons "" "SUBSYS/PACKAGE"))

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
	(setq mangled (concat (car (mangle_packagename classname)) "_H" ))
	)
    ;; If we got an output from scram-package-name, proceed with the value:
    (progn (setq mangled (concat (car (mangle_packagename (car (scram-package-name)))) "_H" ))))
  )

(insert-mangled-header-guard)

(setq prompt "Also insert a class definition?")

(if (y-or-n-p "C++> ")
    (message "Inserting class")
  (message "Not inserting class"))


(defun increment-string (string amount)
  "Increment the first number in STRING by AMOUNT."
  (if (string-match "[0-9]+" string)
      (let ((num (string-to-number (match-string 0 string))))
        (setq num (+ num amount))
        (replace-match (number-to-string num) nil t string))))

(defun c-number-defines (begin end string amount)
  "Re-number a list of #define statements from BEGIN to END, beginning
with the number START, or an expression containing a single number
which will be incremented.  Increase the number by AMOUNT for each
line."
  (interactive "r\nsBegin with: \np")
  (if (not amount)
      (setq amount 1))
  (save-excursion
    (let ((lines (count-lines begin end)))
      (goto-char begin)
      (while (> lines 0)
        (if (re-search-forward
             "^#define[ \t]+[^ \t]+[ \t]+\\(.+\\)$"
             (save-excursion (progn (end-of-line) (point))) t)
            (progn
              (goto-char (match-beginning 1))
              (if (= (length string) 0)
                  (setq string (buffer-substring (match-end 1)
                                                 (match-beginning 1)))
                (delete-region (match-end 1) (match-beginning 1))
                (insert string))
              (setq string (increment-string string amount))))
        (beginning-of-line)
        (forward-line)
        (setq lines (1- lines))))))


(defun insert-euro (&optional arg) 
  "Insert the Euro symbol."
  (interactive "*P")
  (if arg
      (insert (make-char 'mule-unicode-0100-24ff 116 76))
    (insert (make-char 'latin-iso8859-15 164))))

(defun sw-applescript-run-buffer ()
  "Execute the whole buffer as an Applescript."
  (interactive)
  (do-applescript (buffer-string)))


(defun sw-applescript-run-region () 
  "Execute the region as an Applescript." 
  (interactive) 
  (let ((region (buffer-substring (region-beginning) (region-end)))) 
    (do-applescript region)))



(defun start-pod-skel()
  (interactive)
  "Insert a skeleton layout for POD documentation."
  (let ((pkname))
    ;; Find the package name and use that value:
    (if (re-search-forward "package \\(.*\\);$" nil t)
	(setq pkname (match-string 1))
      (setq pkname nil))
    ;; Otherwise, fall back to asking:
    (while (or (not pkname) (string= pkname ""))
      (setq pkname (read-string "Enter the package name: ")))
    ;; Since the search for the package name puts the point at
    ;; the end of the match, we need to go back a line:
    (beginning-of-line)
    (insert 
     "\n"
     "\n"
     "=head1 NAME\n"
     "\n"
     (symbol-value 'pkname) " - <give desc here>\n"
     "\n"
     "=head1 SYNOPSIS\n"
     "\n"
     "\tmy $obj = " (symbol-value 'pkname) "->new();\n"
     "\n"
     "=head1 DESCRIPTION\n"
     "\n"
     "<describe the package here>\n"
     "\n"     
     "=head1 METHODS\n"
     "\n"
     "=over\n"
     "\n"
     "=cut\n"
     "\n"
     )))

(defun perl-add-pod-item()
  (interactive)
  "Add a POD doc item for a subroutine/method."
  (let ((subname))
    ;; Find the package name and use that value:
    (if (re-search-forward "sub \\(.*\\)()$" nil t)
	(setq subname (match-string 1))
      (setq subname nil))
    ;; Otherwise, fall back to asking:
    (while (or (not subname) (string= subname ""))
      (setq subname (read-string "Enter the subroutine name: ")))
    ;; Since the search for the package name puts the point at
    ;; the end of the match, we need to go back a line:
    (beginning-of-line)    
    (insert
     "\n"
     "=item C<" (symbol-value 'subname) "( {args} )>\n"
     "\n"
     "   DESCRIPTION  \n"
     "\n"
     "=cut\n\n"
     )))



(start-pod-skel)

(perl-add-pod-item)


(if (string-match "powerpc-apple-darwin, X toolkit" (emacs-version))
    (message "PPC")
  (message "linux"))


(setq dome nil)

(if (string= dome "yes")
    (message "yes")
(message "no"))


(if (not (equal dome nil))
    (message "not nil!")
  (message "NIL!!!"))

(if (eq window-system 'x)
    (progn (setq msg "X11: do A,\n")
	   (setq msg (concat msg "      do B")))
  (message "mac"))


(if (eq window-system 'x)
    (if (string-match "powerpc-apple-darwin" (emacs-version))
	(progn (setq msg "PowerPC X11: do A, ")
	       (setq msg (concat msg "      do B")))
      (progn (setq msg2 "Linux X11: do A, ")
	     (setq msg2 (concat msg2 " do B"))))
  (message "mac window system"))



;; (setq is-x "x")
;; (setq emvers "")

;; (if (not (equal is-x nil))
;;     (if (string-match "powerpc-apple-darwin" emvers)
;; 	(progn (setq msg "PowerPC X11: do A, ")
;; 	       (setq msg (concat msg "      do B")))
;;       (progn (setq msg2 "Linux X11: do A, ")
;; 	     (setq msg2 (concat msg2 " do B"))))
;;   (message "mac window system"))


(message "« blahh »") ;; X11 to TextEdit
(message "Ç blahh È") ;; TextEdit to X11

;; I want ISO chars to show as printed
;;(standard-display-european nil)
;;(standard-display-8bit 160 255)

(defun xcode-macro-insert(&optional string)
  "Take the input string an wrap it in << and >> characters."
  (interactive)
  (insert "Ç" (symbol-value 'string) "È")
  )

(xcode-macro-insert "PROJECTNAME")

(setq ln 14)
(setq end (- ln 2))
(setq start 2)
(-2 ln)


(defun xcode-template-macroize ()
  "Search the current buffer for all upcase words 
   that are surrounded by << >> and replace the brackets
   with the current special chars"
  (interactive)
  (while (re-search-forward "\\(<<[A-Z]+>>\\)" nil t 1)
    (setq item (match-string 1))
    (setq start 2)
    (setq end (- (length item) 2))
    (setq repl (substring item start end))
    (replace-match (concat "Ç" repl "È") t nil nil nil) 
    ))

<<PROJECTNAME>>.xx
#-------------------------------
# Author:  <<USERNAME>>
# Updated: <<TIME>> <<DATE>>
# Copyright <<YEAR>> <<USERNAME>>
#
#-------------------------------

;;(replace-match "k\&k" t nil nil nil) 
