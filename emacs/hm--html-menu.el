;;;  hm--html-menu ---  A menu for the hm--html-mode.
;;;  
;;;  $Id: hm--html-menu.el,v 1.1.1.1 2003/04/29 15:16:52 sashby Exp $
;;;
;;;  Copyright (C) 1993 - 1998  Heiko Muenkel
;;;  email: muenkel@tnt.uni-hannover.de
;;;
;;;  This program is free software; you can redistribute it and/or modify
;;;  it under the terms of the GNU General Public License as published by
;;;  the Free Software Foundation; either version 2, or (at your option)
;;;  any later version.
;;;
;;;  This program is distributed in the hope that it will be useful,
;;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;  GNU General Public License for more details.
;;;
;;;  You should have received a copy of the GNU General Public License
;;;  along with this program; if not, write to the Free Software
;;;  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;;
;;; 
;;; Description:
;;;
;;;	Defines pulldown and popup menus for the html mode (hm--html-mode).
;;;
;;;	You should also have the w3 package from William M. Perry, for
;;;	browsing html- files in the xemacs and the program Xmosaic together
;;;	with the file html-view.el from Ron Tapia for browsing html- files
;;;	in the Xmosaic.
;;; 
;;; Installation: 
;;;   
;;;	Put this file in one of your load path directories.
;;;
;;;     Look at the files hm--html-mode.el and hm--html-configuration
;;;     for further installation points.
;;;

;;
;; Menu "HTML"
;;

(defvar hm--html-pulldown-menu nil "*A List with the HTML-Menu.")
(defvar hm--html-menu-region-expert nil "*A List with the HTML-Menu.")
(defvar hm--html-menu-region-novice nil "*A List with the HTML-Menu.")
(defvar hm--html-menu-noregion-expert nil "*A List with the HTML-Menu.")
(defvar hm--html-menu-noregion-novice nil "*A List with the HTML-Menu.")

