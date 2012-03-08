;; 
;; cust-faces.el
;;
;; Extra faces for editing modes
;; FORTRAN:
(make-face 'Cradle-face)
(set-face-foreground 'Cradle-face "PaleGreen")  
;; face for patchy patches:
(make-face 'Patch-face)
(set-face-foreground 'Patch-face "Black")
(set-face-background 'Patch-face "PaleGreen")     
;; PAW: messages/itx:
(make-face 'message-face)
(set-face-foreground 'message-face "DeepPink")
;; PAW: plot options:
(make-face 'option-face)
(set-face-foreground 'option-face "Aquamarine3")
;; end-of-line "\":
(make-face 'backslash-eol-face)
(set-face-foreground 'backslash-eol-face "Red")   
;; Directories:
(make-face 'Directory-face)
(set-face-foreground 'Directory-face "Black")
(set-face-background 'Directory-face "White")
;; OK face (text mode, in logbook):
(make-face 'OK-face)
(set-face-foreground 'OK-face "black")
(set-face-background 'OK-face "tomato1")
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