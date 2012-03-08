;;; lat-sgml.el --- Lassi's preferences for HTML, SGML, XML and XSL.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DocBook
(add-hook 'docbook-mode-hook 'turn-on-font-lock)
(add-hook 'docbook-mode-hook 'turn-on-auto-fill)
(add-hook 'docbook-mode-hook
  (function (lambda ()
	      (define-key docbook-mode-map
		[tab]			'docbook-force-electric-tab)
	      (define-key docbook-mode-map
		[(control c) tab]	'docbook-complete))))

(autoload 'docbook-mode "docbookide" "Major mode for DocBook documents." t)
;;(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t )
(autoload 'html-helper-mode "html-helper-mode" "HTML helper mode" t)
(autoload 'xsl-mode "xslide" "Major mode for XSL stylesheets." t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SGML
(setq-default
 sgml-set-face		t
 sgml-auto-activate-dtd	t
 sgml-indent-data	nil
 sgml-indent-step	0
 sgml-catalog-files	`(,(expand-file-name "~/public/sgml/catalogs/docbook")
			  ,(expand-file-name "~/public/sgml/catalogs/dsssl")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; XML
(defun lat::xml-mode ()
  (interactive)
  (autoload 'xml-mode "psgml")
  (setq sgml-catalog-files nil)
  (xml-mode)
  (setq sgml-validate-command "nsgmls -s xml.dcl %s %s"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; XSL
(add-hook 'xsl-mode-hook 'turn-on-font-lock)
(defvar xsl-font-lock-face-attributes
  '((xsl-xsl-main-face "Dark Goldenrod")
    (xsl-xsl-alternate-face "DimGray")
    (xsl-fo-main-face "PaleGreen")
    (xsl-fo-alternate-face "YellowGreen")
    (xsl-other-element-face "Coral"))
  "*List of XSL-specific font lock faces and their attributes")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML
;;(defun insert-html-start ()
;;  (interactive)
;;  (insert "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\">\n\n")
;;  (insert "<!--\n")
;;  (insert "Local variables:\n")
;;  (insert "sgml-default-dtd-file: \""
;;          (concat sgml-default-dtd-file "\"\n"))
;;  (insert "End:\n")
;;  (insert "-->\n"))

;; html-helper-mode
