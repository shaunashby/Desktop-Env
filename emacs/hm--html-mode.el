;;; hm--html-mode --- Major mode for editing HTML documents for the WWW

;; Copyright (C) 1996 - 1998 Heiko Muenkel

;; Author: Heiko Muenkel <muenkel@tnt.uni-hannover.de>
;; Keywords: hypermedia languages help docs wp

;; $Id: hm--html-mode.el,v 1.1.1.1 2003/04/29 15:16:52 sashby Exp $

;; This file is part of XEmacs.

;; XEmacs is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with XEmacs; See the file COPYING. if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA

;;; Synched up with: Not part of Emacs.

;;; Commentary:

;; Description:

;;	This file defines the hm--html-mode, a mode for editing html
;;	files. It is the main file of the package hm--html-menus.
;;	Previous releases had used the file html-mode.el from Marc
;;	Andreessen. In that times the mode was called html-mode. I've
;;	changed the name of the mode to distinquish it from other
;;	html modes. But feel free to set a 
;;		(defalias 'hm--html-mode 'html-mode)
;;	to get back the old name of the mode.

;;	In the earlier releases of the package the main file was
;;	hm--html-menu.el. This has been changed to hm--html-mode.el.


;; Installation: 

;;	Put this file and all the other files of the package
;;	in one of your load path directories and the
;;	following lines in your .emacs:

