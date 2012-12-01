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

(defun org-insert-export-options-template ()
  (interactive)
  (let ((cal-date (org-get-date-from-calendar)))
    (insert (format
	     (concat
	      "#+TITLE:\n"
	      "#+DATE: <%d-%02d-%02d>\n")
	     (nth 2 cal-date)
	     (car cal-date)
	     (nth 1 cal-date)))))

