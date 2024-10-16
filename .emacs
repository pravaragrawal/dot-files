;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)


(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)


;; MELPA package repository
(add-to-list 'package-archives
             '("melpa-edge" . "https://melpa.org/packages/") t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("75bc4eb26434bbb4544db3e81a12acfc84d822ed0fd0706a42fa646089891043" default))
 '(elpy-rpc-python-command "/Users/pragrawal/.emacs.d/elpy/rpc-venv/bin/python")
 '(elpy-syntax-check-command "~/.local/bin/flake8")
 '(package-selected-packages
   '(jedi yaml markdown-mode flymake-python-pyflakes easy-hugo dockerfile-mode pdf-view-restore pdf-tools helm magit elpa-mirror elpygen dumb-jump go-mode))
 '(python-shell-interpreter "/opt/homebrew/bin/python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; entry to maintain font throught the buffers
(set-face-attribute 'default nil :height 180)


;; entries for operation-blue-moon
(define-skeleton insert-org-entry
  "Prompt for task, estimate and category"
  nil
  '(setq task  (skeleton-read "Task: "))
  '(setq estimate  (skeleton-read "Estimate: "))
  '(setq category (skeleton-read "Category: "))
  '(setq timestamp (format-time-string "%s"))
  "** " task \n
  ":PROPERTIES:" \n
  ":ESTIMATED: " estimate \n
  ":ACTUAL:" \n
  ":OWNER: pravarag" \n
  ":ID: " category "." timestamp \n
  ":TASKID: " category "." timestamp \n
  ":END:")

;; Function and binding to update the ACTUAL in org file
;; workaround for missing org-clock-sum-current-item on Fedora 28/29
(require 'org-clock)
(defun org-update-actuals ()
    (interactive)
    (org-entry-put (point) "ACTUAL"
      (format "%0.2f" (/ (org-clock-sum-current-item) 60.0))))

(global-set-key (kbd "C-c s c") 'org-update-actuals)



;; Bindings for org-agenda
(setq org-agenda-files '("~/work/"))

(defun org-agenda-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "")
          (alltodo ""
                   ((org-agenda-skip-function
                     '(or (org-agenda-skip-subtree-if-priority ?A)
                          (org-agenda-skip-if nil '(scheduled deadline))))))))))


;; clocked timing settings for operation-blue-moon
(defun org-update-actuals ()
  (interactive)
  (org-entry-put (point) "ACTUAL"
                 (format "%0.2f" (/ (org-clock-sum-current-item) 60.0))))

(global-set-key (kbd "C-c s c") 'org-update-actuals)


;; Add closed timestamp when task is marked DONE
(setq org-log-done 'time)


(setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "IN_PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")))


;; Path to add custom .el files
(add-to-list 'load-path "~/.emacs.d/lib/")

;; Binding for Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Binding for org-present mode
(add-to-list 'load-path "~/.emac.d/lib/")
(autoload 'org-present "org-present" nil t)
(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))


;; Load modes from lib
(require 'yaml-mode)

(setq mac-command-modifier 'meta)

(setq ns-right-option-modifier 'control)

(setq ns-right-command-modifier 'meta)


;; Jedi configuration
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(define-key python-mode-map (kbd "M-.")
  (function jedi:goto-definition))
