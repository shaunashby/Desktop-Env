;; frame-status-line.el -- -- move time & mail display to frame

;; ======================================================================
;; From: tjic@porsche.icd.teradyne.com (Travis Corcoran)
;; Date: 25 Apr 1995 17:25:59 GMT
;; Subject: Re: Can Emacs inform me when new mail arrives?
;; 
;; As I often split my emacs window vertically, my modelines get double
;; crammed (with redundant information).  For this reason I wrote some
;; code that moved the time to the X windows drag bar.
;; 
;; This is ripped out of a larger set of functions that I use for
;; tracking various activities, so it is not ready to paste-and-go, but 5
;; min of cleanup should get it working.
;;
;; TJIC (Travis J.I. Corcoran)  

;; ======================================================================
;; changes by: Jari Aalto <jaalto.tre.tele.nokia.fi>
;; What you see here, complete .el,  is the result of 5min cleanup :'>

;;; Installation:

;; - Put this file on your Emacs-Lisp load path, add following into your
;;   ~/.emacs startup file
;;
;;      ;;  first ake sure we have the time display package loaded.
;;      ;;  Shame, it doesn't seem to have provide...
;;	(if (not (fboundp 'display-time)) (load "time"))
;;	;;  now make the process active
;;	(display-time)
;;      ;;  move the time to frame!
;;      (require 'frame-status-line)

;;; ----------------------------------------------------------------------
;;;
(defvar no-mail-string " ----"
  "*String to be printed to mode line when no mail is pending")

(defvar yes-mail-string " ####"
  "*String to be printed to mode line when mail is pending")

(defvar beep-for-mail t
  "*If non-nil, beep when mail arrives")

(defvar supress-day-of-week t
  "*Meaningful only if display-time-day-and-date is set.
If non-nil, supress day of week")

(defvar mail-waiting nil
  "Internal use variable.  if mail is pending - non-nil")


;;; ----------------------------------------------------------------------
;;;
(defun display-time-filter (proc string)
  (let ((time (current-time-string))
	(load
	 (condition-case ()
	     (if (zerop (car (load-average))) ""
	       (let ((str (format " %03d" (car (load-average)))))
		 (concat (substring str 0 -2) "." (substring str -2))))
	   (error "")))
	(mail-spool-file (or display-time-mail-file
			     (getenv "MAIL")
			     (concat rmail-spool-directory
				     (user-login-name))))
	hour am-pm-flag mail-flag)

    (setq hour (read (substring time 11 13)))

    (if display-time-24hr-format nil	;ignore this
      (setq am-pm-flag (if (>= hour 12) "pm" "am"))
      (if (> hour 12)
	  (setq hour (- hour 12))
	(if (= hour 0)
	    (setq hour 12)))
      (setq am-pm-flag ""))

    (setq mail-flag
	  (if (and (or (null display-time-server-down-time)
		       ;; If have been down for 20 min, try again.
		       (> (- (nth 1 (current-time))
			     display-time-server-down-time)
			  1200))
		   (let ((start-time (current-time)))
		     (prog1
			 (display-time-file-nonempty-p mail-spool-file)
		       (if (> (- (nth 1 (current-time)) (nth 1 start-time))
			      20)
			   ;; Record that mail file is not accessible.
			   (setq display-time-server-down-time
				 (nth 1 (current-time)))
			 ;; Record that mail file is accessible.
			 (setq display-time-server-down-time nil))
		       )))
	      ;; from here down is my code -------------------
	      yes-mail-string
	    no-mail-string))
    ;; ........................................................ mail-flag ...

    (if (equal mail-flag yes-mail-string)
        (if mail-waiting
	    (setq mail-waiting nil)
	  (if beep-for-mail (beep))
	  (setq mail-waiting t)))

    (setq display-time-string
	  (concat (format "%d" hour) (substring time 13 16)
		  am-pm-flag
		  load ))

    ;; Append the date if desired.
    (if display-time-day-and-date
	(setq display-time-string
	      (concat (substring time 0 11) display-time-string)))

    (drag-bar-update mail-flag)

    (setq display-time-string nil)
    )
  ;; ............................................................... let ...
  (run-hooks 'display-time-hook)
  ;;   Force redisplay of all buffers' mode lines to be considered.
  (save-excursion (set-buffer (other-buffer)))
  (set-buffer-modified-p (buffer-modified-p))
  ;;   Do redisplay right now, if no input pending.
  (sit-for 0))


;;; ----------------------------------------------------------------------
;;;
(defvar old-mail-flag nil)
(defvar old-time-string nil)
(defvar old-frame-string nil)

(defun drag-bar-update (mail-flag)
  "Updates the frmae's status line."
  ;; only update the bar when needed,
  ;; no matter how often this function
  ;; is called
  (if (or (not (string= old-mail-flag mail-flag))
	  (not (string= old-time-string display-time-string))
	  )
      (progn
	;;  Save the contents of frame name, eg. host name
	(if old-frame-string nil		;already saved
	  (setq
	   old-frame-string
	   (cdr (assq 'name  (frame-parameters (selected-frame))))
	   ))
	(setq old-mail-flag mail-flag
	      old-time-string display-time-string)
	(modify-frame-parameters
	 (selected-frame)
	 (list (cons 'name
		     (concat
		      old-frame-string " "
		      display-time-string
		      mail-flag
		      ))))
	;; ............... end progn ..........
	)))


(provide 'frame-status-line)

;;; end of file
