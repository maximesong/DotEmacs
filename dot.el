(setq debug-on-error t)

(custom-set-variables
 ;; disable tool bar
 '(tool-bar-mode nil)
 ;; disable scroll bar
 '(scroll-bar-mode nil))

;; disable the startup page
(setq inhibit-startup-message t)

;; set the *strach* buffer text
(setq initial-scratch-message 
      (concat ";; Emacs\t;; Evenings\t;; Escape\n"
	      ";; Makes\t;; Mornings,\t;; Meta\n"
	      ";; A\t\t;; And a\t;; Alt\n"
	      ";; Computer\t;; Couple of\t;; Control\n"
	      ";; Slow\t\t;; Saturdays\t;; Shift\n\n"))

;; display time in the mode line
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;; make the point keep at the same screen position when scroll
(setq scroll-preserve-screen-position t)

;; let the title show the buffer name
(setq frame-title-format "Emacs@%b")

;; bind c-w to kill-backward word
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

;; set the c style
(setq c-default-style "linux"
      c-basic-offset 8)

;; make *.h as c++ header
(setq auto-mode-alist
      (cons '("\\.h$" . c++-mode)
	    auto-mode-alist))

;; set the org-mode
(add-to-list 'load-path "~/.emacs.d/plugins/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/plugins/org-mode/contrib/lisp")
;; otherwise, it is not auto-loaded when start emacs
(load-file "~/.emacs.d/plugins/org-mode/lisp/org-clock.el")

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Projects/todo/capture.org" "Tasks")
	 "* TODO %?\n %i\n %a")))

(setq org-tag-alist '(("academic" . ?a) ("potential" . ?p) ("misc" . ?m)
		      ("routinue" . ?r) ("entertainment" . ?e) ("sports" . ?s)
		      ("work" . ?w)
		      ("fun" . ?f)))

(setq org-clock-persist t)
(setq org-clock-into-drawer 2)
(setq org-agenda-files (list "~/Projects/todo/capture.org"
			     "~/Projects/todo/todo.org"
			     "~/Projects/todo/archive.org"))

(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(;(latex . t)
   (dot . t)
   (ditaa . t)))

;; set my org html configuration
(setq org-publish-project-alist
      '(("org"
;; FIXME: property needs to be a string literal
;;	 :base-directory my_org_source_directory
	 :base-directory "~/Projects/cppdo/org/"
	 :publishing-directory my-org-publish-directory
	 :publishing-function org-html-publish-to-html
	 :auto-sitemap t
	 :makeindex t
	 :link-home "http://www.cppdo.com/wiki/sitemap.html"
	 :link-up "http://www.cppdo.com"
	 :sitemap-title "站点地图"
	 :language "zh-CN")))

(setq org-default-language "zh-CN")

(setq org-html-head
      "<link rel= \"stylesheet\" type=\"text/css\" href=\"worg.css\" /><link rel=\"SHORTCUT ICON\" href=\"images/favicon.ico\" type=\"image/x-icon\" />")
(setq org-html-style-include-default nil)
(setq org-html-postamble t)
(setq org-html-postamble-format 
      '(("en" "<div id=\"postamble-info\"><p class=\"author\">作者: %a (%e)</p>\n<p class=\"date\">更新日期: %d</p>\n</div><div hidden=\"True\" style=\"display:none\"><script language=\"javascript\" type=\"text/javascript\" src=\"http://js.users.51.la/15248666.js\"></script></div><div id=\"disqus-frame\"><div id=\"disqus_thread\"></div>
    <script type=\"text/javascript\">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'cppdo'; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href=\"http://disqus.com/?ref_noscript\">comments powered by Disqus.</a></noscript>
    <a href=\"http://disqus.com\" class=\"dsq-brlink\">comments powered by <span class=\"logo-disqus\">Disqus</span></a></div>
    ")))

;; load the elisp to load directory automatically
(load "~/.emacs.d/plugins/subdirs.el")

;; set auto-complete mode
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;; set yasnippet mode
(require 'yasnippet)
(yas/global-mode 1)

;; set graphviz-dot mode
(load-file "~/.emacs.d/plugins/misc/graphviz-dot-mode.el")

;; set clojure mode
(require 'clojure-mode)

;; set jade mode
(require 'sws-mode)
(require 'jade-mode)    
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

;; set markdown mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; set coffee mode
(require 'coffee-mode)

;; set less mode
(require 'less-mode)
(add-to-list 'auto-mode-alist '("\\.less$" . less-mode))

;; csharp-mode
(autoload 'csharp-mode "csharp-mode.el" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))


;; llvm style for llvm related source file
(c-add-style "llvm.org"
             '((fill-column . 80)
	       (c++-indent-level . 2)
	       (c-basic-offset . 2)
	       (indent-tabs-mode . nil)
               (c-offsets-alist . ((innamespace 0)))))

;; Only files with "llvm" in
;; their names will automatically set to the llvm.org coding style.
(add-hook 'c-mode-hook
	  (function
	   (lambda nil 
	     (if (and buffer-file-name
		      (string-match "llvm" buffer-file-name))
		 (progn
		   (c-set-style "llvm.org")
		   )
	       ))))

(add-hook 'c++-mode-hook
	  (function
	   (lambda nil 
	     (if (and buffer-file-name
		      (string-match "llvm" buffer-file-name))
		 (progn
		   (c-set-style "llvm.org")
		   )
	       ))))
;; require llvm mode for llvm assembly highlighting
(require 'llvm-mode)

;; cmake-mode
(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
		("\\.cmake\\'" . cmake-mode))
	      auto-mode-alist))
