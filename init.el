;; -*- lexical-binding: t; -*-

;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 150)
(defvar efs/default-variable-font-size 150)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(100 . 100))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; (load-file "~/.dotfiles/.emacs.d/lisp/dw-settings.el")

;; Load settings for the first time
;;(dw/load-system-settings)

(require 'subr-x)
(setq dw/is-termux nil)
;; (setq dw/is-termux
;;       (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))

(setq dw/is-guix-system nil)

;; (setq dw/is-guix-system (and (eq system-type 'gnu/linux)
;;                              (require 'f)
;;                              (string-equal (f-read "/etc/issue")
;;                                            "\nThis is the GNU system.  Welcome.\n")))

(require 'package)

;; Initialize package sources
(setq package-archives '(
                         ("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ;; ("org" . "https://orgmode.org/elpa/")
                         ;; ("elpa" . "https://elpa.gnu.org/packages/")
                         ))

;; (setq package-archives '(("myelpa" . "~/myelpa-mirror/")))
;; geiser
;; (add-to-list 'package-archives
;;   ;; choose either the stable or the latest git version:
;;   ;; '("melpa-stable" . "http://stable.melpa.org/packages/")
;;   '("melpa-unstable" . "http://melpa.org/packages/"))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ;; Bootstrap straight.el
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 5))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
;;         'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

;; ;; Always use straight to install on systems other than Linux
;; ;; (setq straight-use-package-by-default (not (eq system-type 'gnu/linux)))
;; (setq straight-use-package-by-default t)

;; ;; Use straight.el for use-package expressions
;; (straight-use-package 'use-package)

;; ;; Clean up unused repos with `straight-remove-unused-repos'

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering
  :defer t)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "Source Code Pro" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Source Code Pro" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Source Code Pro" :height efs/default-variable-font-size :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :after evil
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (efs/leader-keys
    "SPC" 'counsel-M-x
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "f" '(:ignore t :which-key "files")
    "ff" 'counsel-find-file
    "fr" 'counsel-recentf
    "b" '(:ignore t :which-key "buffers")
    "bs" 'ivy-switch-buffer
    "bd" 'evil-delete-buffer
    "bb" '(lambda () (interactive) (switch-to-buffer nil)) ; to previous buffer
    "w" '(:ignore t :which-key "windows")
    "wd" 'delete-window
    "wo" 'delete-other-windows
    "w1" 'split-window-vertically
    "w2" 'split-window-horizontally
    "o" '(:ignore t :which-key "org")
    "og" 'org-agenda
    "c" '(:ignore t :which-key "comment")
    "cl" 'evilnc-comment-or-uncomment-lines
    "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/Emacs.org")))
    "fdz" '(lambda () (interactive) (find-file (expand-file-name "~/.zshrc")))))

(general-create-definer my-local-leader-def
  :prefix "SPC m")

(my-local-leader-def 'normal go-mode-map
  "ta" 'go-tag-add
  "td" 'go-tag-remove
  "tg" 'go-gen-test-dwim)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package command-log-mode
  :commands command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-solarized-light t))

;; (use-package all-the-icons)

;; (use-package doom-modeline
;;   :init (doom-modeline-mode 1)
;;   :custom ((doom-modeline-height 10)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;(prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Source Code Pro" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

;; (defun efs/org-mode-setup ()
;;   (org-indent-mode)
;;   (variable-pitch-mode 1)
;;   (visual-line-mode 1))

;; (use-package org
;;   :pin org
;;   :commands (org-capture org-agenda)
;;   :hook (org-mode . efs/org-mode-setup)
;;   :config
;;   (setq org-ellipsis " ▾")

;;   (setq org-agenda-start-with-log-mode t)
;;   (setq org-log-done 'time)
;;   (setq org-log-into-drawer t)

;;   (setq org-agenda-files
;;         '("~/Projects/Code/emacs-from-scratch/OrgFiles/Tasks.org"
;;           "~/Projects/Code/emacs-from-scratch/OrgFiles/Habits.org"
;;           "~/Projects/Code/emacs-from-scratch/OrgFiles/Birthdays.org"))

;;   (require 'org-habit)
;;   (add-to-list 'org-modules 'org-habit)
;;   (setq org-habit-graph-column 60)

;;   (setq org-todo-keywords
;;     '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
;;       (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

;;   (setq org-refile-targets
;;     '(("Archive.org" :maxlevel . 1)
;;       ("Tasks.org" :maxlevel . 1)))

;;   ;; Save Org buffers after refiling!
;;   (advice-add 'org-refile :after 'org-save-all-org-buffers)

;;   (setq org-tag-alist
;;     '((:startgroup)
;;        ; Put mutually exclusive tags here
;;        (:endgroup)
;;        ("@errand" . ?E)
;;        ("@home" . ?H)
;;        ("@work" . ?W)
;;        ("agenda" . ?a)
;;        ("planning" . ?p)
;;        ("publish" . ?P)
;;        ("batch" . ?b)
;;        ("note" . ?n)
;;        ("idea" . ?i)))

;;   ;; Configure custom agenda views
;;   (setq org-agenda-custom-commands
;;    '(("d" "Dashboard"
;;      ((agenda "" ((org-deadline-warning-days 7)))
;;       (todo "NEXT"
;;         ((org-agenda-overriding-header "Next Tasks")))
;;       (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

;;     ("n" "Next Tasks"
;;      ((todo "NEXT"
;;         ((org-agenda-overriding-header "Next Tasks")))))

;;     ("W" "Work Tasks" tags-todo "+work-email")

;;     ;; Low-effort next actions
;;     ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
;;      ((org-agenda-overriding-header "Low Effort Tasks")
;;       (org-agenda-max-todos 20)
;;       (org-agenda-files org-agenda-files)))

;;     ("w" "Workflow Status"
;;      ((todo "WAIT"
;;             ((org-agenda-overriding-header "Waiting on External")
;;              (org-agenda-files org-agenda-files)))
;;       (todo "REVIEW"
;;             ((org-agenda-overriding-header "In Review")
;;              (org-agenda-files org-agenda-files)))
;;       (todo "PLAN"
;;             ((org-agenda-overriding-header "In Planning")
;;              (org-agenda-todo-list-sublevels nil)
;;              (org-agenda-files org-agenda-files)))
;;       (todo "BACKLOG"
;;             ((org-agenda-overriding-header "Project Backlog")
;;              (org-agenda-todo-list-sublevels nil)
;;              (org-agenda-files org-agenda-files)))
;;       (todo "READY"
;;             ((org-agenda-overriding-header "Ready for Work")
;;              (org-agenda-files org-agenda-files)))
;;       (todo "ACTIVE"
;;             ((org-agenda-overriding-header "Active Projects")
;;              (org-agenda-files org-agenda-files)))
;;       (todo "COMPLETED"
;;             ((org-agenda-overriding-header "Completed Projects")
;;              (org-agenda-files org-agenda-files)))
;;       (todo "CANC"
;;             ((org-agenda-overriding-header "Cancelled Projects")
;;              (org-agenda-files org-agenda-files)))))))

;;   (setq org-capture-templates
;;     `(("t" "Tasks / Projects")
;;       ("tt" "Task" entry (file+olp "~/Projects/Code/emacs-from-scratch/OrgFiles/Tasks.org" "Inbox")
;;            "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

;;       ("j" "Journal Entries")
;;       ("jj" "Journal" entry
;;            (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
;;            "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
;;            ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
;;            :clock-in :clock-resume
;;            :empty-lines 1)
;;       ("jm" "Meeting" entry
;;            (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
;;            "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
;;            :clock-in :clock-resume
;;            :empty-lines 1)

;;       ("w" "Workflows")
;;       ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
;;            "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

;;       ("m" "Metrics Capture")
;;       ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
;;        "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

;;   (define-key global-map (kbd "C-c j")
;;     (lambda () (interactive) (org-capture nil "jj")))

;;   (efs/org-font-setup))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  (setq lsp-headerline-breadcrumb-icons-enable nil)
  (setq lsp-enable-file-watchers t)
  (setq lsp-file-watch-threshold nil) ;; no waring when file greater than threshold
  :config
  (lsp-enable-which-key-integration t))

(efs/leader-keys
  "l"  '(:ignore t :which-key "lsp")
  "ld" 'xref-find-definitions
  "lr" 'xref-find-references
  "ln" 'lsp-ui-find-next-reference
  "lp" 'lsp-ui-find-prev-reference
  "ls" 'counsel-imenu
  "le" 'lsp-ui-flycheck-list
  "lS" 'lsp-ui-sideline-mode
  "lX" 'lsp-execute-code-action
  "lk" 'lsp-workspace-restart
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'up)
  (lsp-ui-doc-enable t))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package go-mode
  :ensure t
  :mode (("\\.go\\'" . go-mode))
  :hook (go-mode . lsp-deferred)
:init
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
)

(use-package go-tag)
(use-package go-gen-test)
(use-package go-impl)

(evil-declare-key 'normal go-mode-map
  "ta" 'go-tag-add
  "tr" 'go-tag-refresh
  "td" 'go-tag-remove

  "gd" 'lsp-find-definition
  "gr" 'lsp-find-references
  "gi" 'lsp-find-implementation
  "gb" 'evil-jump-backward
  )

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  ;; :bind (:map company-active-map
  ;;        ("<tab>" . company-complete-selection))
  ;;       (:map lsp-mode-map
  ;;        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(add-hook 'after-init-hook 'global-company-mode)

(defun dw/switch-project-action ()
  "Switch to a workspace with the project name and start `magit-status'."
  ;; TODO: Switch to EXWM workspace 1?
  (persp-switch (projectile-project-name))
  (magit-status))

(use-package ag)
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind ("C-M-p" . projectile-find-file)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'dw/switch-project-action)
  (setq projectile-git-submodule-command nil))

(use-package counsel-projectile
  :disabled
  :after projectile
  :config
  (counsel-projectile-mode))

(efs/leader-keys
  "pf" 'projectile-find-file
  "ps" 'projectile-switch-project
  "pF" 'consult-ripgrep
  "pf" 'projectile-find-file
  "pc" 'projectile-compile-project
  "pk" 'projectile-kill-buffers
  "pb" 'projectile-switch-to-buffer
  "pd" 'projectile-dired
  "pr" 'projectile-grep
  "pa" 'projectile-ag
  )

(use-package magit
  :bind ("C-M-;" . magit-status)
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(efs/leader-keys
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

(use-package magit-todos
  :defer t)

(use-package git-gutter-fringe
  ;; :straight git-gutter-fringe
  :diminish
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2)
  (unless dw/is-termux
    (require 'git-gutter-fringe)
    (set-face-foreground 'git-gutter-fr:added "LightGreen")
    (fringe-helper-define 'git-gutter-fr:added nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

    (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
    (fringe-helper-define 'git-gutter-fr:modified nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

    (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
    (fringe-helper-define 'git-gutter-fr:deleted nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"))

  ;; These characters are used in terminal mode
  (setq git-gutter:modified-sign "≡")
  (setq git-gutter:added-sign "≡")
  (setq git-gutter:deleted-sign "≡")
  (set-face-foreground 'git-gutter:added "LightGreen")
  (set-face-foreground 'git-gutter:modified "LightGoldenrod")
  (set-face-foreground 'git-gutter:deleted "LightCoral"))

(use-package vc-msg)

(use-package rainbow-delimiters
  :hook (gerbil-mode . rainbow-delimiters-mode))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

;; (use-package all-the-icons-dired)

(use-package dired
  :ensure nil
  ;; :straight nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-hide-details-hide-symlink-targets nil
        delete-by-moving-to-trash t)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (dired-omit-mode 1)
              (dired-hide-details-mode 1)
              (unless (or dw/is-termux
                          (s-equals? "/gnu/store/" (expand-file-name default-directory))))
                ;; (all-the-icons-dired-mode 1))
              (hl-line-mode 1)))

  (use-package dired-rainbow
    :defer 2
    :config
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

  (use-package dired-single
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "p" 'dired-ranger-paste))

;; (defun dw/dired-link (path)
;;   (lexical-let ((target path))
;;     (lambda () (interactive) (message "Path: %s" target) (dired target))))

;; (dw/leader-key-def
;;   "d"   '(:ignore t :which-key "dired")
;;   "dd"  '(dired :which-key "Here")
;;   "dh"  `(,(dw/dired-link "~") :which-key "Home")
;;   "dn"  `(,(dw/dired-link "~/Notes") :which-key "Notes")
;;   "do"  `(,(dw/dired-link "~/Downloads") :which-key "Downloads")
;;   "dp"  `(,(dw/dired-link "~/Pictures") :which-key "Pictures")
;;   "dv"  `(,(dw/dired-link "~/Videos") :which-key "Videos")
;;   "d."  `(,(dw/dired-link "~/.dotfiles") :which-key "dotfiles")
;;   "de"  `(,(dw/dired-link "~/.emacs.d") :which-key ".emacs.d"))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

(require 'org)

(defvar dw/org-roam-project-template
  '("p" "project" plain "** TODO %?"
    :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
			   "#+title: ${title}\n#+category: ${title}\n#+filetags: Project\n"
			   ("Tasks"))))

(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
	  (seq-filter
	   (my/org-roam-filter-by-tag tag-name)
	   (org-roam-node-list))))

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
	(org-roam-capture-templates (list (append (car org-roam-capture-templates)
						  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(defun dw/org-roam-goto-month ()
  (interactive)
  (org-roam-capture- :goto (when (org-roam-node-from-title-or-alias (format-time-string "%Y-%B")) '(4))
		     :node (org-roam-node-create)
		     :templates '(("m" "month" plain "\n* Goals\n\n%?* Summary\n\n"
				   :if-new (file+head "%<%Y-%B>.org"
						"#+title: %<%Y-%B>\n#+filetags: Project\n")
				   :unnarrowed t))))

(defun dw/org-roam-goto-year ()
  (interactive)
  (org-roam-capture- :goto (when (org-roam-node-from-title-or-alias (format-time-string "%Y")) '(4))
		     :node (org-roam-node-create)
		     :templates '(("y" "year" plain "\n* Goals\n\n%?* Summary\n\n"
				   :if-new (file+head "%<%Y>.org"
						"#+title: %<%Y>\n#+filetags: Project\n")
				   :unnarrowed t))))

(defun my/org-roam-project-finalize-hook ()
  "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
  ;; Remove the hook since it was added temporarily
  (remove-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

  ;; Add project file to the agenda list if the capture was confirmed
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
(add-to-list 'org-agenda-files (buffer-file-name)))))

(defun dw/org-roam-capture-task ()
  (interactive)
  ;; Add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

  ;; Capture the new task, creating the project file if necessary
  (org-roam-capture- :node (org-roam-node-read
			    nil
			    (my/org-roam-filter-by-tag "Project"))
		     :templates (list dw/org-roam-project-template)))

(defun my/org-roam-refresh-agenda-list ()
  (interactive)
  (setq org-agenda-files (my/org-roam-list-notes-by-tag "Project")))


(defhydra dw/org-roam-jump-menu (:hint nil)
  "
^Dailies^        ^Capture^       ^Jump^
^^^^^^^^-------------------------------------------------
_t_: today       _T_: today       _m_: current month
_r_: tomorrow    _R_: tomorrow    _e_: current year
_y_: yesterday   _Y_: yesterday   ^ ^
_d_: date        ^ ^              ^ ^
"
  ("t" org-roam-dailies-goto-today)
  ("r" org-roam-dailies-goto-tomorrow)
  ("y" org-roam-dailies-goto-yesterday)
  ("d" org-roam-dailies-goto-date)
  ("T" org-roam-dailies-capture-today)
  ("R" org-roam-dailies-capture-tomorrow)
  ("Y" org-roam-dailies-capture-yesterday)
  ("m" dw/org-roam-goto-month)
  ("e" dw/org-roam-goto-year)
  ("c" nil "cancel"))

(use-package org-roam
  :demand t
  ;; :straight t
  :init
  (setq org-roam-v2-ack t)
  (setq dw/daily-note-filename "%<%Y-%m-%d>.org"
	dw/daily-note-header "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
  :custom
  (org-roam-directory "~/Notes/Roam/")
  (org-roam-dailies-directory "Journal/")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
			 "#+title: ${title}\n")
:unnarrowed t)))
  (org-roam-dailies-capture-templates
   `(("d" "default" entry
"* %?"
:if-new (file+head ,dw/daily-note-filename
			 ,dw/daily-note-header))
     ("t" "task" entry
"* TODO %?\n  %U\n  %a\n  %i"
:if-new (file+head+olp ,dw/daily-note-filename
			     ,dw/daily-note-header
			     ("Tasks"))
:empty-lines 1)
     ("l" "log entry" entry
"* %<%I:%M %p> - %?"
:if-new (file+head+olp ,dw/daily-note-filename
			     ,dw/daily-note-header
			     ("Log")))
     ("j" "journal" entry
"* %<%I:%M %p> - Journal  :journal:\n\n%?\n\n"
:if-new (file+head+olp ,dw/daily-note-filename
			     ,dw/daily-note-header
			     ("Log")))
     ("m" "meeting" entry
"* %<%I:%M %p> - %^{Meeting Title}  :meetings:\n\n%?\n\n"
:if-new (file+head+olp ,dw/daily-note-filename
			     ,dw/daily-note-header
			     ("Log")))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n d" . dw/org-roam-jump-menu/body)
	 ("C-c n c" . org-roam-dailies-capture-today)
	 ("C-c n t" . dw/org-roam-capture-task)
	 ("C-c n g" . org-roam-graph)
	 :map org-mode-map
	 (("C-c n i" . org-roam-node-insert)
	  ("C-c n I" . org-roam-insert-immediate)))
  :config
  (org-roam-db-autosync-mode)

  ;; Build the agenda list the first time for the session
  (my/org-roam-refresh-agenda-list))



(require 'org-roam-dailies)

(defun my/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep t) ;; Set this to nil to delete the original!
	(org-roam-dailies-capture-templates
	 '(("t" "tasks" entry "%?"
	    :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
	(org-after-refile-insert-hook #'save-buffer)
	today-file
	pos)
    (save-window-excursion
(org-roam-dailies--capture (current-time) t)
(setq today-file (buffer-file-name))
(setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless (equal (file-truename today-file)
		   (file-truename (buffer-file-name)))
(org-refile nil nil (list "Tasks" today-file nil pos)))))

(add-to-list 'org-after-todo-state-change-hook
	     (lambda ()
	 (when (equal org-state "DONE")
		 (my/org-roam-copy-todo-to-today))))

(use-package deft
  :commands (deft)
  :config (setq deft-directory "~/Notes/Roam"
                deft-recursive t
                deft-extensions '("md" "org")))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

(use-package lispy
  :hook ((emacs-lisp-mode . lispy-mode)
         (scheme-mode . lispy-mode)))

;; (use-package evil-lispy
;;   :hook ((lispy-mode . evil-lispy-mode)))

(use-package lispyville
  :hook ((lispy-mode . lispyville-mode))
  :config
  (lispyville-set-key-theme '(operators c-w additional
                              additional-movement slurp/barf-cp
                              prettify)))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(defun dw/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'dw/set-js-indentation)
  (add-hook 'json-mode-hook #'dw/set-js-indentation))


(use-package apheleia
  :config
  (apheleia-global-mode +1))

(use-package prettier-js
  ;; :hook ((js2-mode . prettier-js-mode)
  ;;        (typescript-mode . prettier-js-mode))
  :config
  (setq prettier-js-show-errors nil))

(use-package skewer-mode
  ;; (add-hook 'js2-mode-hook #'skewer-mode)
  ;; (add-hook 'css-mode-hook 'skewer-css-mode)
  ;; (add-hook 'html-mode-hook 'skewer-html-mode)
  :hook ((js2-mode . skewer-mode))
  )

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(efs/leader-keys
  "e"   '(:ignore t :which-key "eval")
  "eb"  '(eval-buffer :which-key "eval buffer"))

(efs/leader-keys
  :keymaps '(visual)
  "er" '(eval-region :which-key "eval region"))

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package smartparens
  :hook ((prog-mode . smartparens-mode)
         (gerbil-mode . smartparens-mode)))

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (gerbil-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :defer t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode
         gerbil-mode))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(setq-default indent-tabs-mode nil)

(setq x-select-enable-clipboard t)

(use-package restclient
  :mode (("\\.http\\'" . restclient-mode)))

(use-package elpa-mirror)

(use-package gerbil-mode
  :when (getenv "GERBIL_HOME")
  :ensure nil
  :defer t
  :mode (("\\.ss\\'"  . gerbil-mode)
         ("\\.pkg\\'" . gerbil-mode))
  :bind (:map comint-mode-map
              (("C-S-n" . comint-next-input)
               ("C-S-p" . comint-previous-input)
               ("C-S-l" . clear-comint-buffer))
              :map gerbil-mode-map
              (("C-S-l" . clear-comint-buffer)))
  :init
  (setf gambit (getenv "GAMBIT_HOME"))
  (setf gerbil (getenv "GERBIL_HOME"))
  (autoload 'gerbil-mode
    "~/.emacs.d/localelpa/gerbil-mode.el" "Gerbil editing mode." t)
  :hook
  ((inferior-scheme-mode-hook . gambit-inferior-mode))
  :config
  (require 'gambit
           "~/.emacs.d/localelpa/gambit.el")
  (setf scheme-program-name (concat gerbil "/bin/gxi"))

  (let ((tags (locate-dominating-file default-directory "TAGS")))
    (when tags (visit-tags-table tags)))
  (visit-tags-table "~/Downloads/gerbil-0.16/TAGS")

  (when (package-installed-p 'smartparens)
    (sp-pair "'" nil :actions :rem)
    (sp-pair "`" nil :actions :rem))

  (defun clear-comint-buffer ()
    (interactive)
    (with-current-buffer "*scheme*"
      (let ((comint-buffer-maximum-size 0))
        (comint-truncate-buffer)))))

(defun gerbil-setup-buffers ()
  "Change current buffer mode to gerbil-mode and start a REPL"
  (interactive)
  (gerbil-mode)
  (split-window-right)
  (shrink-window-horizontally 2)
  (let ((buf (buffer-name)))
    (other-window 1)
    (run-scheme "gxi")
    (switch-to-buffer-other-window "*scheme*" nil)
    (switch-to-buffer buf)))

(global-set-key (kbd "C-c C-g") 'gerbil-setup-buffers)

(recentf-mode 1)
(setq recentf-max-menu-items 10)
(setq recentf-max-saved-items 10)

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :bind ("C-j" . yas-expand)
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-global-mode 1)
  (yas-reload-all))

(use-package yasnippet-snippets)

(use-package winum
  :defer t
  :config
  (winum-mode 1))

(efs/leader-keys
  "0" 'winum-select-window-0
  "1" 'winum-select-window-1
  "2" 'winum-select-window-2
  "3" 'winum-select-window-3
  "4" 'winum-select-window-4)

;; (use-package geiser-gambit
;;   :ensure t
;;   :config
;;   (setq geiser-active-implementations '(gambit))
;;   )

;; (use-package geiser-mit
;;   :ensure t
;;   :config
;;   (setq geiser-active-implementations '(mit))
;;   )

;; (use-package geiser-chez
;;   :ensure t
;;   :config
;;   (setq geiser-active-implementations '(chez))
;;   (setq geiser-chez-binary "/usr/local/bin/chez")
;;   )


;; (my-local-leader-def 'normal scheme-mode-map
;;   "x" 'geiser
;;   "'" 'geiser-mode-switch-to-repl
;;   "gg" 'xref-find-definitions
;;   "gr" 'xref-find-references
;;   "gb" 'evil-jump-backward
;;   "lf" 'geiser-load-file
;;   "ed" 'geiser-eval-definition-and-go
;;   )


;; (use-package geiser-chicken
;;   :ensure t
;;   :config
;;   (setq geiser-active-implementations '(chicken)))

(use-package paredit)
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)

;; teacher yin conf
(require 'cmuscheme)
(setq scheme-program-name "chez")         ;; 如果用 Petite 就改成 "petite"

;; bypass the interactive question and start the default interpreter
(defun scheme-proc ()
  "Return the current Scheme process, starting one if necessary."
  (unless (and scheme-buffer
               (get-buffer scheme-buffer)
               (comint-check-proc scheme-buffer))
    (save-window-excursion
      (run-scheme scheme-program-name)))
  (or (scheme-get-process)
      (error "No current process. See variable `scheme-buffer'")))

(defun scheme-split-window ()
  (cond
   ((= 1 (count-windows))
    (delete-other-windows)
    (split-window-vertically (floor (* 0.68 (window-height))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window 1))
   ((not (member "*scheme*"
               (mapcar (lambda (w) (buffer-name (window-buffer w)))
                       (window-list))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window -1))))

(defun scheme-send-last-sexp-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-last-sexp))

(defun scheme-send-definition-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-definition))

(add-hook 'scheme-mode-hook
  (lambda ()
    (paredit-mode 1)
    (define-key scheme-mode-map (kbd "<f5>") 'scheme-send-last-sexp-split-window)
    (define-key scheme-mode-map (kbd "<f6>") 'scheme-send-definition-split-window)))

(use-package shen-mode
  )

(use-package sly
  :config
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  )

(evil-declare-key 'normal lisp-mode-map
  "gd" 'sly-edit-definition
  "gr" 'sly-who-references
  "gc" 'sly-who-calls
  "gm" 'sly-who-macroexpands
  "gf" 'sly-compile-defun
  "gb" 'sly-pop-find-definition-stack
  ;; "ds" 'sly-stickers-dwim
  ;; "dr" 'sly-stickers-replay
  ;; "dt" 'sly-stickers-toggle-break-on-stickers
  ;; "df" 'sly-stickers-fetch
  )

(my-local-leader-def 'normal lisp-mode-map
  "sf" 'paredit-forward-slurp-sexp
  "sb" 'paredit-backward-slurp-sexp
  "bf" 'paredit-forward-barf-sexp
  "bb" 'paredit-backward-barf-sexp
  "r" 'paredit-raise-sexp
  "w" 'paredit-wrap-sexp)



(evil-declare-key 'normal sly-mrepl-mode-map
  "sb" 'isearch-backward
  )

(use-package racket-mode)

(add-hook 'racket-mode-hook #'racket-xp-mode)

(my-local-leader-def 'normal racket-mode-map
  "x" 'racket-run
  "s" 'paredit-forward-slurp-sexp
  "b" 'paredit-forward-barf-sexp
  "r" 'paredit-raise-sexp
  "gg" 'xref-find-definitions
  "gr" 'xref-find-references
  "gb" 'evil-jump-backward
  ;; "bs" 'paredit-backward-slurp-sexp
  ;; "bb" 'paredit-backward-barf-sexp
  )
(evil-declare-key 'normal racket-mode-map
  "gb" 'evil-jump-backward)


(when (require 'paredit nil t)
  (dolist (map (list racket-mode-map lisp-mode-map emacs-lisp-mode-map))
    (define-key map (kbd "C-s r") 'paredit-raise-sexp)
    (define-key map (kbd "C-s =") 'paredit-reindent-defun)))

(use-package rustic)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rustic vc-msg yasnippet-snippets ws-butler winum which-key wgrep vterm visual-fill-column use-package typescript-mode smartparens sly skewer-mode shen-mode restclient rainbow-mode rainbow-delimiters racket-mode pyvenv python-mode project prettier-js paredit org-roam org-bullets org-appear no-littering magit-todos lsp-ui lsp-ivy lispyville ivy-rich ivy-prescient helpful go-tag go-impl go-guru go-gen-test git-gutter-fringe general geiser-mit geiser-gambit geiser-chicken geiser-chez forge flycheck evil-nerd-commenter evil-collection eterm-256color eshell-git-prompt elpa-mirror doom-themes doom-modeline dired-single dired-ranger dired-rainbow dired-open dired-hide-dotfiles dired-collapse deft dap-mode counsel-projectile company-box command-log-mode bufler auto-package-update apheleia all-the-icons-dired ag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
