;;; -*- Mode: lisp-interaction ; Syntax: elisp -*-
;;;
;;;     File: date.el
;;;
;;;     This is a collection of functions to get and insert the date,
;;;     user name & time.  They are useful to append logs and make notes
;;;     in sources.
;;;
;;; Constantine Rasmussen           Sun Microsystems, East Coast Div.   F658
;;;    (508) 671-0404               2 Federal Street; Billerica, Mass. 01824
;;;  ARPA: cdr@sun.com         USENET: {cbosgd,decvax,hplabs,seismo}!sun!cdr
;;;
;;;     Last Modified: Constantine Rasmussen, Dec 27, 1988
;;;

(defun form-comment-string (&optional time-also)
  "Args: (&OPTIONAL TIME-ALSO)
Form comment string for f77 use only. If timealso not nil, time also
appended to date. Known problem, date string is formed at time emacs is
loaded, therefore can be out of date for multiple day sessions."
  (setq comment-string
    (concat
    (format "%s%s %s" "C" (strip-aux-GCOS-info (user-full-name)) (star-date-string time-also))))
    (if (interactive-p)
	(insert comment-string))
    comment-string)

(provide 'date)

(defun strip-aux-GCOS-info (fullname)
  (substring fullname 0 (string-match " *[-:]" fullname)))

(defconst date-month-number
  '(("Jan" . 1) ("Feb" . 2) ("Mar" . 3) ("Apr" . 4) ("May" . 5) ("Jun" . 6)
    ("Jul" . 7) ("Aug" . 8) ("Sep" . 9) ("Oct" . 10) ("Nov" . 11) ("Dec" . 12))
  "Assoc list for looking up the month number from the month
abbreviation.")

(defun star-date-string (&optional time-also year month day hour minute)
  "Args: (&OPTIONAL TIME-ALSO YEAR MONTH DAY HOUR MINUTE) Returns
string with star-date-string.  Useful for timestamps that must be sorted.  If
TIME-ALSO is non-nil the current time is appended resulting in
\"19481112.0700\".  Any element in the time arguments that is nil will
have the current time information substituted.  Similar to the
stardate used on Star Trek."
  (let (date-str
	(cur-time (current-time-string))) ; "Fri Dec  9 14:24:12 1988"
    (if (not year)
	(setq year (string-to-int (substring cur-time -4 nil))))
    (if (not month)
	(setq month
	      (cdr (assoc (substring cur-time 4 7) date-month-number))))
    (if (not day)
	(setq day (string-to-int (substring cur-time 8 10))))
    (cond (time-also
	   (if (not hour)
	       (setq hour (string-to-int (substring cur-time 11 13))))
	   (if (not minute)
	       (setq minute (string-to-int (substring cur-time 14 16))))))
    (setq date-str
	  (concat
	   (format "%d%02d%02d" year month day)
	   (if time-also
	       (format ".%02d%02d" hour minute))))
    (if (interactive-p)
	(insert date-str))
    date-str))

;
; Save desktop from session to session?
;(load "desktop")
;(desktop-load-default)
;(desktop-read)
(custom-set-variables
 '(user-mail-address "Shaun.Ashby@cern.ch" t)
 '(query-user-mail-address nil))
(custom-set-faces)
