;;; lat-devenv.el --- Lassi's development environment.

(load-library "autoinsert")
(add-hook 'find-file-hooks 'auto-insert)

(setq
 ;; ChangeLog parameters
 add-log-full-name		"Lassi A. Tuura"
 add-log-mailing-address	"lat@iki.fi"

 ;; Autoinsertion mode.  Note that `cms-custom' defines more of these.
 auto-mode-alist		(append '(("\\.uil\\'"	 . c++-mode)
					  ("\\.html\\'"	 . html-helper-mode)
					  ("\\.sgml\\'"	 . docbook-mode)
					  ("\\.xml\\'"   . docbook-mode)
					  ("[Mm]akefile" . makefile-mode)
					  ("\\.dss?s?l$" . dsssl-mode)
					  ("\\.xsl\\'"   . xsl-mode))
					auto-mode-alist)

 auto-insert			t
 auto-insert-directory		(expand-file-name "~/insert/")
 auto-insert-alist		(append '(("\\.y\\'"	. "y-insert.y")
					  ("\\.l\\'"	. "l-insert.l")
					  ("[Mm]akefile\\.in". "Makefile.in")
					  ("\\.uil\\'"	. "uil-insert.uil")
					  ("\\.html\\'"	. "html-insert.html"))
					auto-insert-alist))
