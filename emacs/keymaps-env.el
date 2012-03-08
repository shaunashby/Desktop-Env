;;
;; keymaps-env.el
;;
;; Define some shortcut keys
;;

;; Need to define way of undoing "comment-region" so can create a keybinding:
(fset 'uncomment-region
   [?\C-u ?- ?1 escape ?x ?c ?o ?m ?m ?e ?n ?t ?- ?r ?e ?g ?i ?o ?n])
;;
(global-set-key "\C-cg" 'goto-line)
(global-set-key "\C-r" nil)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-s" nil)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key [print] 'switch-to-buffer)
(global-set-key [C-down-mouse-1] 'mouse-buffer-menu)
(global-set-key [f1] 'kill-buffer)
(global-set-key [f2] 'delete-frame)
(global-set-key [f3] 'make-frame)
(global-set-key [f4] 'query-replace)
(global-set-key [f5] 'downcase-region)
(global-set-key [f6] 'upcase-region)
(global-set-key [f7] 'font-lock-fontify-buffer)
(global-set-key [f8] 'font-lock-mode)
(global-set-key [f9] 'comment-region)
(global-set-key [f10] 'uncomment-region)
(global-set-key [f11] 'scroll-up)
(global-set-key [f12] 'scroll-down)
;; For emacs21, must set "home" and "end":
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
;;
;; keymaps-env.el
;;