(setq hm--html-menu-noregion-expert
       '("HTML Noregion Expert Menu"
	 ("Anchors"
	  ["Relative link..." hm--html-add-relative-link t]
	  ["General link..." hm--html-add-normal-link t]
	  ["Drag & Drop"
	   idd-start-mouse-drag-and-drop
	   :active t
	   :keys "\\[idd-mouse-drag-and-drop]"]
	  "----"
	  ["Html link..." hm--html-add-html-link t]
	  ["Info link..." hm--html-add-info-link t]
	  ["Gopher link..." hm--html-add-gopher-link t]
	  ["File link..." hm--html-add-file-link t]
	  "----"
	  ["Ftp link..." hm--html-add-ftp-link t]
	  ["News link..." hm--html-add-news-link t]
	  ["Mailbox link..." hm--html-add-mail-box-link t]
	  ["Mailto link..." hm--html-add-mailto-link t]
	  ["Wais link (direct)..." hm--html-add-direct-wais-link t]
	  ["Wais link (gateway)..." hm--html-add-wais-link t]
	  "----"
	  ["CGI link..." hm--html-add-cgi-link t]
	  ["Proggate link..." hm--html-add-proggate-link t]
	  ["Local Proggate link..." hm--html-add-local-proggate-link t]
	  "----"
	  ["Link target..." hm--html-add-link-target t]
	  )
	 ("Frame"
	  ["Full html frame..." hm--html-add-full-html-frame t]
	  ["Frame template..." 
	   (hm--html-insert-template hm--html-frame-template-file)
	   (file-exists-p hm--html-frame-template-file)]
	  "----"
	  ["Doctype" hm--html-add-doctype t]
	  ["Html" hm--html-add-html t]
	  ["Head" hm--html-add-head t]
	  ["Body" hm--html-add-body t]
	  "----"
	  ["Title and Header..." hm--html-add-title-and-header t]
	  ["Title..." hm--html-add-title t]
	  ["Header..." hm--html-add-header t]
	  ["Address" hm--html-add-address t]
	  ["Signature" hm--html-add-signature t]
	  "----"
	  ["Meta information..." hm--html-add-meta t]
	  ["Node Link..." hm--html-add-normal-node-link t]
	  ["Isindex..." hm--html-add-isindex t]
	  ["Document Base..." hm--html-add-base t]
	  "----"
	  ["Created comment" hm--html-insert-created-comment t]
	  ["Changed comment" hm--html-insert-changed-comment t]
	  ["Modified line" hm--html-insert-modified-line t]
	  ["New date in title" hm--html-new-date t]
	  )
	 ("Structure"
	  ["Menu or list item" hm--html-add-list-or-menu-item t]
	  ["Menu" hm--html-add-menu t]
	  ["Unordered list" hm--html-add-list t]
	  ["Ordered list" hm--html-add-numberlist t]
	  ["Directory list" hm--html-add-directory-list t]
	  "----"
	  ["Description list" hm--html-add-description-list t]
	  ["Description title" hm--html-add-description-title t]
	  ["Description entry" hm--html-add-description-entry t]
	  ["Description title + entry" 
	   hm--html-add-description-title-and-entry t]
	  "----"
	  ["Table..." hm--html-add-table t]
	  ["Table title..." hm--html-add-table-title t]
	  ["Table header..." hm--html-add-table-header t]
	  ["Table first row..." hm--html-add-first-table-row t]
	  ["Table additional row..." hm--html-add-additional-table-row t]
	  ("Additional Commands"
	   ["Table row frame..." hm--html-add-row-frame t]
	   ["Table header entry..." hm--html-add-header-entry t]
	   ["Table row entry..." hm--html-add-row-entry t]
	   ["Span columns..." hm--html-table-add-colspan-attribute t]
	   ["Span rows..." hm--html-table-add-rowspan-attribute t]
	   )
	  "----"
	  ["Paragraph container" hm--html-add-paragraph t]
	  ["Paragraph start tag" hm--html-add-paragraph-separator t]
	  ["Document division" hm--html-add-document-division t]
	  ["New line" hm--html-add-line-break t]
	  ["Horizontal rule" hm--html-add-horizontal-rule t]
	  )
	 ("Formatting Paragraphs"
;	  ["Without links" hm--html-add-plaintext t]
	  ["Preformatted" hm--html-add-preformatted t]
          ["Blockquote" hm--html-add-blockquote t]
	  "----"
	  ["Basefont..." hm--html-add-basefont t]
	  ["Font..." hm--html-add-font t]
	  ["Center" hm--html-add-center t]
	  ["Style" hm--html-add-style t]
	  "----"
	  ["HTML Comment" hm--html-add-comment t]
;	  ["Listing" hm--html-add-listing t]
;	  ["Abstract" hm--html-add-abstract t]
	  )
	 ("Formatting Words"
	  ["Bold" hm--html-add-bold t]
	  ["Italic" hm--html-add-italic t]
          ["Typewriter" hm--html-add-fixed t]
	  ["Small" hm--html-add-small t]
	  ["Big" hm--html-add-big t]
	  ["Superscript" hm--html-add-superscript t]
	  ["Subscript" hm--html-add-subscript t]
	  "----"
	  ["Underline" hm--html-add-underline t]
	  ["Strikethru" hm--html-add-strikethru t]
	  "----"
;          ["Emphasized" hm--html-add-emphasized t]
;          ["Strong" hm--html-add-strong t]
;	   "----"
	  ("Phrase"
	   ["Emphasized" hm--html-add-emphasized t]
	   ["Strong" hm--html-add-strong t]
	   "----"
	   ["Definition" hm--html-add-definition t]
	   ["Keyboard" hm--html-add-keyboard t]
	   ["Variable" hm--html-add-variable t]
	   ["Code" hm--html-add-code t]
	   ["Sample" hm--html-add-sample t]
	   ["Citation" hm--html-add-citation t]
	   )
;; All the following commands are still implemented, but most
;; of them are not defined in HTM 3.2
;; You've to load hm--html-not-standard.el to use them
;	  ("Computing"
;	   ["Definition" hm--html-add-definition t]
;	   ["Keyboard" hm--html-add-keyboard t]
;	   ["Command" hm--html-add-command t]
;	   ["Argument" hm--html-add-argument t]
;	   ["Option" hm--html-add-option t]
;	   ["Variable" hm--html-add-variable t]
;	   ["Instance" hm--html-add-instance t]
;	   ["Code" hm--html-add-code t]
;	   ["Sample" hm--html-add-sample t]
;	   )
;	  ("Literature"
;	   ["Quote" hm--html-add-quote t]
;	   ["Acronym" hm--html-add-acronym t]
;	   ["Abbreviation" hm--html-add-abbreviation t]
;	   ["Citation" hm--html-add-citation t]
;	   ["Literature" hm--html-add-literature t]
;	   ["Publication" hm--html-add-publication t]
;	   ["ISBN" hm--html-add-isbn t]
;	   )
;	  ("Person"
;	   ["Person" hm--html-add-person t]
;	   ["Author" hm--html-add-author t]
;	   ["Editor" hm--html-add-editor t]
;	   ["Credits" hm--html-add-credits t]
;	   ["Copyright" hm--html-add-copyright t]
;	   )
;	  "----"
;	  ["Footnote" hm--html-add-footnote t]
;	  ["Margin" hm--html-add-margin t]
;	  "----"
;	  ["HTML Comment" hm--html-add-comment t]
	  )
	 ("Include"
	  ["Top aligned image..." hm--html-add-image-top t]
	  ["Middle aligned image..." hm--html-add-image-middle t]
	  ["Bottom aligned image..." hm--html-add-image-bottom t]
	  ["Image as map? ..." hm--html-add-image t]
	  ["Drag & Drop"
	   idd-start-mouse-drag-and-drop
	   :active t
	   :keys "\\[idd-mouse-drag-and-drop]"]
	  "----"
	  ["Image map..." hm--html-add-image-map t]
	  ["Map..." hm--html-add-map t]
	  ["Area..." hm--html-add-area t]
	  "----"
	  ["Applet..." hm--html-add-applet t]
	  ["Parameter..." hm--html-add-applet-parameter t]
	  ["Script" hm--html-add-script t]
;	  "----"
;	  ["File..."  hm--html-add-server-side-include-file t]
;	  ["Command..." hm--html-add-server-side-include-command t]
;	  ["Command with isindex parameter..." 
;	   hm--html-add-server-side-include-command-with-isindex-parameter
;	   t]
	  )
	 ("Forms"
	  ["Form..." hm--html-add-form t]
	  "----"
	  ["Text field..." hm--html-form-add-input-text t]
	  ["Password field..." hm--html-form-add-input-password t]
	  ["Isindex field..." hm--html-form-add-input-isindex t]
	  ["Integer field..." hm--html-form-add-input-integer t]
	  ["Float field..." hm--html-form-add-input-float t]
	  ["Date field..." hm--html-form-add-input-date t]
	  ["Url field..." hm--html-form-add-input-url t]
	  ["Scribble field..." hm--html-form-add-input-scribble t]
	  "----"
	  ["Checkbox button..." hm--html-form-add-input-checkbox t]
	  ["Radio button..." hm--html-form-add-input-radio t]
	  ["Reset button..." hm--html-form-add-input-reset t]
	  ["Submit button..." hm--html-form-add-input-submit t]
	  ["Image button..." hm--html-form-add-input-image t]
	  ["Audio button..." hm--html-form-add-input-audio t]
	  "----"
	  ["Option Menu..." hm--html-form-add-select-option-menu t]
	  ["Scrolled List..." hm--html-form-add-select-scrolled-list t]
	  ["Option..." hm--html-form-add-select-option t]
	  "----"
	  ["Textarea..." hm--html-form-add-textarea t]
	  )
	 ))


