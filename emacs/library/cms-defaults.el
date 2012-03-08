;; $Id: cms-defaults.el,v 1.1 2005/08/19 10:23:49 sashby Exp $

;; Modify some defaults - which you may or may not like

(setq require-final-newline    'ask
      compile-command		"gmake -k"
      c-tab-always-indent	nil
      c-recognize-knr-p		nil
      c-backslash-column       	78
      c-progress-interval      	1
      c-auto-newline	       	t
      gc-cons-threshold	        8388607
      column-number-mode        t
      default-major-mode        'text-mode)

(global-font-lock-mode t)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(show-paren-mode)

;; Allow some normally disabled functions
(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; On NT leave bat files in DOS mode
(if (eq system-type 'windows-nt)
  (setq file-name-buffer-file-type-alist '(("\\.bat$" . nil) (".*" . t))))
