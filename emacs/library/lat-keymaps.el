;;; lat-keymaps.el --- Lassi's special key rebindings.

;;; Global key rebindings
(defun save-buffer-kill-buffer (arg)
  "Save the current buffer (with ARG, w/o asking), then kill it."
  (interactive "P")
  (if (and buffer-file-name (buffer-modified-p) (or arg (y-or-n-p "Save? ")))
      (save-buffer))
  (setq last-buffer (current-buffer))
  (kill-buffer (current-buffer))
  (if (buffer-name last-buffer)
      ()
    (delete-frame (selected-frame))))

;; (define-key c-mode-map "\" 'c-return-autoindent)
(define-key global-map "\C-m" 'newline-and-indent)

(defvar ctl-t-map (make-keymap)
  "*Keymap for subcommands of C-t*")

(fset 'ctl-t-prefix ctl-t-map)

(define-key global-map "\C-t"   'ctl-t-prefix) ; pointer to keymap

;; transpose-chars C-T -> C-T C-T (easy to remember)
(define-key ctl-t-map "\C-t"    'transpose-chars)

;; and other definitions so far
(define-key ctl-t-map "\C-r"    'rename-buffer)
(define-key ctl-t-map "c"       'compile)
(define-key ctl-t-map "d"       'gdb)
(define-key ctl-t-map "g"       'goto-line)
(define-key ctl-t-map "h"       'hilit-rehighlight-buffer)
(define-key ctl-t-map "E"       'eval-current-buffer)
;;(define-key ctl-t-map "f"	'find-file)
(define-key ctl-t-map "k"       'kill-compilation)
(define-key ctl-t-map "l"       'less-file)
(define-key ctl-t-map "L"       'less-mode)
(define-key ctl-t-map "i"	'indent-region)
(define-key ctl-t-map "m"       'manual-entry)
(define-key ctl-t-map "n"       'next-error)
(define-key ctl-t-map "o"       'overwrite-mode)
(define-key ctl-t-map "p"       'ps-print-buffer-with-faces)
(define-key ctl-t-map "r"       'replace-regexp)
(define-key ctl-t-map "s"       'todo-show)
(define-key ctl-t-map "t"	'todo-insert-item)
(define-key ctl-t-map "v"       'view-file)
(define-key ctl-t-map "x"       'xsl-complete)
(define-key ctl-t-map "\\"	'c++-macroize-region)
