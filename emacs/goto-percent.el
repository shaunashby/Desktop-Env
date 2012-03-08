;;; goto-percent.el
(defun goto-percent (pct)
"Go to PERCENT point of buffer."
  (interactive "nPercent: ")
  (goto-char (/ (* pct (point-max)) 100)))
;;; end goto-percent.el
