;;; $Id: hm--html-drag-and-drop.el,v 1.1.1.1 2003/04/29 15:16:52 sashby Exp $
;;; 
;;; Copyright (C) 1996, 1997 Heiko Muenkel
;;; email: muenkel@tnt.uni-hannover.de
;;;
;;;  This program is free software; you can redistribute it and/or modify
;;;  it under the terms of the GNU General Public License as published by
;;;  the Free Software Foundation; either version 1, or (at your option)
;;;  any later version.
;;;
;;;  This program is distributed in the hope that it will be useful,
;;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;  GNU General Public License for more details.
;;;
;;;  You should have received a copy of the GNU General Public License
;;;  along with this program; if not, write to the Free Software
;;;  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;;
;;; 
;;; Description:
;;;
;;;	This package contains functions to insert links and other
;;;	HTML stuff with the mouse with drag and drop.
;;;
;;;	For further descriptions look at the file 
;;;	internal-drag-and-drop.el, which implements the basic (and
;;;	more genreal functions) for the drag and drop interface.
;;; 
;;; Installation: 
;;;   
;;;	Put this file in your load path.
;;;

(require 'internal-drag-and-drop)
(require 'cl)

;(defun hm--html-first-non-matching-position (string1 string2)
;  "Compares both strings and returns the first position, which is not equal."
;  (let ((n 0)
;	(max-n (min (length string1) (length string2)))
;	(continue t))
;    (while (and continue (< n max-n))
;      (when (setq continue (= (aref string1 n) (aref string2 n)))
;	(setq n (1+ n))))
;    n))

;(defun hm--html-count-subdirs (directory)
;  "Returns the number of subdirectories of DIRECTORY."
;  (let ((n 0)
;	(max-n (1- (length directory)))
;	(count 0))
;    (while (< n max-n)
;      (when (= ?/ (aref directory n))
;	(setq count (1+ count)))
;      (setq n (1+ n)))
;    (when (and (not (= 0 (length directory)))
;	       (not (= ?/ (aref directory 0))))
;      (setq count (1+ count)))
;    count))

;(defun hm--html-return-n-backwards (n)
;  "Returns a string with N ../"
;  (cond ((= n 0) "")
;	(t (concat "../" (hm--html-return-n-backwards (1- n))))))

;(defun* hm--html-file-relative-name (file-name 
;				     &optional (directory default-directory))
;  "Convert FILENAME to be relative to DIRECTORY (default: default-directory)."
;  (let* ((pos (hm--html-first-non-matching-position file-name directory))
;	 (backwards (hm--html-count-subdirs (substring directory pos)))
;	 (relative-name (concat (hm--html-return-n-backwards backwards)
;				(substring file-name pos))))
;    (if (= 0 (length relative-name))
;	"./"
;      (if (= ?/ (aref relative-name 0))
;	  (if (= 1 (length relative-name))
;	      "./"
;	    (substring relative-name 1))
;	relative-name))))

(defun hm--html-idd-add-include-image-from-dired-line (source destination)
  "Inserts an include image tag at the DESTINATION.
The name of the image is on a line in a dired buffer. It is specified by the
SOURCE."
  (idd-set-point destination)
  (if hm--html-idd-create-relative-links
      (hm--html-add-image-top (file-relative-name
			       (idd-get-dired-filename-from-line source))
			      (file-name-nondirectory
			       (idd-get-dired-filename-from-line source)))
    (hm--html-add-image-top (idd-get-dired-filename-from-line source)
			    (file-name-nondirectory
			     (idd-get-dired-filename-from-line source)))))

(defun hm--html-idd-add-link-to-region (link-object destination)
  "Inserts a link with the LINK-OBJECT in the DESTINATION.
It uses the region as the name of the link."
  (idd-set-region destination)
  (hm--html-add-normal-link-to-region link-object)
  )

(defun hm--html-idd-add-link (link-object destination)
  "Inserts a link with the LINK-OBJECT in the DESTINATION."
  (idd-set-point destination)
  (hm--html-add-normal-link link-object))
    
(defun hm--html-idd-add-link-to-point-or-region (link-object destination)
  "Inserts a link with the LINK-OBJECT in the DESTINATION.
It uses the region as the name of the link, if the region was active
in the DESTINATION."
  (if (cdr (assoc ':region-active destination))
      (hm--html-idd-add-link-to-region link-object destination)
    (hm--html-idd-add-link link-object destination)))

(defun hm--html-idd-add-file-link-to-file-on-dired-line (source destination)
  "Inserts a file link in DESTINATION to the file on the dired line of SOURCE."
  (idd-set-point destination)
  (if hm--html-idd-create-relative-links
      (hm--html-idd-add-link-to-point-or-region
       (file-relative-name
	(idd-get-dired-filename-from-line source))
       destination)
    (hm--html-idd-add-link-to-point-or-region
     (concat "file://" (idd-get-dired-filename-from-line source))
     destination)))

(defun hm--html-idd-add-file-link-to-buffer (source destination)
  "Inserts a file link at DESTINATION to the file of the SOURCE buffer."
  (idd-set-point destination)
  (if hm--html-idd-create-relative-links
      (hm--html-idd-add-link-to-point-or-region
       (file-relative-name (idd-get-local-filename source))
       destination)
    (hm--html-idd-add-link-to-point-or-region
     (concat "file://" (idd-get-local-filename source))
     destination)))

(defun hm--html-idd-add-file-link-to-directory-of-buffer (source
							  destination)
  "Inserts a file link at DESTINATION to the directory of the SOURCE buffer."
  (idd-set-point destination)
  (if hm--html-idd-create-relative-links
      (hm--html-idd-add-link-to-point-or-region
       (file-relative-name (idd-get-directory-of-buffer source))
       destination)
    (hm--html-idd-add-link-to-point-or-region
     (concat "file://" (idd-get-directory-of-buffer source))
     destination)))

(defun hm--html-idd-add-html-link-to-w3-buffer (source destination)
  "Inserts a link at DESTINATION to the w3 buffer specified by the SOURCE.
Note: Relative links are currently not supported for this function."
  (idd-set-point destination)
  (hm--html-idd-add-link-to-point-or-region (idd-get-buffer-url source)
					    destination))

(defun hm--html-idd-add-html-link-from-w3-buffer-point (source destination)
  "Inserts a link at DESTINATION to a lin in the w3 buffer.
The link in the w3-buffer is specified by the SOURCE.
Note: Relative links are currently not supported for this function."
  (idd-set-point destination)
  (hm--html-idd-add-link-to-point-or-region (idd-get-url-at-point source)
					    destination))

;;; Announce the feature hm--html-drag-and-drop
(provide 'hm--html-drag-and-drop)
