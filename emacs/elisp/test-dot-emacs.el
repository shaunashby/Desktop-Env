;;
;; Martin Schwenke's ~/.emacs file for GNU Emacs 21.
;; $Id: test-dot-emacs.el,v 1.1 2005/08/19 09:57:17 sashby Exp $

;; ======================================================================
;;
;; DEBUGGING

(setq message-log-max 100)

;; Leave these here for debugging this file!
;;(setq debug-on-error t)
;;(add-hook 'after-init-hook
;;	  '(lambda () (setq debug-on-error t)))
;;(debug-on-entry 'command-line-1)
;;(setq message-log-max 1000)

;; ======================================================================
;; XEmacs support.  This setup is written for GNU Emacs.  Including
;; this file adds some things to make it work with XEmacs as well.

(if (string-match "XEmacs" emacs-version)
    (load-file (expand-file-name ".xemacs-extras" "~")))

;; ======================================================================
;;
; PATHS

;; Add some directories to load-path.  Subdirectories that don't
;; contain a ".nosearch" file are also added.  These days this is the
;; standard GNU Emacs way of doing things at the site level.  I do the
;; same for my personal stuff for consistency and convenience.
(mapcar '(lambda (dir)
	   (let* ((xdir (expand-file-name dir))
		  (default-directory xdir))
	     ;; If this isn't emacs' real site-lisp directory then
	     ;; we'd better add ourselves, since this code assumes
	     ;; that we're there.
	     (add-to-list 'load-path xdir)
	     ;; Now add subdirectories.
	     (normal-top-level-add-subdirs-to-load-path)))

	'("~/share/emacs/lisp"
	  "~/share/emacs/mms"))

;; ======================================================================

;; Any elisp patches?
(let ((pd
       (expand-file-name
	(format "patches-%s.%s" emacs-major-version emacs-minor-version)
	"~/share/emacs")))
  (if (file-directory-p pd)
      (add-to-list 'load-path pd)))

;; ======================================================================

;; NON-STANDARD VARIABLES

(defvar emacs-etc-dir
  (expand-file-name "~/share/emacs/etc")
  "*Name of directory where various emacs related files reside.")

;; It would be nice if there was a plain version of mapcar which
;; returned a string...
(defvar user-mail-alias
  (mapconcat (lambda (c)
	       (char-to-string
		(if (equal c ? ) ?. c))) (user-full-name) "")
  "*String for a mail alias taken from the user's full name.")

(defvar user-mail-names
  (concat
   "\\<" (user-login-name) "\\>@\\|"
   "\\<martin\\>@\\|"
   "\\<schwenke\\>@\\|"
   "\\<" (regexp-quote user-mail-alias) "\\>@")
  "*Regular expression for mail names for this user.
Includes any aliases.")

;; If mail-host-address isn't set then use the system name minus the
;; first component.
(if (not mail-host-address)
    (setq mail-host-address
	  (let ((p (string-match "\\." (system-name))))
	    (if p
		(substring (system-name) (+ 1 ))
	      (system-name)))))

;;(setq user-mail-address
;;      (concat (user-login-name) "@" mail-host-address))
(setq user-mail-address
      "martin@meltin.net")

(defvar user-www-address
  (concat "http://" mail-host-address "/people/" (user-login-name) "/")
  "*User's WWW address.")

;; ======================================================================

;; STANDARD VARIABLES

(if (boundp 'confirm-kill-emacs)
    (setq confirm-kill-emacs 'yes-or-no-p))

;; Try to speed things up, especially in VM.
(setq gc-cons-threshold 2000000)

;; Don't beep in my headphones!
(setq visible-bell t)

(setq ange-ftp-generate-anonymous-password
      user-mail-address)

;;(add-to-list 'lpr-switches
;;	     "-o duplex")

;; Changes in file saving policy:
;; * Put autosaves where I want them.
;; * No backup files, but still use autosave.
;; * Try hard to break hard links.
(setq make-backup-files             nil
      auto-save-list-file-prefix    (expand-file-name "saves/" emacs-etc-dir)
      file-precious-flag            t
      find-file-existing-other-name nil)

;; Prompt before evaluating local bits of lisp.  This stops people
;; putting things at the end of files which delete all your files!
(setq enable-local-variables t
      enable-local-eval      1)

;; ----------------------------------------------------------------------

;; STANDARD LIBRARIES

(require 'icomplete) ; Interactive completion in minibuffer.

(require 'jka-compr) ; Automatic decompression, hooks for tar-mode.
(if (fboundp 'auto-compression-mode)
    (auto-compression-mode 1))

(show-paren-mode 1) ; Parenthesis matching via highlighting.

(standard-display-european 1) ; 8-bit european characters.

;; Time in 24 hour format, plus day and date.
(setq display-time-day-and-date t
      display-time-24hr-format  t)
(display-time)

;; ----------------------------------------------------------------------

;; STANDARD HOOKS

(add-hook 'text-mode-hook
	  'turn-on-auto-fill)

(add-hook 'write-file-hooks
	  'time-stamp)

;; ----------------------------------------------------------------------

;; DESIRE

;; ----------------------------------------------------------------------

(require 'desire)

(add-to-list 'desire-load-path
	     (expand-file-name "~/share/emacs/desire"))
(add-to-list 'auto-mode-alist
	     (cons (concat (regexp-quote desire-extension) "\\'")
		   'emacs-lisp-mode))

;; ----------------------------------------------------------------------

;; NON-STANDARD

(if (string-match "XEmacs" emacs-version)
    (desired 'xemacs))

(desire 'site-stuff)

(if (and window-system
	 (member window-system '(x gtk))
	 (x-display-color-p))
    (progn
      (desired 'window-system)
      (desire  'faces)
      (desire  'multi-frame)))

(desire 'keys)

;; ----------------------------------------------------------------------

;; Pilot support
(desire 'pilot)

;; ----------------------------------------------------------------------

;; BBDB - Must be loaded before most other things, since other things
;;        may perform special configuration if BBDB is present.
;;
(desire 'bbdb "bbdb")

;; ----------------------------------------------------------------------

;; Appointments, diary, calendar.
;;
;; Use "M-x calendar RET" to display the calendar and start
;; appointment warnings.

(desire 'appt)
(desire 'calendar)
(desire 'todo-mode)
(desire 'diary "diary-lib")

;; ----------------------------------------------------------------------

;; These provide options for the various message handling packages.
(desire 'browse-url)
(desire 'mailcrypt)
(desire 'supercite)

;; Message handing packages.
(desire 'gnus)
(desire 'message)
(desire 'vm)
(desire 'sendmail)

;; ----------------------------------------------------------------------

;; Miscellaneous

(desire 'abbrev)
(desire 'bibtex)
(desire 'calc)
(desire 'ediff)
(desire 'eiffel-mode)
(desire 'eudc)
(desire 'filladapt)
;;(desire 'hugs-mode)
(desire 'haskell-mode)
(desire 'ispell)
(desire 'latex)
(desire 'lispdir)
(desire 'php-mode)
(desire 'ps-print)
(desire 'psgml)
(desire 'sh-script)
(desire 'shell)
;;(desire 'sql-mode)
(desire 'tex)
(desire 'w3)

;; ----------------------------------------------------------------------

;; Gnuserv

(desire 'gnuserv)
;; Rely on dtemacs to do this, otherwise a race condition can cause
;; dtemacs to fail.
;;(gnuserv-start)

;; ======================================================================
;;
;; PERSONAL

(require 'chord-mode)  ; edit guitar music.
(require 'discography) ; variant of BibTeX mode for discographies.

;; ======================================================================
;;
;; unNOVICEd commands...
;;
;; The following commands are usually disabled by default.  Enable
;; them...

(put 'eval-expression  'disabled nil)
(put 'downcase-region  'disabled nil)
(put 'upcase-region    'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)
(custom-set-variables
 '(load-home-init-file t t)
 '(gnuserv-program (concat exec-directory "/gnuserv")))
(custom-set-faces)