;;	(autoload 'hm--html-mode "hm--html-mode" "HTML major mode." t)

;;	(or (assoc "\\.html$" auto-mode-alist)
;;         (setq auto-mode-alist (cons '("\\.html$" . hm--html-mode) 
;;				        auto-mode-alist)))
;;	If there is already another html-mode (like psgml in the XEmacs
;;	19.14, then you must put the following instead of the last form
;;	in your .emacs:
;;	(setq auto-mode-alist (cons '("\\.html$" . hm--html-mode) 
;;				        auto-mode-alist))

;;	But you can also use the hm--html-minor-mode as an addition to
;;	the psgml html modes. For that you've to put the following line in
;;	your .emacs:
;;	(add-hook 'html-mode-hook 'hm--html-minor-mode)

;;	Note: This works only in an XEmacs version greater than 19.14 and
;;	also not in the XEmacs 20.0.

;;	Look at the file hm--html-configuration for further installation
;;      points.

;;; Code:

(require 'font-lock)
(require 'cl)
(require 'adapt)
(require 'hm--date)
(require 'hm--html)
;(require 'hm--html-not-standard)

(eval-when-compile
  (require 'hm--html-configuration))

(hm--html-load-config-files)
(require 'hm--html-indentation)

(defvar hm--html-minor-mode nil
  "Non-nil, if the `hm--html-minor-mode' is active.")

(require 'hm--html-menu)

(require 'hm--html-keys)

;(defvar hm--html-minor-mode nil
;  "Non-nil, if the `hm--html-minor-mode' is active.")
;
;(require 'hm--html-menu)
(require 'hm--html-drag-and-drop)


;;; The package version
(defconst hm--html-menus-package-maintainer "muenkel@tnt.uni-hannover.de")

(defconst hm--html-menus-package-name "hm--html-menus")

(defconst hm--html-menus-package-version "5.9")
  

;;; Generate the help buffer faces
(hm--html-generate-help-buffer-faces)

;;; syntax table

(defvar hm--html-mode-syntax-table nil
  "Syntax table used while in html mode.")

(if hm--html-mode-syntax-table
    ()
  (setq hm--html-mode-syntax-table (make-syntax-table))
;  (modify-syntax-entry ?\" ".   " hm--html-mode-syntax-table)
;  (modify-syntax-entry ?\\ ".   " hm--html-mode-syntax-table)
;  (modify-syntax-entry ?'  "w   " hm--html-mode-syntax-table)
  (modify-syntax-entry ?\\ "." hm--html-mode-syntax-table)
  (modify-syntax-entry ?'  "w" hm--html-mode-syntax-table)
  (modify-syntax-entry ?<  "(>" hm--html-mode-syntax-table)
  (modify-syntax-entry ?>  ")<" hm--html-mode-syntax-table)
  (modify-syntax-entry ?\" "\"" hm--html-mode-syntax-table)
  (modify-syntax-entry ?=  "."  hm--html-mode-syntax-table))


;;; abbreviation table

(defvar hm--html-mode-abbrev-table nil
  "Abbrev table used while in html mode.")

(define-abbrev-table 'hm--html-mode-abbrev-table ())

;;; the hm--html-mode

(defvar hm--html-mode-name-string "HTML"
  "The hm--html-mode name string.")

;;;###autoload
(defun hm--html-mode ()
  "Major mode for editing HTML hypertext documents.  
Special commands:\\{hm--html-mode-map}
Turning on hm--html-mode calls the value of the variable hm--html-mode-hook,
if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map hm--html-mode-map)
  (setq mode-name hm--html-mode-name-string)
  (setq major-mode 'hm--html-mode)
  (setq local-abbrev-table hm--html-mode-abbrev-table)
  (set-syntax-table hm--html-mode-syntax-table)
  (make-local-variable 'comment-start)
  (make-local-variable 'comment-end)
  (setq comment-start "<!--" comment-end "-->")
  (make-local-variable 'sentence-end)
  (setq sentence-end "[<>.?!][]\"')}]*\\($\\| $\\|\t\\|  \\)[ \t\n]*")
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'hm--html-indent-line)
  (setq idd-actions hm--html-idd-actions)
  (hm--install-html-menu hm--html-mode-pulldown-menu-name)
  (make-variable-buffer-local 'write-file-hooks)
  (add-hook 'write-file-hooks 'hm--html-maybe-new-date-and-changed-comment)
  (if (adapt-xemacsp)
      (put major-mode 'font-lock-defaults '((hm--html-font-lock-keywords
					     hm--html-font-lock-keywords-1
					     hm--html-font-lock-keywords-2)
					    t
					    t
					    nil
					    nil))
    (make-local-variable 'font-lock-defaults)
    (setq font-lock-defaults '((hm--html-font-lock-keywords
				hm--html-font-lock-keywords-1
				hm--html-font-lock-keywords-2)
			       t
			       t
			       nil
			       nil)))
  (run-hooks 'hm--html-mode-hook))

;;;; Minor Modes

;;; hm--html-region-mode 

(defvar hm--html-region-mode nil
  "T, if the region is active in the `hm--html-mode'.")

(make-variable-buffer-local 'hm--html-region-mode)

(add-minor-mode 'hm--html-region-mode " Region" hm--html-region-mode-map)

(if (adapt-xemacsp)

    (defun hm--html-region-mode (&optional arg)
      "Toggle 'hm--html-region-mode'.
With ARG, turn hm--html-region-mode on iff ARG is positive.

If the `major-mode' isn't the `hm--html-mode' then the minor
mode is switched off, regardless of the ARG and the state
of `hm--html-region-mode'."
      (interactive "P")
      (setq zmacs-regions-stays t)
      (setq hm--html-region-mode
	    (and (eq major-mode 'hm--html-mode)
		 (if (null arg) (not hm--html-region-mode)
		   (> (prefix-numeric-value arg) 0))))
      (redraw-modeline)
      )

    (defun hm--html-region-mode (&optional arg)
      "Toggle 'hm--html-region-mode'.
With ARG, turn hm--html-region-mode on iff ARG is positive.

If the `major-mode' isn't the `hm--html-mode' then the minor
mode is switched off, regardless of the ARG and the state
of `hm--html-region-mode'."
      (interactive "P")
      (setq hm--html-region-mode
	    (and (eq major-mode 'hm--html-mode)
		 (if (null arg) (not hm--html-region-mode)
		   (> (prefix-numeric-value arg) 0))))
      (if hm--html-region-mode
	  (define-key hm--html-mode-map
	    hm--html-emacs19-popup-noregion-menu-button
	    nil)
	(if hm--html-expert
	    (define-key hm--html-mode-map
	      hm--html-emacs19-popup-noregion-menu-button
	      hm--html-menu-noregion-expert-map)
	  (define-key hm--html-mode-map
	      hm--html-emacs19-popup-noregion-menu-button
	      hm--html-menu-noregion-novice-map)))
      )
    (redraw-modeline)
    )


;;; hm--html-minor-mode
(make-variable-buffer-local 'hm--html-minor-mode)

(add-minor-mode 'hm--html-minor-mode " HM-HTML" hm--html-minor-mode-map)

;;;###autoload
(defun hm--html-minor-mode (&optional arg)
  "Toggle hm--html-minor-mode.
With arg, turn hm--html-minor-mode on iff arg is positive."
  (interactive "P")
  (setq hm--html-minor-mode
	(if (null arg) (not hm--html-minor-mode)
	  (> (prefix-numeric-value arg) 0)))
  (if hm--html-minor-mode
      (progn
	(hm--install-html-menu hm--html-minor-mode-pulldown-menu-name)

	;; In the future it may be a good idea to merge the contents
	;; of the idd-actions of the major mode with the one of the
	;; minor mode.
	(setq idd-actions hm--html-idd-actions)
	(when (adapt-emacsp)
	  (hm--html-add-major-menu-to-minor-menus)))
    (when (and (featurep 'menubar)
	       current-menubar 
	       (assoc hm--html-minor-mode-pulldown-menu-name
		      current-menubar))
      (delete-menu-item (list hm--html-minor-mode-pulldown-menu-name)))
    (when (adapt-emacsp)
      (hm--html-remove-major-menu-from-minor-menus)))
  (redraw-modeline)
  )
  

;;; hm--html-minor-region-mode

(defvar hm--html-minor-region-mode nil
  "Non-nil, if the `hm--html-minor-region-mode' is active.")

(make-variable-buffer-local 'hm--html-minor-region-mode)

(add-minor-mode 'hm--html-minor-region-mode 
		" Region" 
		hm--html-minor-region-mode-map)


(if (adapt-xemacsp)

    (defun hm--html-minor-region-mode (&optional arg)
      "Toggle `hm--html-minor-region-mode'.
With arg, turn `hm--html-minor-region-mode' on iff arg is positive.

But however, if the `hm--html-minor-mode' isn't active, then it
turns `hm--html-minor-region-mode' off."
      (interactive "P")
      (setq zmacs-regions-stays t)
      (setq hm--html-minor-region-mode
	    (and hm--html-minor-mode
		 (if (null arg) (not hm--html-minor-region-mode)
		   (> (prefix-numeric-value arg) 0))))
      (redraw-modeline)
      )

    (defun hm--html-minor-region-mode (&optional arg)
      "Toggle `hm--html-minor-region-mode'.
With arg, turn `hm--html-minor-region-mode' on iff arg is positive.

But however, if the `hm--html-minor-mode' isn't active, then it
turns `hm--html-minor-region-mode' off."
      (interactive "P")
      (setq hm--html-minor-region-mode
	    (and hm--html-minor-mode
		 (if (null arg) (not hm--html-minor-region-mode)
		   (> (prefix-numeric-value arg) 0))))
      (if hm--html-minor-region-mode
	  (define-key hm--html-minor-mode-map
	    hm--html-emacs19-popup-noregion-menu-button
	    nil)
	(if hm--html-expert
	    (define-key hm--html-minor-mode-map
	      hm--html-emacs19-popup-noregion-menu-button
	      hm--html-menu-noregion-expert-map)
	  (define-key hm--html-minor-mode-map
	      hm--html-emacs19-popup-noregion-menu-button
	      hm--html-menu-noregion-novice-map)))
      )
    (redraw-modeline)
    )

  

;;; Hook function for toggling the region minor modes
(defun hm--html-switch-region-modes-on ()
  "Switches the region minor modes of the hm--html-menus package on.
This function should be only be used for the `zmacs-activate-region-hook'
or for the `activate-mark-hook'."
  (hm--html-region-mode 1)
  (hm--html-minor-region-mode 1))

(defun hm--html-switch-region-modes-off ()
  "Switches the region minor modes of the hm--html-menus package on.
This function should be only be used for the `zmacs-deactivate-region-hook'
or for the `deactivate-mark-hook'."
  (hm--html-region-mode -1)
  (hm--html-minor-region-mode -1))
    

;;; Run the load hook
(run-hooks 'hm--html-load-hook)


;;; Announce the feature hm--html-configuration
(provide 'hm--html-mode)


;;; hm--html-mode.el ends here
