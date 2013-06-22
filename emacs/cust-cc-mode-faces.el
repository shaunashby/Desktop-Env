;;; cust-cc-mode-faces.el --- 
;;
;; Copyright (C) 2013  Shaun Ashby
;;
;; Author: Shaun Ashby <shaun@ashby.ch>
;; Keywords: 
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; 
;;
;;; Code:
;; Customize some colored faces:
(message "Creating custom C++ faces...")
(let ((default-font (if window-system (x-get-resource ".font" ".Font") nil)))
  (make-face            'ashby-face-reference)
  (set-face-font        'ashby-face-reference default-font)
  (make-face-bold       'ashby-face-reference nil t)
  (set-face-foreground  'ashby-face-reference "limegreen")

  (make-face            'ashby-face-number)
  (set-face-font        'ashby-face-number default-font)
  (set-face-foreground  'ashby-face-number "violet")

  (make-face            'ashby-face-warning)
  (set-face-font        'ashby-face-warning default-font)
  (make-face-bold       'ashby-face-warning nil t)
  (set-face-foreground  'ashby-face-warning "red")
  (set-face-background  'ashby-face-warning "gray95"))
(message "Creating custom C++ faces... done")

;; Set preferences for different faces to be used.
(setq font-lock-reference-face	'cms-face-reference
      font-lock-number-face	'cms-face-number
      font-lock-warning-face	'cms-face-warning)

(provide 'cust-cc-mode-faces)
;;; cust-cc-mode-faces.el ends here
