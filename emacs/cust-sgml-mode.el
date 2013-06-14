;;
;; cust-sgml-mode.el
;;

;; Modes loaded from this path:
(autoload 'hm--html-mode "hm--html-mode" "HTML major mode." t)
(autoload 'hm--html-minor-mode "hm--html-mode" "HTML minor mode." t)
(setq auto-mode-alist (cons '("\\.html$" . hm--html-mode) auto-mode-alist))
(autoload 'tmpl-expand-templates-in-buffer "tmpl-minor-mode"
  "Expand all templates in the current buffer." t)

(autoload 'html-view-start-mosaic "html-view" "Start Xmosaic." t)
(autoload 'html-view-view-buffer 
  "html-view"
  "View the current buffer in Xmosaic."
  t)

(autoload 'html-view-view-file 
  "html-view"
  "View a file in Xmosaic."
  t)

(autoload 'html-view-goto-url
  "html-view"
  "Goto url in Xmosaic."
  t)

(autoload 'html-view-get-display
  "html-view"
  "Get the display for Xmosaic (i.e. hostxy:0.0)."
  t)

(autoload 'w3-preview-this-buffer "w3" "WWW Previewer" t)
(autoload 'w3 "w3" "WWW Browser" t)
(autoload 'w3-open-local "w3" "Open local file for WWW browsing" t)
(autoload 'w3-fetch "w3" "Open remote file for WWW browsing" t)
(autoload 'w3-use-hotlist "w3" "Use shortcuts to view WWW docs" t)
;; 
(autoload 'html-mode "psgml" "Major mode to edit HTML files." t)

;; Add some stuff for PSGML/XML modes:
(setq auto-mode-alist (cons '("\\.xml\\'" . xml-mode) auto-mode-alist))

;; Autoload for SGML/XML modes:
(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

(defvar sgml-markup-faces
  `((start-tag . 'LightBlue-face)		   
    (end-tag . 'LightBlue-face)
    (comment . 'font-lock-comment-face)
    (pi . 'font-lock-type-face)
    (sgml . 'font-lock-type-face)
    (doctype . 'font-lock-keyword-face)
    (entity . 'Yellow-face)
    (shortref . 'font-lock-string-face)
    (ignored . 'Wheat3-face)
    (ms-start . 'font-lock-constant-face)
    (ms-end .  'font-lock-constant-face))
  "*Alist of markup to face mappings.
Element are of the form (MARKUP-TYPE . FACE).
Possible values for MARKUP-TYPE are:
comment	- comment declaration
doctype	- doctype declaration
end-tag
ignored	- ignored marked section
ms-end	- marked section start, if not ignored
ms-start- marked section end, if not ignored
pi	- processing instruction
sgml	- SGML declaration
start-tag
entity  - general entity reference
shortref- short reference")

;; SGML/XML mode hook:
(add-hook 'sgml-mode-hook
	  (function (lambda ()
		      (setq sgml-set-face t)
		      )))
;;
;; End of cust-sgml-mode.el
;;