(setq hm--html-menu-noregion-novice
       '("HTML No-region Novice Menu"
	 ("Anchors"
	  ["Relative link..." hm--html-add-relative-link t]
	  ["Drag & Drop"
	   idd-start-mouse-drag-and-drop 
	   :active t
	   :keys "\\[idd-mouse-drag-and-drop]"]
	  "----"
	  ["Html link..." hm--html-add-html-link t]
	  ["File link..." hm--html-add-file-link t]
	  )
	 ("Frame"
	  ["Full html frame..." hm--html-add-full-html-frame t]
	  "----"
	  ["Title and Header..." hm--html-add-title-and-header t]
	  ["Signature" hm--html-add-signature t]
	  )
	 ("Structure"
	  ["Menu item" hm--html-add-list-or-menu-item t]
	  ["Menu" hm--html-add-menu t]
	  "----"
	  ["Paragraph Container" hm--html-add-paragraph t]
	  )
	 ("Formatting Paragraphs"
;	  ["Without links" hm--html-add-plaintext t]
	  ["Preformatted" hm--html-add-preformatted t]
	  )
	 ("Formatting Words"
	  ["Bold" hm--html-add-bold t]
	  ["Italic" hm--html-add-italic t]
	  ["Underline" hm--html-add-underline t]
          ["Typewriter" hm--html-add-fixed t]
	  )))

