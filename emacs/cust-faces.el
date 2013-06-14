;; 
;; cust-faces.el
;;

;; end-of-line "\":
(make-face 'backslash-eol-face)
(set-face-foreground 'backslash-eol-face "Red")   
;; Directories:
(make-face 'Directory-face)
(set-face-foreground 'Directory-face "Black")
(set-face-background 'Directory-face "White")
;; Template face:
(make-face 'Template-face)
(set-face-foreground 'Template-face "black")
(set-face-background 'Template-face "bisque3")
;; Makefile def highlight face:
(make-face 'Definition-face)
(set-face-foreground 'Definition-face "yellow")
(set-face-background 'Definition-face "SlateBlue1")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ==========  Colours for faces     ========= ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message "Customizing built-in faces...")
;;
(set-face-background 'highlight "Yellow")
(set-face-foreground 'highlight "Black")
(set-face-foreground 'italic "Sienna2")
(set-face-foreground 'bold "MediumSeaGreen")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set faces for flashing-bracket mode: ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-face-foreground 'flash-paren-face-on "Green")
(set-face-background 'flash-paren-face-on "OrangeRed3")
(set-face-foreground 'flash-paren-face-off "white")
(set-face-background 'flash-paren-face-off "black")
;;
(message "Customizing built-in faces... done")
;;
;; End of cust-faces.el
;;
