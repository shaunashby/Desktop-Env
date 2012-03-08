;; cms-cc-faces.el --- Customised faces for `font-lock-mode'.

;; For these to work properly, we recommend you to set the following
;; resources in your `.Xdefaults':
;;   Emacs*popup.background:             lemonchiffon
;;   Emacs*popup.font:                   -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;   Emacs*menubar.background:           lemonchiffon
;;   Emacs*menubar.font:                 -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;   Emacs*default.attributeFont:        -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;   Emacs*EmacsScreen.foreground:       black
;;   Emacs*EmacsScreen*cursorColor:      red
;;   Emacs*EmacsScreen.borderWidth:      2
;;   Emacs*EmacsScreen.background:       white
;;   Emacs*EmacsScreen*pointerColor:     red
;;   Emacs*modeline.attributeBackground: black
;;   Emacs*modeline.attributeForeground: white
;;   Emacs*foreground:                   black
;;   Emacs*font:                         -adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1
;;   Emacs*bitmapIcon:                   on
;;   Emacs.geometry:                     80x50
;;   Emacs*background:                   white

;; Reload a working faces and fonts (and hilit19, but this is later on).
(require 'faces)
(require 'font-lock)

;; Make my special faces
(message "Creating faces...")
(let ((default-font (if window-system (x-get-resource ".font" ".Font") nil)))
  (make-face 'cms-face-normal) 
  (set-face-font 'cms-face-normal default-font)
  
  (make-face 'cms-face-bold)
  (set-face-font 'cms-face-bold default-font)
  (make-face-bold 'cms-face-bold nil t)
  
  (make-face 'cms-face-italic)
  (set-face-font 'cms-face-italic default-font)
  (make-face-italic 'cms-face-italic nil t)
  
  (make-face 'cms-face-bold-italic)
  (set-face-font 'cms-face-bold-italic default-font)
  (make-face-bold-italic 'cms-face-bold-italic nil t)
  
  (make-face 'cms-face-string)
  (set-face-font 'cms-face-string default-font)
  (set-face-background 'cms-face-string "yellow")
  
  (make-face 'cms-face-comment)
  (set-face-font 'cms-face-comment default-font)
  (set-face-underline-p 'cms-face-comment nil)
  ;; (set-face-background 'cms-face-comment "gray95")
  (set-face-foreground 'cms-face-comment "darkgreen")
  (make-face-bold 'cms-face-comment nil t)

  (make-face 'cms-face-reference)
  (set-face-font 'cms-face-reference default-font)
  (make-face-bold 'cms-face-reference nil t)
  (set-face-foreground 'cms-face-reference "limegreen")
  
  (make-face 'cms-face-type)
  (set-face-font 'cms-face-type default-font)
  (set-face-foreground 'cms-face-type "deepskyblue4")
  
  (make-face 'cms-face-keyword)
  (set-face-font 'cms-face-keyword default-font)
  (set-face-foreground 'cms-face-keyword "mediumblue")
  
  (make-face 'cms-face-function-name)
  (set-face-font 'cms-face-function-name default-font)
  (set-face-foreground 'cms-face-function-name "red")
  
  (make-face 'cms-face-number)
  (set-face-font 'cms-face-number default-font)
  (set-face-foreground 'cms-face-number "violet")

  (make-face 'cms-face-warning)
  (set-face-font 'cms-face-warning default-font)
  (make-face-bold 'cms-face-warning nil t)
  (set-face-foreground 'cms-face-warning "red")
  (set-face-background 'cms-face-warning "gray95"))
(message "Creating faces... done")

;; Set preferences for different faces to be used.
(setq font-lock-comment-face	'cms-face-comment
      font-lock-reference-face	'cms-face-reference
      font-lock-doc-string-face	'cms-face-string
      font-lock-string-face	'cms-face-string
      font-lock-function-name-face 'cms-face-function-name
      font-lock-keyword-face	'cms-face-keyword
      font-lock-type-face	'cms-face-type
      font-lock-number-face	'cms-face-number
      font-lock-warning-face	'cms-face-warning)