(setq hm--html-menu-region-expert
       '("HTML Region Expert Menu"
	 ("Anchors"
	  ["Relative link..." hm--html-add-relative-link-to-region t]
	  ["General link..." hm--html-add-normal-link-to-region t]
	  ["Drag & Drop"
	   idd-start-mouse-drag-and-drop 
	   :active t
	   :keys "\\[idd-mouse-drag-and-drop]"]
	  "----"
	  ["Html link..." hm--html-add-html-link-to-region t]
	  ["Info link..." hm--html-add-info-link-to-region t]
	  ["Gopher link..." hm--html-add-gopher-link-to-region t]
	  ["File link..." hm--html-add-file-link-to-region t]
	  "----"
	  ["Ftp link..." hm--html-add-ftp-link-to-region t]
	  ["News link..." hm--html-add-news-link-to-region t]
	  ["Mailbox link..." hm--html-add-mail-box-link-to-region t]
	  ["Mailto link..." hm--html-add-mailto-link-to-region t]
	  ["WAIS link (direct)..." hm--html-add-direct-wais-link-to-region t]
	  ["WAIS link (gateway)..." hm--html-add-wais-link-to-region t]
	  "----"
	  ["CGI link..." hm--html-add-cgi-link-to-region t]
	  ["Proggate link..." hm--html-add-proggate-link-to-region t]
	  ["Local Proggate link..." 
	   hm--html-add-local-proggate-link-to-region 
	   t]
	  "----"
	  ["Link target..." hm--html-add-link-target-to-region t]
	  )
	 ("Frame"
	  ["Full html frame..." hm--html-add-full-html-frame-with-region t]
	  "----"
	  ["Head" hm--html-add-head-to-region t]
	  ["Body" hm--html-add-body-to-region t]
	  "----"
	  ["Title and Header..." hm--html-add-title-and-header-to-region t]
	  ["Title" hm--html-add-title-to-region t]
	  ["Header..." hm--html-add-header-to-region t]
	  ["Address" hm--html-add-address-to-region t]
	  )
	 ("Structure"
	  ["Menu item" hm--html-add-list-or-menu-item-to-region t]
	  ["Menu" hm--html-add-menu-to-region t]
	  ["Unordered list" hm--html-add-list-to-region t]
	  ["Ordered list" hm--html-add-numberlist-to-region t]
	  ["Directory list" hm--html-add-directorylist-to-region t]
	  "----"
	  ["Description list" hm--html-add-description-list-to-region t]
	  ["Description title" hm--html-add-description-title-to-region t]
	  ["Description entry" hm--html-add-description-entry-to-region t]
	  "----"
	  ["Table..." hm--html-add-table-to-region t]
	  ["Table Title..." hm--html-add-table-title-to-region t]
	  ("Additional Commands"
	   ["Table row frame..." hm--html-add-row-frame-to-region t]
	   )
	  "----"
	  ["Paragraph container" hm--html-add-paragraph-to-region t]
	  ["Document division" hm--html-add-document-division-to-region t]
	  )
	 ("Formatting Paragraphs"
;	  ["Without links" hm--html-add-plaintext-to-region t]
	  ["Preformatted" hm--html-add-preformatted-to-region t]
          ["Blockquote" hm--html-add-blockquote-to-region t]
	  "----"
	  ["Font..." hm--html-add-font-to-region t]
	  ["Center" hm--html-add-center-to-region t]
	  ["Style" hm--html-add-style-to-region t]
	  "----"
	  ["HTML Comment" hm--html-add-comment-to-region t]
;	  ["Listing" hm--html-add-listing-to-region t]
;	  ["Abstract" hm--html-add-abstract-to-region t]
	  )
	 ("Formatting Words"
	  ["Bold" hm--html-add-bold-to-region t]
	  ["Italic" hm--html-add-italic-to-region t]
          ["Typewriter" hm--html-add-fixed-to-region t]
	  ["Small" hm--html-add-small-to-region t]
	  ["Big" hm--html-add-big-to-region t]
	  ["Superscript" hm--html-add-superscript-to-region t]
	  ["Subscript" hm--html-add-subscript-to-region t]
	  "----"
	  ["Underline" hm--html-add-underline-to-region t]
	  ["Strikethru" hm--html-add-strikethru-to-region t]
	  ;;	  ["Render" hm--html-add-render-to-region t]
	  "----"
;          ["Emphasized" hm--html-add-emphasized-to-region t]
;          ["Strong" hm--html-add-strong-to-region t]
;	  "----"
	  ("Phrase"
	   ["Emphasized" hm--html-add-emphasized-to-region t]
	   ["Strong" hm--html-add-strong-to-region t]
	   "----"
	   ["Definition" hm--html-add-definition-to-region t]
	   ["Keyboard" hm--html-add-keyboard-to-region t]
	   ["Variable" hm--html-add-variable-to-region t]	  
	   ["Code" hm--html-add-code-to-region t]
	   ["Sample" hm--html-add-sample-to-region t]
	   ["Citation" hm--html-add-citation-to-region t]
	   )
;; All the following commands are still implemented, but most
;; of them are not defined in HTM 3.2
;	  ("Computing"
;	   ["Definition" hm--html-add-definition-to-region t]
;	   ["Keyboard" hm--html-add-keyboard-to-region t]
;	   ["Command" hm--html-add-command-to-region t]
;	   ["Argument" hm--html-add-argument-to-region t]
;	   ["Option" hm--html-add-option-to-region t]
;	   ["Variable" hm--html-add-variable-to-region t]	  
;	   ["Instance" hm--html-add-instance-to-region t]
;	   ["Code" hm--html-add-code-to-region t]
;	   ["Sample" hm--html-add-sample-to-region t]
;	   )
;	  ("Literature"
;	   ["Quote" hm--html-add-quote-to-region t]
;	   ["Acronym" hm--html-add-acronym-to-region t]
;	   ["Abbrevation" hm--html-add-abbrevation-to-region t]
;	   ["Citation" hm--html-add-citation-to-region t]
;	   ["Literature" hm--html-add-literature-to-region t]
;	   ["Publication" hm--html-add-publication-to-region t]
;	   ["ISBN" hm--html-add-isbn-to-region t]
;	   )
;	  ("Person"
;	   ["Person" hm--html-add-person-to-region t]
;	   ["Author" hm--html-add-author-to-region t]
;	   ["Editor" hm--html-add-editor-to-region t]
;	   ["Credits" hm--html-add-credits-to-region t]
;	   ["Copyright" hm--html-add-copyright-to-region t]
;	   )
;	  "----"
;	  ["Footnote" hm--html-add-footnote-to-region t]
;	  ["Margin" hm--html-add-margin-to-region t]
;	  "----"
;	  ["HTML Comment" hm--html-add-comment-to-region t]
	  )
	 ("Include"
	  ["Map..." hm--html-add-map-to-region t]
	  "----"
	  ["Applet..." hm--html-add-applet-to-region t]
	  ["Script" hm--html-add-script-to-region t]
	  )
	 ("Forms"
	  ["Form..." hm--html-add-form-to-region t])
	 ))


