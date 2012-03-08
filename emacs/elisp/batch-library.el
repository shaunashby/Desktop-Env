;;
;; Batch functions:
;;

(defun batch-open-logbook()
  "Open logbook."
  (interactive)
  (load-library "logbook-text-mode")
  (find-file (concat (getenv "HOME") "/private/.logbook"))
  (end-of-buffer)
  (insert "\n")
  (log-entry)
  (save-buffer))
