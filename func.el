(defun new-post ()
  (interactive)
  (let ((content (shell-command-to-string
		  (concat "cd /home/song/Projects/blog &&"
			  "rake new_post["
			  (read-string "Post Topic: ")
			  "]"))))
    (find-file (concat  "/home/song/Projects/blog/"
			(substring content
				   (string-match "source/_posts/" 
						 content)
				   (string-match ".markdown"
						 content))
			".markdown"))))

(defun update-config ()
  (interactive)
  (load-file "~/.emacs"))

(global-set-key "\C-cu" 'update-config)

(defun my-org-insert-template ()
  (interactive)
  (org-goto-calendar)
  (let ((cal-date (org-get-date-from-calendar)))
    (kill-buffer-and-window)
    (switch-to-buffer (car (org-buffer-list 'files)))
    (insert (format
	     (concat
	      "#+TITLE:\n"
	      "#+DATE: <%d-%02d-%02d>\n")
	     (nth 2 cal-date)
	     (car cal-date)
	     (nth 1 cal-date)))))

(add-hook 'org-mode-hook
	  (lambda () 
	    (defun org-insert-export-options-template()
	      (interactive)
		  (my-org-insert-template))))

(add-hook 'org-mode-hook
	  (lambda ()
	    (setq truncate-lines nil)))

     
(defun try nil
  (interactive)
(let ((re (concat "^\\(\\*+\\)[ \t]\\|^[ \t]*"
		  org-clock-string
		  "[ \t]*\\(?:\\(\\[.*?\\]\\)-+\\(\\[.*?\\]\\)\\|=>[ \t]+\\([0-9]+\\):\\([0-9]+\\)\\)"))
      (final-string "")
      unsorted-list)
  (save-excursion
   (while (setq spos (re-search-backward re nil t))
     (if (match-string 2)
	 (and (setq ts (match-string 2))
	      (setq te (match-string 3))
	      (setq heading (nth 4 (org-heading-components)))
	      (setq unsorted-list (cons (list ts te heading) unsorted-list))))))
  (setq sorted-list (sort unsorted-list (lambda (a b) (string< (car a) (car b)))))
  (dolist (entry sorted-list)
    (message (concat "** " (nth 2 entry) "\n" (nth 0 entry) "--" (nth 1 entry) "\n")))))

(defun opcode-recursive(text opcode from to)
  (insert "|" text (number-to-string  from) "|" (number-to-string opcode) "|\n")
  (if (equal from to)
      nil
    (opcode-recursive text (+ opcode 1) (+ from 1) to)
  ))

(defun opcode-table()
  (interactive)
  (opcode-recursive (read-string "Base Operation: ") (read-number "Base Opcode: ")
		    (read-number "From: ") (read-number "To: ")))

;; used by org-clock-sum-today-by-tags
(defun filter-by-tags ()
   (let ((head-tags (org-get-tags-at)))
     (member current-tag head-tags)))

(defun org-clock-sum-today-by-tags (timerange &optional tstart tend noinsert)
  (interactive "P")
  (let* ((timerange-numeric-value (prefix-numeric-value timerange))
         (files (org-add-archive-files (org-agenda-files)))
         (include-tags '("academic" "potential" "exercise" "work"
                         "routinue" "entertainment" "fun"))
         (tags-time-alist (mapcar (lambda (tag) `(,tag . 0)) include-tags))
         (output-string "")
         (tstart (or tstart
                     (and timerange (equal timerange-numeric-value 4) (- (org-time-today) 86400))
                     (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "Start Date/Time:"))
                     (org-time-today)))
         (tend (or tend
                   (and timerange (equal timerange-numeric-value 16) (org-read-date nil nil nil "End Date/Time:"))
                   (+ tstart 86400)))
         h m file item prompt donesomething)
    (while (setq file (pop files))
      (setq org-agenda-buffer (if (file-exists-p file)
                                  (org-get-agenda-file-buffer file)
                                (error "No such file %s" file)))
      (with-current-buffer org-agenda-buffer
        (dolist (current-tag include-tags)
          (org-clock-sum tstart tend 'filter-by-tags)
          (setcdr (assoc current-tag tags-time-alist)
                  (+ org-clock-file-total-minutes (cdr (assoc current-tag tags-time-alist)))))))
    (while (setq item (pop tags-time-alist))
      (unless (equal (cdr item) 0)
        (setq donesomething t)
        (setq h (/ (cdr item) 60)
              m (- (cdr item) (* 60 h)))
        (setq output-string (concat output-string (format "[-%s-] %.2d:%.2d\n" (car item) h m)))))
    (unless donesomething
      (setq output-string (concat output-string "[-Nothing-]\n")))
    (unless noinsert
        (insert output-string))
    output-string))

(defun org-clock-tag-statistics ()
  (interactive)
  (let* ((datetime-today (decode-time))
	 (day-today (nth 3 datetime-today))
	 (month-today (nth 4 datetime-today))
	 (year-today (nth 5 datetime-today))
	 (week-start (- (org-time-today)
			(* (org-day-of-week day-today month-today year-today)
			   86400)))
	 (week-end (+ week-start (* 7 86400))))
    (switch-to-buffer (generate-new-buffer "*statics*"))
    (insert "Week:\n")
    (goto-char (point-max))
    (org-clock-sum-today-by-tags nil week-start week-end)
    (goto-char (point-max))
    (insert "\nToday:\n")
    (org-clock-sum-today-by-tags nil)
    (setq buffer-read-only t)))


(global-set-key "\C-cz" 'org-clock-tag-statistics)
