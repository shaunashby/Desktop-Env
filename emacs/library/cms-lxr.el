;;; cms-lxr.el --- CMS LXR Interface.  Just hit C-c l to make a search.

(load-library "lxr")

(defvar cms-lxr-server
  ;; Get lxcms60 address but strip off trailing linefeed
  (let ((tmp (shell-command-to-string "~lat/bin/ddns which lxcms60")))
    (substring tmp 0 (string-match "\n" tmp)))
  "*Default LXR server to use.")

(defvar cms-lxr-location "/lxr"
  "*Path to LXR on `cms-lxr-server'.")

(defun cms-c-mode-lxr-hook ()
  (define-key c-mode-base-map "\C-cl" 'lxr-at-point)
  (let* ((scram-dir (cms-search-file ".SCRAM" (buffer-file-name)))
	 (root-dir  (and scram-dir (file-name-directory scram-dir)))
	 (base      (and root-dir (file-name-nondirectory
				   (directory-file-name root-dir))))
	 (project   (and root-dir (substring base 0 (string-match "_" base)))))
    (if root-dir
	(progn
	  (make-local-variable 'lxr-url)
	  (make-local-variable 'lxr-version)
	  (make-local-variable 'lxr-arch)
	  (make-local-variable 'lxr-base)
	  (make-local-variable 'lxr-base-prefix)

	  (setq
	   lxr-url		(concat "http://" cms-lxr-server
					cms-lxr-location "/" project)
	   lxr-version		"snapshot" ;; FIXME: Guess from area/tag?
	   lxr-arch		nil
	   lxr-base		(concat root-dir "src")
	   lxr-base-prefix	(concat project "/src"))))))

(add-hook 'c-mode-common-hook 'cms-c-mode-lxr-hook)
