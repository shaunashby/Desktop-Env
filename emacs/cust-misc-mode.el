;;
;; cust-misc-mode.el
;;

;; HASKELL:
(load "/opt/local/share/emacs/site-lisp/haskell-mode-2.4/haskell-site-file")
(setq auto-mode-alist
      (append auto-mode-alist
	      '(("\\.[hg]s$"  . haskell-mode)
		("\\.hi$"     . haskell-mode)
		("\\.l[hg]s$" . literate-haskell-mode))))
;;
(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts." t)
;;
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
;;
;; YAML:
(require 'yaml-mode)
;;(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(setq auto-mode-alist (cons '("\\.yml$" . yaml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.yaml$" . yaml-mode) auto-mode-alist))

;; Puppet:
(autoload 'puppet-mode "puppet-mode" "Major mode for editing Puppet manifest files." t)

(defun puppet-insert-file-header ()
  (interactive)
  "Inserts some lines for a header, including Revision Id, author, date and copyright."
  (insert "#____________________________________________________________________ 
# File: " (buffer-name) "
#____________________________________________________________________ 
#  
# Author: " (user-full-name)  " <" user-mail-address ">
# Update: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$ 
#
# Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
#
#--------------------------------------------------------------------
"
))

;; Hooks:
(add-hook 'puppet-mode-hook
	  (function (lambda ()
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (puppet-insert-file-header)
			     ))
		      )))

(setq auto-mode-alist (cons '("\\.pp$" . puppet-mode) auto-mode-alist))

;; TT mode (Template Toolkit):
(autoload 'tt-mode "tt-mode" "Major mode for editing Template Toolkit template files." t)

(defun tt-insert-file-header ()
  (interactive)
  "Inserts some lines for a header, including Revision Id, author, date and copyright."
  (insert "[%#
#____________________________________________________________________ 
# File: " (buffer-name) "
#____________________________________________________________________ 
#  
# Author: " (user-full-name)  " <" user-mail-address ">
# Update: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$ 
#
# Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
#
#--------------------------------------------------------------------
%]"
))

;; Hooks:
(add-hook 'tt-mode-hook
	  (function (lambda ()
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (tt-insert-file-header)
			     ))
		      )))

(setq auto-mode-alist (cons '("\\.tt$" . tt-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tt2$" . tt-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tpl$" . tt-mode) auto-mode-alist))

;; PHP mode:
(autoload 'php-mode "php-mode" "Major mode for editing PHP source files." t)
(setq auto-mode-alist (cons '("\\.php$" . php-mode) auto-mode-alist))

;; Ruby mode:
(autoload 'ruby-mode "ruby-mode" "Major mode for editing Ruby source." t)

(defun ruby-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including CVS Id, author, date and copyright."
  (insert "#!/usr/bin/ruby
#____________________________________________________________________ 
# File: " (buffer-name) "
#____________________________________________________________________ 
#  
# Author: " (user-full-name)  " <" user-mail-address ">
# Update: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$ 
#
# Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
#
#--------------------------------------------------------------------
"
))

;; Hooks:
(add-hook 'ruby-mode-hook
	  (function (lambda ()
		      ;; Use auto completion:
		      (require 'ruby-electric)
		      (ruby-electric-mode t)
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (ruby-insert-file-header)
			     ))
		      )))

(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb$" . ruby-mode) auto-mode-alist))

;; Applescript mode:
(autoload 'applescript-mode "applescript-mode" "Major mode for editing AppleScript source." t)

(defun applescript-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including CVS Id, author, date and copyright."
  (insert 
   "--
-- -------------------------------------------------------------------
-- File: " (buffer-name) "
-- -------------------------------------------------------------------
--  
-- Author: " (user-full-name)  " <" user-mail-address ">
-- Update: " (format-time-string "%Y-%m-%d %T%z") "
-- Revision: $Id" "$ 
--
-- Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
--
-- -------------------------------------------------------------------
-- 
"))

;; Hooks:
(add-hook 'applescript-mode-hook
	  (function (lambda ()
		      (auto-fill-mode 1)
		      ;;
		      (cond ((not (file-exists-p (buffer-file-name)))
			     (applescript-insert-file-header)
			     ))
		      )))

(setq auto-mode-alist (cons '("\\.applescript$" . applescript-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.scpt$" . applescript-mode) auto-mode-alist))

;; Autoload CMS Parameter set mode:
;; (autoload 'cms-pset-mode "cms-pset-mode" "CMS Parameter Set Editing Mode." t)
;; (setq auto-mode-alist (cons '("\\.cfg$" . cms-pset-mode) auto-mode-alist))

;; Misc!
;; (autoload 'cmt-mode "cmt-mode" "CMT Requirements Editing Mode." t)

;; RPM spec mode:
(autoload 'rpm-spec-mode "rpm-spec-mode" "RPM spec mode" t)
(setq auto-mode-alist (cons '("\\.spec$". rpm-spec-mode) auto-mode-alist))

;; SmallTalk mode:
(setq auto-mode-alist (cons '("\\.st\\'" . smalltalk-mode) auto-mode-alist))
(autoload 'smalltalk-mode "smalltalk-mode" "Major mode to edit SmallTalk files." t)

;; ToolBox mode:
(autoload 'toolbox-mode "toolbox-mode" "autoloaded" t)
(setq auto-mode-alist (append '(("\\BuildFile\\'" . toolbox-mode)               
				("\\CMSconfiguration\\'" . toolbox-mode)        
				("\\Configuration\\'" . toolbox-mode) 
				("\\RequirementsDoc\\'" . toolbox-mode)         
				("\\BootStrapFile\\'" . toolbox-mode)           
				("\\BootStrapFileSRC\\'" . toolbox-mode)
				)
			      auto-mode-alist))

;; Xdefaults editing mode:
(setq cust-xrdb-font-lock-keywords
      (list
       '("^#.*" 0 'font-lock-comment-face t)
       '("\\(:\\)"  1 'Green-face t)
       '("\\(\\*\\)" 1 'CornflowerBlue-face t)
       '("^#[ \t]*\\(ifdef\\|define\\|endif\\)" 1 font-lock-variable-name-face t)
       ))

(font-lock-add-keywords 'xrdb-mode cust-xrdb-font-lock-keywords)

(add-hook 'xrdb-mode 'turn-on-font-lock)
(add-hook 'xrdb-mode-hook
	  (function (lambda()
		      (require 'easymenu)
		      (easy-menu-define xrdb-menu xrdb-mode-map "XRDB Menu"
			'("XRDB"
			  ["Merge File or Region" xrdb-database-merge-buffer-or-region t]
			  [ "Save Buffer" save-buffer t]
			  "---"
			  ["Quit"         kill-buffer t]
			  ))
		      )))

(setq auto-mode-alist (append '(("\\.Xresources\\'" . xrdb-mode)
				("\\xresources\\'"  . xrdb-mode)
				("\\.Xdefaults\\'"  . xrdb-mode)
				)
			      auto-mode-alist))
;;
(autoload 'xrdb-mode "xrdb-mode" "Mode for editing X resource files." t)

;; Gnuplot-mode:
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) 
			      auto-mode-alist))
;; Path to info for gnuplot:
(add-to-list 'Info-default-directory-list "~/emacs/info")
;; PostScript mode:
(setq auto-mode-alist (cons '("\\.ps\\'" . ps-mode) auto-mode-alist))
(autoload 'ps-mode "ps-mode" "Major mode to edit PostScript files." t)

;; Modify menu for printing:
(if (not window-system)
    nil
  ;; Define my own button in menu for custom printing options:
  (defvar menu-bar-custom-print-menu (make-sparse-keymap "Custom Printing"))
  ;; Add the items to menu-bar-custom-print-menu:
  (define-key menu-bar-custom-print-menu [ps-print-region-fl] '("PS print region to file" . ps-spool-region))
  (define-key menu-bar-custom-print-menu [ps-print-buffer-fl] '("PS print buffer to file" . ps-spool-buffer))
  (define-key menu-bar-custom-print-menu [separator-ps-print-cust] '("--"))
  (define-key menu-bar-custom-print-menu [ps-print-region-clr] '("PS print region to file (clr)" . ps-spool-region-with-faces))
  (define-key menu-bar-custom-print-menu [ps-print-buffer-clr] '("PS print buffer to file (clr)" . ps-spool-buffer-with-faces))
  (put 'ps-spool-region 'menu-enable 'mark-active)
  (put 'ps-spool-region-with-faces 'menu-enable 'mark-active)
  ;; Now add this new menu to "Files" menu, to appear after "Postscript print region (B+W)":
  (define-key-after menu-bar-file-menu [separator-ps-print-blank] '("--") 'ps-print-region)
  (define-key-after menu-bar-file-menu [cust-print] (cons "Custom Printing" menu-bar-custom-print-menu) 'separator-ps-print-blank)
  )

;; WGET:
(autoload 'wget "wget" "WWW GET utility." t)

;; JavaScript mode:
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; RFC viewer:
(setq auto-mode-alist (cons '("/rfc[0-9]+\\.txt\\'" . rfcview-mode)
			    auto-mode-alist))

(autoload 'rfcview-mode "rfcview" nil t)

;; Stuff for VM:
(eval-after-load "vm" '(defun vm-check-emacs-version () t))
(setq vm-circular-folders nil)
(autoload 'vm "vm" "Start VM on your primary inbox." t)
(autoload 'vm-other-frame "vm" "Like `vm' but starts in another frame." t)
(autoload 'vm-visit-folder "vm" "Start VM on an arbitrary folder." t)
(autoload 'vm-visit-virtual-folder "vm" "Visit a VM virtual folder." t)
(autoload 'vm-mode "vm" "Run VM major mode on a buffer" t)
(autoload 'vm-mail "vm" "Send a mail message using VM." t)
(autoload 'vm-submit-bug-report "vm" "Send a bug report about VM." t)
;;
;;  Change C-x m  to vm mail send 
;;  Change default mail read and send to vm in menu when in X
;;
(if (not window-system)
    nil
  (define-key menu-bar-tools-menu [rmail] '("Read Mail" . vm))
  (define-key-after menu-bar-tools-menu [smail] 
    '("Send Mail" . vm-mail) 'rmail))

;; Gnus:
(defun get-file-contents (name)
  (let ((newbuf (generate-new-buffer "tmp"))
	(contents nil))
    (save-excursion
      (set-buffer newbuf)
      (and (file-readable-p name)
	   (insert-file-contents name)
	   (setq contents (buffer-string))))
    (kill-buffer newbuf)
    contents))

  (let (contents)
    ;; read file
    (setq contents (get-file-contents "/usr/local/lib/rn/server"))
    ;; set gnus-nntp-server
    (if contents
	;; strip final newline
	(setq gnus-nntp-server (substring contents 0 -1))
      ;; try to use NNTPSERVER variable
      (setq gnus-nntp-server (getenv "NNTPSERVER"))))
  (let (contents)
    ;; read file
    (setq contents (get-file-contents "/usr/local/lib/rn/domain"))
    ;; set gnus-nntp-server
    (if contents
	;; strip final newline
	(setq gnus-local-domain (substring contents 0 -1))
      ;; try to use LOCALDOMAIN variable
      (setq gnus-local-domain (getenv "LOCALDOMAIN"))))
(setq gnus-auto-select-first nil)

;; Stuff for spell-checker:
(setq ispell-dictionary-alist        
  '((nil				; default (english.aff)
     "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B") nil)
    ("english"				; make english explicitly selectable
     "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B") nil)
    ("british"				; british version
     "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B" "-d" "british") nil)
    ("francais"				; francais.aff
     "[A-Za-z\300\302\306\307\310\311\312\313\316\317\324\331\333\334\340\342\347\350\351\352\353\356\357\364\371\373\374]"
     "[^A-Za-z\300\302\306\307\310\311\312\313\316\317\324\331\333\334\340\342\347\350\351\352\353\356\357\364\371\373\374]"
     "[---']" t nil "~list")
     ("espa~nol"                        ; Spanish mode
          "[A-Z\301\311\315\323\332\334\312a-z\341\351\355\363\372\374\361]"
          "[^A-Z¡…Õ”⁄‹ a-z·ÈÌÛ˙¸Ò]"
          "[---]" t nil "~tex")
    ("deutsch"				; deutsch.aff
     "[a-zA-Z\"]" "[^a-zA-Z\"]" "[']" t ("-C") "~tex")))


(setq ispell-menu-map nil)

(let ((dicts (reverse (cons (cons "default" nil) ispell-dictionary-alist)))
      name)
  (setq ispell-menu-map (make-sparse-keymap "Spell"))
  ;; add the dictionaries to the bottom of the list.
  (while dicts
    (setq name (car (car dicts))
	  dicts (cdr dicts))
    (if (stringp name)
	(define-key ispell-menu-map (vector (intern name))
	  (cons (concat "Select " (capitalize name))
		(list 'lambda () '(interactive)
		      (list 'ispell-change-dictionary name)))))))

(progn
  (define-key ispell-menu-map [ispell-change-dictionary]
    '("Change Dictionary" . ispell-change-dictionary))
  (define-key ispell-menu-map [ispell-kill-ispell]
    '("Kill Process" . ispell-kill-ispell))
  (define-key ispell-menu-map [ispell-pdict-save]
    '("Save Dictionary" . (lambda () (interactive) (ispell-pdict-save t t))))
  (define-key ispell-menu-map [ispell-complete-word]
    '("Complete Word" . ispell-complete-word))
  (define-key ispell-menu-map [ispell-complete-word-interior-frag]
    '("Complete Word Frag" . ispell-complete-word-interior-frag)))

(progn
  (define-key ispell-menu-map [ispell-continue]
    '("Continue Check" . ispell-continue))
  (define-key ispell-menu-map [ispell-word]
    '("Check Word" . ispell-word))
  (define-key ispell-menu-map [ispell-region]
    '("Check Region" . ispell-region))
  (define-key ispell-menu-map [ispell-buffer]
    '("Check Buffer" . ispell-buffer)))

(progn
  (define-key ispell-menu-map [ispell-message]
    '("Check Message" . ispell-message))
  (define-key ispell-menu-map [ispell-help]
    '("Help" . (lambda () (interactive) (describe-function 'ispell-help))))
  (put 'ispell-region 'menu-enable 'mark-active)
  (fset 'ispell-menu-map (symbol-value 'ispell-menu-map)))


;; Dired additions:
(setq cust-dired-font-lock-keywords
      (list
       '("\\( sashby \\)"  1 'Green-face t)
       '("\\( staff \\)"  1 'Plum-face t)
       '("\\( root \\)"  1 'Orange-face t)
       ))

(font-lock-add-keywords 'dired-mode cust-dired-font-lock-keywords)

(add-hook 'dired-load-hook
          (function (lambda ()
                      (load "dired-x")
                      ;; Set global variables here:
                      (setq dired-guess-shell-alist-user 
			    (list (list "\\.so$" "nm -s --demangle")
				  (list "\\.exe$" "ldd")))
		      )))

(add-hook 'dired-mode-hook
          (function (lambda ()
                      ;; Set buffer-local variables here.  For example:
                      ;; (setq dired-omit-files-p t)
                      )))
;;
;; End of cust-misc-mode.el
;;
