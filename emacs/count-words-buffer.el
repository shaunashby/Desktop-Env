;;; count-words-buffer.el
(defun count-words-buffer ()
  "Count the number of words in the current buffer; 
print a message in the minibuffer with the result."
  (interactive)
  (save-excursion
    (let ((count 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-word 1)
        (setq count (1+ count)))
      (message "buffer contains %d words." count))))
;;; end count-words-buffer.el
