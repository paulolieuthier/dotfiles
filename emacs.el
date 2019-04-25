; My Emacs Config

;gui settings
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(setq-default indent-tabs-mode nil
              tab-width 4
              c-basic-offset 4
              show-trailing-whitespace t
              inhibit-startup-message t
              initial-scratch-message nil
              make-backup-files nil
              auto-save-default nil
              scroll-margin 5
              scroll-conservatively 9999
              scroll-step 1
              gdb-many-windows t
              vc-follow-symlinks nil)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(show-paren-mode t)
(save-place-mode 1)
(savehist-mode 1)
(set-frame-font "Fira Mono 14")

; basic package management settings
(package-initialize nil)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (exec-path-from-shell-initialize))

(use-package base16-theme
  :config
  (load-theme 'base16-twilight t)

  (set-face-attribute 'fringe nil
                      :foreground (face-foreground 'default)
                      :background (face-background 'default)))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package evil
  :config

  (use-package evil-leader
    :config
    (global-evil-leader-mode)
    (evil-leader/set-leader "<SPC>"))

  (evil-mode 1)

  (define-key evil-normal-state-map (kbd ";") 'evil-ex)

  (define-key evil-normal-state-map (kbd "C-c") 'kill-this-buffer)
  (define-key evil-normal-state-map (kbd "M-l") 'next-buffer)
  (define-key evil-normal-state-map (kbd "M-h") 'previous-buffer)

  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)

  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right))

(use-package flycheck
  :diminish flycheck-mode
  :hook (prog-mode . flycheck-mode))

(use-package company
  :diminish company-mode
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2)
  (define-key company-mode-map [remap indent-for-tab-command] #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (global-company-mode)

  (use-package company-quickhelp))

(use-package lsp-mode
  :commands lsp
  :hook (prog-mode . lsp)
  :config

  (use-package lsp-ui
    :commands lsp-ui-mode)

  (use-package company-lsp
    :commands company-lsp))

(use-package rainbow-delimiters
  :diminish rainbow-delimiters-mode
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'text-mode-hook #'rainbow-delimiters-mode))

(use-package autopair
  :diminish autopair-mode
  :config
  (autopair-global-mode))

(use-package avy
  :diminish avy-mode
  :config
  (evil-leader/set-key "jf" 'avy-goto-char))

(use-package helm
  :diminish helm-mode
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x))

(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  (evil-leader/set-key "ps" 'projectile-switch-project)
  (setq projectile-completion-system 'helm)

  (use-package ag
    :diminish ag-mode)

  (use-package helm-projectile
    :config
    (helm-projectile-on)
    (evil-leader/set-key "pf" 'helm-projectile-find-file)))
