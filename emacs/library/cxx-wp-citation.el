From johnw@borland.com Tue Dec 16 20:12:15 1997
Path: cern.ch!EU.net!news-peer.sprintlink.net!news-sea-19.sprintlink.net!news-in-west.sprintlink.net!news.sprintlink.net!Sprint!143.186.75.30!newslist.borland.com!news
From: "John W. Wiegley" <johnw@borland.com>
Newsgroups: gnu.emacs.sources
Subject: Maintaing citations to the ANSI C++ working paper
Date: 13 Dec 1997 14:45:17 -0800
Organization: Borland International
Lines: 158
Sender: jwiegley@PLATO
Message-ID: <upvn0q2v6.fsf@borland.com>
NNTP-Posting-Host: plato.borland.com
X-Newsreader: Gnus v5.5/Emacs 20.2
Xref: cern.ch gnu.emacs.sources:6443
X-IMAPbase: 1200940182 1
Status: O
X-Status: 
X-Keywords:                       
X-UID: 1

This code may be of limited value, but if anyone out there needs to
manage citations from the ANSI C++ working paper, the following set of
functions make that job MUCH easier.

Basically, while viewing the body.txt file of the ASCII version of the
working paper, select the buffer you want to insert the citation in and
hit "C-c w".  This will insert a reference to that location in the
selected buffer.  Hitting "C-c W" instead will cause the currently
selected region in the WP buffer to be inserted as a quotation.

Then, on any line where a citation has been inserted, you can hit
"M-C-r" to jump to that location in the working paper. (Note that
'cppstd-ansi-std-path' should be updated to reflect where you keep the
ASCII version of the working paper).

John

;; wpref -- Facility for easily managing C++ WP citations
;; Copyright (C) 1997 John Wiegley

;; Author: John Wiegley <johnw@borland.com>
;; Keywords: c languages oop
;; $Revision: 1.1 $
;; $Date: 2005/08/19 10:32:49 $
;; $Source: /afs/cern.ch/user/s/sashby/w1/cvs/repositories/sashby/environment/emacs/library/cxx-wp-citation.el,v $

;; LCD Archive Entry:
;; wpref|John Wiegley|johnw@borland.com|
;; Allow the user to cite the WP, and find references in code|
;; $Date: 2005/08/19 10:32:49 $|$Revision: 1.1 $|
;; |

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;; Facility for easily managing C++ WP citations and references

; Add the following to your .emacs:
;
; (autoload 'goto-wpref-at-point "wpref" nil t)
; (autoload 'goto-wpref "wpref" nil t)
; (autoload 'insert-wpref "wpref" nil t)
; (autoload 'insert-wpref-region "wpref" nil t)
;  
; (define-key global-map "\M-\C-r" 'goto-wpref-at-point)
; (define-key global-map "\M-\C-w" 'goto-wpref)
;
; (define-key global-map "\C-cw" 'insert-wpref)
; (define-key global-map "\C-cW" 'insert-wpref-region))

(defvar cppstd-ansi-std-current "Oct97"
  "Set to the current version of the ANSI C++ standard.")

(defvar cppstd-ansi-std-path '("d:/doc/wp/" "-ASCII/body.txt")
  "Two elements list.  The current date will be inserted between
the two in order to come up with the full path to working paper body.")

;; General routines

(defun wpref-file-name (&optional when)
  (if (not when)
      (setq when cppstd-ansi-std-current))
  (concat (car cppstd-ansi-std-path) when (car (cdr cppstd-ansi-std-path))))

(defun get-current-wpref ()
  "Get the reference of the current point in the WP."
  (save-excursion
    (set-buffer (get-file-buffer (wpref-file-name)))
    (let ((curp (point))
          ref)
      (if (re-search-backward "^\\([0-9]+\\) " nil t)
          (let ((para (buffer-substring-no-properties (match-beginning 1) (match-end 1))))
            (if (re-search-backward "^ *\\([0-9.]+\\) [^][]*\\[[a-z.]+\\] *$" nil t)
                (let ((sect (buffer-substring-no-properties (match-beginning 1) (match-end 1))))
                  (setq ref (concat sect " (" para ")")))
              nil))
        nil)
      (goto-char curp)
      ref)))

(defun get-current-wpcite ()
  "Get the reference of the current point in the WP."
  (save-excursion
    (set-buffer (get-file-buffer (wpref-file-name)))
    (buffer-substring-no-properties (mark) (point))))

(defun insert-wpref-at-point (section)
  "Insert a WP reference at point."
  (interactive "sSection number: ")
  (insert (concat "WP " cppstd-ansi-std-current " " section)))

(defun insert-wpref ()
  "Insert a WP reference in the other buffer, from context."
  (interactive)
  (let ((ref (get-current-wpref)))
    (if ref
        (progn
          (if (string= (buffer-name) "body.txt")
              (other-window 1))
          (insert-wpref-at-point ref))
      (insert-wpref-at-point "? (?)"))))

(defun insert-wpref-region ()
  "Insert a WP reference in the other buffer, from context."
  (interactive)
  (let ((ref (get-current-wpref))
        (cite (get-current-wpcite)))
    (if ref
        (progn
          (if (string= (buffer-name) "body.txt")
              (other-window 1))
          (insert-wpref-at-point (concat ref ": \"" cite "\"")))
      (insert-wpref-at-point (concat "? (?): \"" cite "\"")))))

(defun goto-wpref (when sect para)
  (interactive "sDate: \nsSection: \nsParagraph: ")
  (let (ansi-body)
    (setq ansi-body (wpref-file-name when))
    (find-file-other-window ansi-body)
    (let ((ansi-buffer (get-file-buffer ansi-body)))
      (switch-to-buffer ansi-buffer)
      (beginning-of-buffer)
      (if (re-search-forward (concat "^ +" sect " [^][]+\\[[a-z.]+\\] *$") nil t)
          (progn
            (and para (re-search-forward (concat "^" para " ")))
            (recenter (/ (window-height) 4)))))))

(defun goto-wpref-at-point ()
  "Jump to the WP reference given at point, mentioned on the current line."
  (interactive)
  (beginning-of-line)
  (let* ((begin (point))
         (end (progn (end-of-line) (point))))
    (if (re-search-backward
         " WP \\([A-Za-z][a-z][a-z][0-9][0-9]\\) \\([0-9.]+\\)\\( (\\([0-9]\\))\\)?"
         begin t)
        (let ((when (buffer-substring-no-properties (match-beginning 1) (match-end 1)))
              (sect (buffer-substring-no-properties (match-beginning 2) (match-end 2)))
              para
              ansi-body)
          (if (match-beginning 4)
              (setq para (buffer-substring-no-properties (match-beginning 4) (match-end 4))))
          (goto-wpref when sect para))
      (find-file-other-window (wpref-file-name cppstd-ansi-std-current)))))

;;; end of e-lisp
(provide 'wpref)

