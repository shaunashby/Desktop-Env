;;
;; cust-calendar.el
;;
(setq
 european-calendar-style	t
 calendar-week-start-day	1
 calendar-latitude		46.2
 calendar-longitude		6.0
 calendar-location-name		"Genève"
 view-diary-entries-initially	t
 view-calendar-holidays-initially nil
 mark-diary-entries-in-calendar	t
 mark-holidays-in-calendar	t
 number-of-diary-entries	[1 2 2 2 2 5 1]
 diary-file			"~/private/diary/diary"
 todo-file-do			"~/private/diary/TODO-do"
 todo-file-done			"~/private/diary/TODO-done")

(add-hook 'diary-hook 'appt-make-list)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'list-diary-entries-hook 'sort-diary-entries t)
(add-hook 'list-diary-entries-hook 'include-other-diary-files)
(add-hook 'mark-diary-entries-hook 'mark-included-diary-files)

(autoload 'todo-mode "todo-mode" "Major mode for editing TODO lists." t)
;;
;; End of cust-calendar.el
;;