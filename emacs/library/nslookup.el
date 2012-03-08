(defun nslookup ()
  "Run an inferior nslookup, with I/O through buffer *nslookup*.
\(Type \\[describe-mode] in the nslookup buffer for a list of commands.)"
  (interactive)
  (require 'comint)
  (switch-to-buffer (get-buffer-create "*nslookup*"))
  (or (comint-check-proc "*nslookup*")
      (let (mode-line-buffer-identification)
	(make-local-hook 'comint-output-filter-functions)
	(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m nil t)
	(make-local-variable 'server)
	(make-comint "nslookup" "nslookup")
	(set-process-filter
	 (get-buffer-process (current-buffer))
	 (lambda (proc str)
	   (if (string-match
		"^\\(Default \\(Name \\)?\\)?Server:  \\(.+\\)\n\\(.+\n\\)*\n?"
		str)
	       (setq server (match-string 3 str)
		     str (substring str (match-end 0))))
	   (comint-output-filter proc
				 (if (string-match "^\n*>" str)
				     (replace-match (concat server ">") t t str)
				   str))))
	(make-local-variable 'font-lock-keywords)
	(setq mode-name "DNS"
	      font-lock-keywords
		'(("^\\([^<\n ]*>\\) \\(.*\\)"
		   (1 'bold)
		   (2 'italic))
		  ("\\*\\*\\*.+\\|^Non-authoritative answer:$"
		   (0 font-lock-variable-name-face))
		  (":[ \t]+\\([-_.a-z0-9]+\\)$"
		   (1 font-lock-string-face t))
		  ("^\\([-_.a-zA-Z0-9]+\\)>"
		   (0 'plain))
		  ("^\\([-_a-zA-Z0-9]+\\.[-_.a-zA-Z0-9]+\\)"
		   (1 'font-lock-string-face keep))
		  ("\\([a-z ]*\\)[ \t]=[ \t]\\(.*\\)$"
		   (1 font-lock-function-name-face)
		   (2 font-lock-type-face)))
	      comint-prompt-regexp "^.*> ")
	(font-lock-mode 1))))
