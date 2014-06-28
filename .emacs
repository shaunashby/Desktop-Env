;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                                                               ;;;;
;;;; Author: Shaun ASHBY                                                           ;;;;
;;;; ----------------------------------------------------------------------------- ;;;;
;;;; Revision: $Id: .emacs,v 1.3 2005/08/19 16:29:53 sashby Exp $                  ;;;;
;;;;                                                                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add ny lisp dir to load path:
(setq load-path (cons "~/emacs" load-path))

;; Load defaults for keymaps, frames and look/feel:
(load "keymaps-env")       ;; Default keymaps
(load "modeline-env")      ;; Customizations to mode-line
(load "functions-env")     ;; Functions

;; Load extra libraries:
(load "timestamp")         ;; Timestamp files
(load "date")              ;; Date utilities
(load "goto-percent")      ;; Goto % of buffer
(load "flash-paren")       ;; Flashing bracket mode
(load "ssh")               ;; Use SSH for remote connections

;; Default parameters and variables:
(load "defaults-env")

;; Load tex mode:
(require 'tex-site)        ;; TeX stuff (AucTeX)

;; Arch-specific functionality:
(if (eq window-system 'x)
    ;; X11 emacs on OS X:
    (if (string-match "powerpc-apple-darwin" (emacs-version))
	(progn (load "mwheel")
	       (message "ppc, x toolkit: Wheel mouse support loaded.")
	       ;;
	       (custom-set-faces
		'(rfcview-headnum-face ((t (:bold t :foreground "skyblue"))))
		'(rfcview-rfcnum-face ((t (:bold t :foreground "Yellow"))))
		'(rfcview-title-face ((t (:bold t :foreground "Aquamarine"))))
		'(dired-ignored ((t (:foreground "light salmon"))))
		'(font-lock-comment-face ((t (:bold t :foreground "red"))))
		'(fringe ((((class color) (background dark)) nil)))
		'(mode-line ((t (:background "grey30" :foreground "green" :box (:line-width 1 :style released-button) :slant normal :weight normal :height 96 :width normal :family "misc-fixed"))))
		))
      
      ;; X11 on linux:
      (progn (load "mwheel")
	     (message "linux: Wheel mouse support loaded.")
	     (set-face-font 'mode-line "-schumacher-clean-medium-r-normal--12-*-75-75-c-60-iso8859-9")
	     ;;
	     (custom-set-faces
	      '(rfcview-headnum-face ((t (:bold t :foreground "skyblue"))))
	      '(rfcview-rfcnum-face ((t (:bold t :foreground "Yellow"))))
	      '(rfcview-title-face ((t (:bold t :foreground "Aquamarine"))))
	      '(dired-ignored ((t (:foreground "light salmon"))))
	      '(font-lock-comment-face ((t (:bold t :foreground "red"))))
	      '(fringe ((((class color) (background dark)) nil)))
	      '(mode-line ((t (:background "grey30" :foreground "green" :box (:line-width 1 :style released-button) :slant normal :weight normal :height 96 :width normal :family "misc-fixed"))))
	      )))

  ;; Native emacs on OS X, no X toolkit:
  (progn (message "Applying settings for OS X Carbon emacs")
	 (set-cursor-color "MediumOrchid")	 
	 (custom-set-faces
	  '(default ((t (:stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 96 :width normal :family "apple-monaco"))))
	  '(rfcview-headnum-face ((t (:bold t :foreground "skyblue"))))
	  '(rfcview-rfcnum-face ((t (:bold t :foreground "Yellow"))))
	  '(rfcview-title-face ((t (:bold t :foreground "Aquamarine"))))
	  '(dired-ignored ((t (:foreground "light salmon"))))
	  '(font-lock-comment-face ((t (:foreground "red"))))
	  '(fringe ((((class color) (background dark)) nil)))
	  '(mode-line ((t (:background "grey30" :foreground "green" :box (:line-width 1 :style released-button) :slant normal :weight normal :height 90 :width normal :family "misc-fixed"))))
	  )))

;; Settings for faces:
(load "colored-faces")     ;; Colored faces
(load "cust-faces")        ;; My face defs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ========== Settings for the modes ========= ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "cust-text-mode")    ;; text
(load "cust-emacs-lisp-mode") ;; Emacs-lisp
(load "cust-shell-mode")   ;; shell-scripts
(load "cust-perl-mode")    ;; perl-scripts
(load "cust-python-mode")  ;; python-scripts
(load "cust-cc-mode")      ;; C and C++
(load "cust-java-mode")    ;; Java
(load "cust-latex-mode")   ;; LaTeX
(load "cust-makefile-mode");; Make
(load "cust-misc-mode")    ;; Misc modes (PostScript, GNUPlot, Xrdb, Apache..)

;; Autoinsert support:
(load "cust-autoinsert")

;; Start emacs server if required:
(autoload 'gnuserv-start "gnuserv-compat" 
  "Allow this Emacs process to be a server for client processes." t)
(if (not (equal eserver-mode nil))
    (gnuserv-start)
  (message "Not starting Emacs server."))

;; Erlang (load only on OS X):
(if (string-match "darwin" (emacs-version))
    (progn (message "Loading Erlang files from MacPorts.")
	   (setq load-path (cons "/opt/local/lib/erlang/lib/tools-2.6.15/emacs" load-path))
	   (setq erlang-root-dir "/opt/local/lib/erlang")
	   (setq exec-path (cons "/opt/local/lib/erlang/bin" exec-path))
	   (require 'erlang-start))
  (message "Skipping Erlang file loading on Linux"))

;; Common variables:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default-frame-alist (quote ((menu-bar-lines . 1) (tool-bar-lines . 0) (background-color . "black") (foreground-color . "white") (scroll-bar-width . 12) (top . 10) (left . 10) (height . 80) (width . 155))))
 '(font-lock-maximum-size 2560000)
 '(fringe-mode 4 nil (fringe))
 '(initial-frame-alist (quote ((background-color . "grey12") (foreground-color . "white") (scroll-bar-width . 12) (top . 1) (left . 1) (height . 80) (width . 155))))
 '(query-user-mail-address nil)
 '(read-file-name-completion-ignore-case t)
 '(scroll-bar-mode (quote left))
 '(user-mail-address "shaun@ashby.ch")
 '(c-offsets-alist nil))

;;
;; End of .emacs
;;
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-ignored ((t (:foreground "light salmon"))))
 '(font-lock-comment-face ((t (:bold t :foreground "red"))))
 '(fringe ((((class color) (background dark)) nil)))
 '(mode-line ((t (:background "grey30" :foreground "green" :box (:line-width 1 :style released-button) :slant normal :weight normal :height 96 :width normal :family "misc-fixed"))))
 '(rfcview-headnum-face ((t (:bold t :foreground "skyblue"))))
 '(rfcview-rfcnum-face ((t (:bold t :foreground "Yellow"))))
 '(rfcview-title-face ((t (:bold t :foreground "Aquamarine")))))
