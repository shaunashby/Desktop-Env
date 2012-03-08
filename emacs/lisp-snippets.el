;; Ruby mode:
(autoload 'ruby-mode "ruby-mode" "Load ruby-mode")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))

;; Turn on syntax highlighting
(add-hook 'ruby-mode-hook 'turn-on-font-lock)

;; To make scripts executable automatically:
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
