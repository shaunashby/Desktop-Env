;;; lxr.el --- XEmacs interface to lxr source browser

;; Copyright (C) 2000,2001 Sean MacLennan
;; Revision:   1.3
;; XEmacs/Emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; For Linux Kernel
;; (setq lxr-url "http://lxr.linux.no"
;;       lxr-version "2.4.0"
;;       lxr-base (file-truename "/usr/src/linux")

(defvar lxr-url nil
  "*URL to use for lxr")

(defvar lxr-version nil
  "*Version string for lxr or nil for default")

(defvar lxr-arch nil
  "*Architecture for lxr or nil for default.
You should never need to set this....")

(defvar lxr-base nil
  "*Base for lxr files")

(defvar lxr-base-prefix nil
  "*Base prefix to remove from lxr-found files")

(defvar lxr-keymap nil
  "Keymap for lxr buffer.")

;;;###autoload
(defun lxr-at-point ()
  (interactive)
  (lxr (if nil ;; (region-exists-p)
	   (buffer-substring (region-beginning) (region-end))
	 (current-word))))

;;;###autoload
(defun lxr (ident)
  (interactive "sIdentifier: ")
  (unless lxr-url (setq lxr-url (read-string "lxr url: ")))
  (unless lxr-base (setq lxr-base (read-string "lxr base: ")))
  (unless lxr-keymap
    (setq lxr-keymap (make-sparse-keymap "lxr"))
    (if (boundp 'running-xemacs)
	(progn
	  (define-key lxr-keymap 'button1 'lxr-mousable)
	  (define-key lxr-keymap 'button2 'lxr-mousable))
      (define-key lxr-keymap [(mouse-1)] 'lxr-mousable)
      (define-key lxr-keymap [(mouse-2)] 'lxr-mousable))
    (define-key lxr-keymap "g" 'lxr-mousable))
  (let ((url (concat lxr-url "/ident?"
		     (if lxr-version (concat "v=" lxr-version ";"))
		     (if lxr-arch (concat "a=" lxr-arch ";"))
		     "i=" ident)))
    (setq buf-lxr-url		lxr-url
	  buf-lxr-version	lxr-version
	  buf-lxr-arch		lxr-arch
	  buf-lxr-base		lxr-base
	  buf-lxr-base-prefix	lxr-base-prefix)
    (http-get-page url "*lxr*" 'lxr-get-sentinel))
  (pop-to-buffer "*lxr*"))

(defun lxr-get-sentinel (proc str)
  ;; First make sure the http command succeeded.  Copy variables from
  ;; the current buffer to the lxr buffer
  (let ((buffer (process-buffer proc)))
    (set-buffer buffer)
    (goto-char (point-min))
    (unless (looking-at "HTTP/[1-9]\\.[0-9]+ 200")
      ;; http error
      (error "http request failed: %s"
	     (buffer-substring (point-min) (progn (end-of-line) (point)))))

    ;; stip the server header
    (if (search-forward-regexp "^[ \t\r]*\n" nil t)
	(delete-region (point-min) (point)))

    ;; make all variables local in this buffer, copied from the original
    ;; these were set above and we copy the across the buffer change.
    (set (make-local-variable 'lxr-url)         buf-lxr-url)
    (set (make-local-variable 'lxr-version)     buf-lxr-version)
    (set (make-local-variable 'lxr-arch)        buf-lxr-arch)
    (set (make-local-variable 'lxr-base)        buf-lxr-base)
    (set (make-local-variable 'lxr-base-prefix) buf-lxr-base-prefix)

    ;; Convert the page to text
    (set-buffer-modified-p nil)
    (html-to-text buffer lxr-keymap)
    (set-buffer-modified-p nil)
    )
  (message "Done"))

;; This is called on a mouse click
(defun lxr-mousable (event)
  (interactive "e")
  (let* ((extent (extent-at (event-point event)
			    ;; SAM (event-buffer event)
			    ))
	 (anchor (extent-property extent 'anchor))
	 (prefix (url-filename (url-generic-parse-url lxr-url)))
	 line file)
    (if (eq (string-match (regexp-quote prefix) anchor) 0)
	(setq anchor (substring anchor (length prefix))))

    (cond
     ;; source file
     ((string-match "^/?source/\\([^#]+\\)#\\([0-9]+\\)" anchor)
      (setq line (string-to-number (match-string 2 anchor)))
      (setq file (match-string 1 anchor))
      ;; Drop a=xyz; and v=xyz; arguments of the file name
      (while (string-match "\\?[a-z]=[^;]*;?" file)
	(setq file (concat (substring file 0 (match-beginning 0))
			   (substring file (match-end 0)))))
      (if (eq (string-match lxr-base-prefix file) 0)
	  (setq file (substring file (match-end 0))))
      (setq file (concat lxr-base file))
      (find-file-other-window file)
      (goto-char 0)
      (forward-line (1- line)))

     ;; ident (e.g. class reference)
     ((string-match "^/?ident" anchor)
      (http-get-page (concat lxr-url "/" anchor) "*lxr*" 'lxr-get-sentinel)
      (pop-to-buffer "*lxr*"))

     ;; generic http (e.g. lxr reference in trailer)
     ((string-match "^http:.*" anchor)
      (browse-url (match-string 0 anchor)))

     ;; huh?
     (t (error "Unknown anchor '%S'" anchor)))
    ))

(unless (boundp 'running-xemacs) (require 'extent))
(require 'url)
(require 'http)
(require 'h2t)
(provide 'lxr)