(setq hm--html-menu-region-novice
      '("HTML Region Novice Menu"
	 ("Anchors"
	  ["Relative link..." hm--html-add-relative-link-to-region t]
	  ["Drag & Drop"
	   idd-start-mouse-drag-and-drop 
	   :active t
	   :keys "\\[idd-mouse-drag-and-drop]"]
	  "----"
	  ["Html link..." hm--html-add-html-link-to-region t]
	  ["File link..." hm--html-add-file-link-to-region t]
	  )
	 ("Frame"
	  ["Full html frame..." hm--html-add-full-html-frame-with-region t]
	  "----"
	  ["Title and Header..." hm--html-add-title-and-header-to-region t]
	  )
	 ("Structure"
	  ["Menu item" hm--html-add-list-or-menu-item-to-region t]
	  ["Menu" hm--html-add-menu-to-region t]
	  )
	 ("Formatting Paragraphs"
;	  ["Without links" hm--html-add-plaintext-to-region t]
	  ["Preformatted" hm--html-add-preformatted-to-region t]
	  )
	 ("Formatting Words"
	  ["Bold" hm--html-add-bold-to-region t]
	  ["Italic" hm--html-add-italic-to-region t]
	  ["Underline" hm--html-add-underline-to-region t]
          ["Typewriter" hm--html-add-fixed-to-region t]
	  )
	 ))


