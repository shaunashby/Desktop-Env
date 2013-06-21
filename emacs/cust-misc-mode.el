;;
;; cust-misc-mode.el
;;


;; Mustache-mode:
(add-to-list 'load-path "~/emacs/mustache-mode.el")
(require 'mustache-mode)

;; CoffeeScript:
(setq auto-mode-alist
      (append auto-mode-alist
	      '(("\\.coffee$" . coffee-mode)
		("Cakefile" . coffee-mode))))

(autoload 'coffee-mode "coffee-mode"
  "Major mode for editing CoffeeScript files." t)

;; HASKELL:
(load "~/emacs/haskell-mode-2.4/haskell-site-file")
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
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert "#____________________________________________________________________ 
# File: " (buffer-name) "
#____________________________________________________________________ 
#  
# Author: " (user-full-name)  " <" user-mail-address ">
# Created: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$ 
#
# Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
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
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert "[%#
#____________________________________________________________________ 
# File: " (buffer-name) "
#____________________________________________________________________ 
#  
# Author: " (user-full-name)  " <" user-mail-address ">
# Created: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$ 
#
# Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
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

;; Hooks:
(add-hook 'ruby-mode-hook
	  (function (lambda ()
		      ;; Use auto completion:
		      (require 'ruby-electric)
		      (ruby-electric-mode t))))

(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb$" . ruby-mode) auto-mode-alist))

;; Applescript mode:
(autoload 'applescript-mode "applescript-mode" "Major mode for editing AppleScript source." t)

(defun applescript-insert-file-header () 
  (interactive)
  "Inserts some lines for a header, including VCS info, author, date and copyright."
  (insert 
   "--
-- -------------------------------------------------------------------
-- File: " (buffer-name) "
-- -------------------------------------------------------------------
--  
-- Author: " (user-full-name)  " <" user-mail-address ">
-- Created: " (format-time-string "%Y-%m-%d %T%z") "
-- Revision: $Id" "$ 
--
-- Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
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

;; RPM spec mode:
(autoload 'rpm-spec-mode "rpm-spec-mode" "RPM spec mode" t)
(setq auto-mode-alist (cons '("\\.spec$". rpm-spec-mode) auto-mode-alist))

;; SmallTalk mode:
(setq auto-mode-alist (cons '("\\.st\\'" . smalltalk-mode) auto-mode-alist))
(autoload 'smalltalk-mode "smalltalk-mode" "Major mode to edit SmallTalk files." t)

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
