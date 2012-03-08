;;; $Id: hm--date.el,v 1.1.1.1 2003/04/29 15:16:52 sashby Exp $
;;;
;;; Copyright (C) 1993, 1996  Heiko Muenkel
;;; email: muenkel@tnt.uni-hannover.de
;;;
;;;  This program is free software; you can redistribute it and/or modify
;;;  it under the terms of the GNU General Public License as published by
;;;  the Free Software Foundation; either version 2, or (at your option)
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
;;;	Defines the function hm--date, which returns the date in the
;;;	format "day-month-year" like "30-Jun-1993".
;;; 
;;; Installation: 
;;;   
;;;	Put this file in one of your lisp load path directories.
;;;	The files which uses this function must only have
;;;	following line:
;;;		(require 'hm--date)
;;;


(provide 'hm--date)



(defun hm--date ()
  "Returns the current date in the format \"day-month-year\"."
  (let* ((time-string (current-time-string))
	(day (substring time-string 8 10))
	(month (substring time-string 4 7))
	(year (substring time-string 20 24)))
    (concat day "-" month "-" year)))

(defun hm--date-time ()
  "Returns the date & time (eg as \"day-month-year at hours:minutes\")
The format can be changed by the variable `hm--html-log-date-format'."
  (when (or (boundp 'hm--hmtl-include-time-after-date)
	    (boundp 'hm--html-date-time-separator))
    (warn 
     "You are still using one or both of the no longer supported variables \n"
     "`hm--hmtl-include-time-after-date' and `hm--html-date-time-separator'."
     "You are now able to get the same effect by using the new variable\n"
     "`hm--html-log-date-format'.\n\n."
     "Type `M-x customize-variable hm--html-log-date-format', if you will\n"
     "change the variable.\n\n"
     "Don't forget to remove the old variables from your ~/.emacs or one\n"
     "of your other emacs configuration files."))
  (format-time-string hm--html-log-date-format (current-time)))

;(defun hm--date-time ()
;  "Returns the date & time as \"day-month-year xx hours:minutes\",
;where xx is specified by the user variable hm--html-date-time-separator.
;The time and date-time separator portion is only returned if the
;user variable hm--hmtl-include-time-after-date is not nil."
;  (let* ((time-string (current-time-string))
; 	 (time (substring time-string 11 16))
; 	 (day (substring time-string 8 10))
; 	 (month (substring time-string 4 7))
; 	 (year (substring time-string 20 24)))
;    (if hm--hmtl-include-time-after-date
; 	(concat day "-" month "-" year 
; 		hm--html-date-time-separator time)
;      (concat day "-" month "-" year))))
