;;; cms-pset-mode.el --- major mode for editing ORCA .orcarc configuration files
;;
;; Keywords:	CMS, framework PSET, configuration 
;; Author:	Shaun ASHBY (Shaun.Ashby@cern.ch)
;; Last edit:	21/06/05
;;
;; It is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; It is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your copy of Emacs; see the file COPYING.  If not, write
;; to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;
;; Information for use:
;; -----------------------------------------------
;; 
;; To enable automatic selection of this mode when appropriate files are
;; visited, add the following to your favourite site or personal Emacs
;; configuration file:
;;
;;   (autoload 'cms-pset-mode "cms-pset-mode" "autoloaded" t)
;;   (add-to-list 'auto-mode-alist '("\\pset\\'" . cms-pset-mode))
;;
;;

;; To handle regexps:
(require 'regexp-opt)

;; Define some variables:
(defvar cms-pset-mode-map nil
  "Keymap used in CMS pset config mode buffers")

(defvar cms-pset-mode-syntax-table nil
  "cms-pset config mode syntax table")

(defvar cms-pset-mode-hook nil
  "*List of hook functions run by `cms-pset-mode' (see `run-hooks')")

;; Stuff for font-lock-mode:
(defconst cms-pset-font-lock-keywords 
  (list
   ;; Comments starting at beginning of lines
   '("#.*" 0 'font-lock-comment-face t)
   '("\\(process\\|PSet\\)" 1 'bold-CornflowerBlue-face t)
   '("\\(PSet\\)" 1 'bold-Cyan3-face t)
   '("process \\([a-zA-Z0-9].*\\) = {" 1 'LightBlue2-face t)
   '("PSet \\([a-zA-Z0-9].*\\) = {" 1 'Cyan3-face t)
   '("\\(string\\|bool\\|int32\\|uint32\\|double\\)" 1 'font-lock-type-face t)
   '("int32 \\(.*\\)=.*" 1 'font-lock-variable-name-face t)
   '("uint32 \\(.*\\)=.*" 1 'font-lock-variable-name-face t)
   '("string \\(.*\\)=.*" 1 'font-lock-variable-name-face t)
   '("bool \\(.*\\)=.*" 1 'font-lock-variable-name-face t)
   '("double \\(.*\\)=.*" 1 'font-lock-variable-name-face t)
   '("\\(path\\|endpath\\)" 1 'SeaGreen2-face t)
   '("\\(using\\|block\\)" 1 'Tan2-face t)
   '("\\(module\\)" 1 'bold-Coral2-face t)
   '("\\(sequence\\)" 1 'Aquamarine2-face t)
   '("module \\([a-zA-Z0-9]*\\) =" 1 'Salmon-face t)
   '("\\(.*source\\) =" 1 'GreenYellow-face t)
   '("using \\([a-zA-Z0-9]*\\)$" 1 'bold-italic t)
   '("\\(untracked\\)" 1 'Orchid-face t)
   '(".*:\\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
   '(".*\\(#//.*\\)$" 1 'font-lock-comment-face t)
   '("\\(\\\".*\\\"\\)" 1 'font-lock-string-face t)
   )
  "Basic expressions to highlight in CMS pset config buffers.")

;;;###autoload
(defun cms-pset-mode ()
  "Major mode for editing cms-pset configuration files.

\\{cms-pset-mode-map}

\\[cms-pset-mode] runs the hook `cms-pset-mode-hook'."
  (interactive)
  (kill-all-local-variables)
  (use-local-map cms-pset-mode-map)
  (set (make-local-variable 'font-lock-defaults)
       '(cms-pset-font-lock-keywords t))
  (make-local-variable 'comment-start)
  (setq comment-start "# ")
  (make-local-variable 'comment-column)
  (setq comment-column 60)
  (setq mode-name "cms-pset")
  (setq major-mode 'cms-pset-mode)
  (run-hooks 'cms-pset-mode-hook))

;; Finish off:
(provide 'cms-pset-mode)
;;; cms-pset-mode.el ends here