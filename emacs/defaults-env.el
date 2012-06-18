;;
;; defaults-env.el:
;;
(setq major-mode                    'text-mode
      compile-command		    "gmake all"
      ccdefault                     "gcc"
      cxxdefault                    "g++"
      javadefault                   "gcj"
      ;; Choose to set emacs server mode or not (t or nil):
      eserver-mode                  nil
      gc-cons-threshold	            8388607
      dired-listing-switches        "-lat"
;;      lpr-command                   "xprint"
;;      lpr-switches                  '("-P40_5b_08")
      mark-even-if-inactive         t
      font-lock-support-mode        'jit-lock-mode
      font-lock-maximum-decoration  t
      completion-ignore-case        t
      mouse-scroll-delay            0.0
      )

;; Misc stuff:
(global-unset-key "\C-x\C-c")            ;; Disable the shortcut that exits Emacs
(global-font-lock-mode t)                ;; Turn on font-lock automatically
;;
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;; Turn on flash-paren mode:
(flash-paren-mode t)
(blink-cursor-mode 0)
(tool-bar-mode 0)
;; Use scrolling with wheel mice:
(mouse-wheel-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other stuff                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(transient-mark-mode t)
;; Enable DEL key for deleting marked areas:
(delete-selection-mode t)

;; Add hook to make scripts executable automatically:
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
;;
;; End of defaults-env.el
;;