(if (adapt-xemacsp)
    ;; The reason for this if form is, that the Emacs 19 can't
    ;; work correct with `:keys "\\[idd-help-mouse-drag-and-drop]"'
    (setq hm--html-pulldown-menu
	  '("HTML Config Menu"
	    ("Set popup menu"
	     ["Novice menu" 
	      hm--html-use-novice-menu
	      :active t
	      :style radio
	      :selected (not hm--html-expert)]
	     ["Expert menu"
	      hm--html-use-expert-menu
	      :active t
	      :style radio
	      :selected hm--html-expert]
	     )
	    ["Reload config files" hm--html-load-config-files t]
	    ["Templates (fixed dirs) ..."
	     hm--html-insert-template-from-fixed-dirs
	     t]
	    ["Templates ..." hm--html-insert-template t]
	    ["Drag & Drop"
	     idd-start-mouse-drag-and-drop
	     :active t
	     :keys "\\[idd-mouse-drag-and-drop]"]
	    ["Drag & Drop Help"
	     idd-start-help-mouse-drag-and-drop
	     :active t
	     :keys "\\[idd-help-mouse-drag-and-drop]"]
	    "----"
	    ["Remove numeric names" hm--html-remove-numeric-names t]
	    ["Quotify hrefs" hm--html-quotify-hrefs t]
	    "----"
	    ["Submit bug report..." hm--html-submit-bug-report t]
	    ["WWW Package Docs" hm--html-view-www-package-docu t]
	    "----"
	    ("Preview Document"     
	     ["Netscape view buffer" (hm--html-send-buffer-to-netscape 
				      (current-buffer)) t]
	     "----"
	     ["Xmosaic start" html-view-start-mosaic t]
	     ["Xmosaic view buffer" html-view-view-buffer t]
	     ["Xmosaic view file" html-view-view-file t]
	     ["Xmosaic goto url" html-view-goto-url t]
	     ["Xmosaic get display" html-view-get-display t]
	     "----"
	     ["W3 start" w3 t]
	     ["W3 view buffer" w3-preview-this-buffer t]
	     ["W3 open remote file..." w3-fetch t]
	     ["W3 open local..." w3-open-local t]
	     ["W3 use hotlist..." w3-use-hotlist t]
	     )
	    ))
  (setq hm--html-pulldown-menu
	'("HTML Config Menu"
	  ("Set popup menu"
	   ["Novice menu" 
	    hm--html-use-novice-menu
	    :active t
	    :style radio
	    :selected (not hm--html-expert)]
	   ["Expert menu"
	    hm--html-use-expert-menu
	    :active t
	    :style radio
	    :selected hm--html-expert]
	   )
	  ["Reload config files" hm--html-load-config-files t]
	  ["Templates (fixed dirs) ..."
	   hm--html-insert-template-from-fixed-dirs
	   t]
	  ["Templates ..." hm--html-insert-template t]
	  ["Drag & Drop"
	   idd-start-mouse-drag-and-drop
	   :active t]
	  ["Drag & Drop Help"
	   idd-start-help-mouse-drag-and-drop
	   :active t]
	  "----"
	  ["Remove numeric names" hm--html-remove-numeric-names t]
	  ["Quotify hrefs" hm--html-quotify-hrefs t]
	  "----"
	  ["Submit bug report..." hm--html-submit-bug-report t]
	  ["WWW Package Docs" hm--html-view-www-package-docu t]
	  "----"
	  ("Preview Document"     
	   ["Netscape view buffer" (hm--html-send-buffer-to-netscape 
				    (current-buffer)) t]
	   "----"
	   ["Xmosaic start" html-view-start-mosaic t]
	   ["Xmosaic view buffer" html-view-view-buffer t]
	   ["Xmosaic view file" html-view-view-file t]
	   ["Xmosaic goto url" html-view-goto-url t]
	   ["Xmosaic get display" html-view-get-display t]
	   "----"
	   ["W3 start" w3 t]
	   ["W3 view buffer" w3-preview-this-buffer t]
	   ["W3 open remote file..." w3-fetch t]
	   ["W3 open local..." w3-open-local t]
	   ["W3 use hotlist..." w3-use-hotlist t]
	   )
	  ))
  )	

(if (adapt-xemacsp)
    (defun hm--install-html-menu (menu-name)
      (if (and (featurep 'menubar)
	       current-menubar 
	       (not (assoc menu-name current-menubar)))
	  (progn
	    (set-buffer-menubar (copy-sequence current-menubar))
	    (add-submenu nil
			 (cons menu-name (cdr hm--html-pulldown-menu))
			 "HTML"))))

  (defun hm--install-html-menu (menu-name)
    (if (eq major-mode 'hm--html-mode)
	(easy-menu-define hm--html-menu-map
			  hm--html-mode-map
			  "The hm--html-mode pulldown menu."
			  (cons menu-name
				(cdr hm--html-pulldown-menu)))
      (easy-menu-define hm--html-minor-menu-map
			hm--html-minor-mode-map
			"The hm--html-minor-mode pulldown menu."
			(cons menu-name
			      (cdr hm--html-pulldown-menu))))
    ))

(if (adapt-emacsp)
    (progn

      (setq hm--html-menu-noregion-expert-map
		  (make-lucid-menu-keymap (car hm--html-menu-noregion-expert)
					  (cdr hm--html-menu-noregion-expert)))

      (setq hm--html-menu-region-expert-map
	    (make-lucid-menu-keymap (car hm--html-menu-region-expert)
				    (cdr hm--html-menu-region-expert)))

      (setq hm--html-menu-noregion-novice-map
	    (make-lucid-menu-keymap (car hm--html-menu-noregion-novice)
				    (cdr hm--html-menu-noregion-novice)))

      (setq hm--html-menu-region-novice-map
	    (make-lucid-menu-keymap (car hm--html-menu-region-novice)
				    (cdr hm--html-menu-region-novice)))

      ;; Speeds up the first popup of a menu
      (if hm--html-expert
	  (progn
	    (x-popup-menu nil hm--html-menu-noregion-expert-map)
	    (x-popup-menu nil hm--html-menu-region-expert-map)
	    )
	(x-popup-menu nil hm--html-menu-noregion-novice-map)
	(x-popup-menu nil hm--html-menu-region-novice-map))


      )

  (defun hm--html-popup-menu (event)
    "Pops the HTML- menu up, if no region is active."
    (interactive "@e")
    (if hm--html-expert
	(popup-menu hm--html-menu-noregion-expert)
      (popup-menu hm--html-menu-noregion-novice)))


  (defun hm--html-popup-menu-region (event)
    "Pops the HTML- menu up, if a region is active."
    (interactive "@e")
    (if hm--html-expert
	(popup-menu hm--html-menu-region-expert)
      (popup-menu hm--html-menu-region-novice)))
  )


(if (adapt-xemacsp)
    (progn

      (defun hm--html-use-novice-menu ()
	"Changes the HTML popup menu to the novice menu."
	(interactive)
	(setq hm--html-expert nil)
	)	


      (defun hm--html-use-expert-menu ()
	"Changes the HTML popup menu to the expert menu."
	(interactive)
	(setq hm--html-expert t)
	)
      )

  ;; For the Emacs 19
  (defun hm--html-use-novice-menu ()
    "Changes the HTML popup menu to the novice menu."
    (interactive)
    (setq hm--html-expert nil)
    (define-key hm--html-region-mode-map
      hm--html-emacs19-popup-region-menu-button
      hm--html-menu-region-novice-map)
    (define-key hm--html-minor-region-mode-map
	  hm--html-emacs19-popup-region-menu-button
	  hm--html-menu-region-novice-map)
    (if (not hm--html-region-mode)
	(define-key hm--html-mode-map
	  hm--html-emacs19-popup-noregion-menu-button
	  hm--html-menu-noregion-novice-map))
    (if (not hm--html-minor-region-mode)
	(define-key hm--html-minor-mode-map 
	  hm--html-emacs19-popup-noregion-menu-button
	  hm--html-menu-noregion-novice-map))
    )

  (defun hm--html-use-expert-menu ()
    "Changes the HTML popup menu to the expert menu."
    (interactive)
    (setq hm--html-expert t)
    (define-key hm--html-region-mode-map
      hm--html-emacs19-popup-region-menu-button
      hm--html-menu-region-expert-map)
    (define-key hm--html-minor-region-mode-map
	  hm--html-emacs19-popup-region-menu-button 
	  hm--html-menu-region-expert-map)
    (if (not hm--html-region-mode)
	(define-key hm--html-mode-map
	  hm--html-emacs19-popup-noregion-menu-button
	  hm--html-menu-noregion-expert-map))
    (if (not hm--html-minor-region-mode)
	(define-key hm--html-minor-mode-map 
	  hm--html-emacs19-popup-noregion-menu-button
	  hm--html-menu-noregion-expert-map))
    )
  )


(defvar hm--html-use-psgml t
  "Set this to t, if functions from the psgml-mode should be used.")

;;; Popup the menus in the minor mode

(if (adapt-xemacsp)
    (progn

      (defadvice sgml-xemacs-get-popup-value (around
					      hm--html-popup-menu-advice
					      activate)
	"Calls `hm--html-sgml-xemacs-get-popup-value' instead of the original.
`hm--html-sgml-xemacs-get-popup-value' is only called, if the
`hm--html-minor-mode' is active. 
`hm--html-sgml-xemacs-get-popup-value' adds the 'hm--html-mode' popup
menus to the psgml popup menu."
	(if hm--html-minor-mode
	    (setq ad-return-value
		  (hm--html-sgml-xemacs-get-popup-value (ad-get-arg 0)))
	  ad-do-it))
      
      (defun hm--html-sgml-xemacs-get-popup-value (menudesc)
	(let ((value nil)
	      (event nil))
	  ;; (popup-menu menudesc)
	  (if (boundp 'hm--html-popup-menu)
	      (popup-menu (append hm--html-popup-menu  ; for the hm--html-menu 
				  (list "=="           ;
					(car menudesc) ;
					"==")          ;
				  (cdr menudesc)))     ;
	    (popup-menu menudesc))
	  (while (popup-up-p)
	    (setq event (next-command-event event))
	    (cond ((misc-user-event-p event)
		   (cond
		    ((eq (event-object event) 'abort)
		     (signal 'quit nil))
		    ((eq (event-object event) 'menu-no-selection-hook)
		     nil)
		    ((and (commandp (event-object event))       ; for the 
			  (boundp 'hm--html-mark))		;
		     (set-mark hm--html-mark)			;
		     (goto-char hm--html-point)			;
		     (call-interactively (event-object event))  ; hm--html-menu
;		     (signal 'quit nil)                         ; items
		     )
		    (t
		     (eval (event-object event)))))
		  ((button-release-event-p event) ; don't beep twice
		   nil)
		  ((and (fboundp 'event-matches-key-specifier-p)
			(event-matches-key-specifier-p event (quit-char)))
		   (signal 'quit nil))
		  (t
		   (beep)
		   (message "please make a choice from the menu."))))
	  value))
      )

  ;; For the Emacs 19
  (defun hm--html-add-major-menu-to-minor-menus ()
    "Adds an entry to get the general major menu in the minor mode menus.
This function is only used in the Emacs 19."
    (define-key  hm--html-menu-noregion-novice-map
      [mouse-major-mode-menu]
      '("Major Mode Menu" . mouse-major-mode-menu))
    (define-key  hm--html-menu-noregion-expert-map
      [mouse-major-mode-menu]
      '("Major Mode Menu" . mouse-major-mode-menu))
    (define-key  hm--html-menu-region-novice-map
      [mouse-major-mode-menu]
      '("Major Mode Menu" . mouse-major-mode-menu))
    (define-key  hm--html-menu-region-expert-map
      [mouse-major-mode-menu]
      '("Major Mode Menu" . mouse-major-mode-menu)))

  (defun hm--html-remove-major-menu-from-minor-menus ()
    "Removes the entry to get the general major menu in the minor mode menus.
This function is only used in the Emacs 19."
    (define-key  hm--html-menu-noregion-novice-map
      [mouse-major-mode-menu] 'undefined)
    (define-key  hm--html-menu-noregion-expert-map
      [mouse-major-mode-menu] 'undefined)
    (define-key  hm--html-menu-region-novice-map
      [mouse-major-mode-menu] 'undefined)
    (define-key  hm--html-menu-region-expert-map
      [mouse-major-mode-menu] 'undefined))
  )

(if (adapt-xemacsp)
    (progn

      (defun hm--html-popup-minor-html-menu (event)
	"Pops the HTML- menu up, if no region is active."
	(interactive "@e")
	(if (eq major-mode 'html-mode)
	    (if hm--html-use-psgml
		(let ((hm--html-popup-menu (if hm--html-expert
					       hm--html-menu-noregion-expert
					     hm--html-menu-noregion-novice))
		      (hm--html-point (point))
		      (hm--html-mark (mark)))
		  (sgml-tags-menu event))
	      (if hm--html-expert
		  (popup-menu hm--html-menu-noregion-expert)
		(popup-menu hm--html-menu-noregion-novice))
	      )
	  ;; popup-menu will fail, if mode-popup-menu contains a
	  ;; :filter and mode-popup-menu isn't at the top of
	  ;; the menu
	  (popup-menu (append mode-popup-menu
			      (list "==="
				    (if hm--html-expert
					(car hm--html-menu-region-expert)
				      (car hm--html-menu-region-novice))
				    "===")
			      (if hm--html-expert
				  (cdr hm--html-menu-region-expert)
				(cdr hm--html-menu-region-novice)
				)))))
	    
      
      
      (defun hm--html-popup-minor-html-menu-region (event)
	"Pops the HTML- menu up, if a region is active."
	(interactive "@e")
	(if (eq major-mode 'html-mode)
	    (if hm--html-use-psgml
		(let ((hm--html-popup-menu (if hm--html-expert
					       hm--html-menu-region-expert
					     hm--html-menu-region-novice))
		      (hm--html-point (point))
		      (hm--html-mark (mark)))
		  (sgml-tags-menu event))
	      (if hm--html-expert
		  (popup-menu hm--html-menu-region-expert)
		(popup-menu hm--html-menu-region-novice))
	      )
	  ;; popup-menu will fail, if mode-popup-menu contains a
	  ;; :filter and mode-popup-menu isn't at the top of
	  ;; the menu
	  (popup-menu (append mode-popup-menu
			      (list "==="
				    (if hm--html-expert
					(car hm--html-menu-region-expert)
				      (car hm--html-menu-region-novice))
				    "===")
			      (if hm--html-expert
				  (cdr hm--html-menu-region-expert)
				(cdr hm--html-menu-region-novice)
			      )))))
      
      ))


(run-hooks 'hm--html-menu-load-hook)


;;; Announce the feature hm--html-menu
(provide 'hm--html-menu)
