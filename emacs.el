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

(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-twilight t)

  (set-face-attribute 'fringe nil
                      :foreground (face-foreground 'default)
                      :background (face-background 'default)))

(use-package evil
  :ensure t
  :config

  (use-package evil-leader
    :ensure t
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
  :ensure t
  :diminish flycheck-mode
  :config
  (global-flycheck-mode))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2)
  (define-key company-mode-map [remap indent-for-tab-command] #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (global-company-mode))

(use-package irony
  :ensure t
  :diminish irony-mode
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  ;; replace the `completion-at-point' and `complete-symbol' bindings
  ;in irony-mode's buffers by irony-mode's function
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package company-irony
  :ensure t
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package flycheck-irony
  :ensure t
  :config
  (flycheck-irony-setup))

(use-package rtags
  :ensure t
  :config
  (add-hook 'rtags-jump-hook 'evil--jumps-push)
  (add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
  (add-hook 'c++-mode-common-hook 'rtags-start-process-unless-running)
  (define-key evil-normal-state-map (kbd "gd") 'rtags-find-symbol-at-point))

(use-package cmake-ide
  :ensure t
  :config
  (defun my-cmake-ide-hook ()
    (setq cmake-ide-build-dir "./build")
    (cmake-ide-setup))

  (add-hook 'c++-mode-hook 'my-cmake-ide-hook)
  (add-hook 'c-mode-hook 'my-cmake-ide-hook))

(use-package yasnippet
  :ensure t
  :diminish yas-mode
  :config
  (yas-global-mode 1))

(use-package modern-cpp-font-lock
  :ensure t
  :diminish modern-c++-font-lock-mode
  :config
  (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

(use-package rust-mode
  :ensure t)

(use-package racer
  :ensure t
  :diminish racer-mode
  :diminish eldoc-mode
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode))

(use-package flycheck-rust
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package autopair
  :ensure t
  :diminish autopair-mode
  :config
  (autopair-global-mode))

(use-package avy
  :ensure t
  :diminish avy-mode
  :config
  (evil-leader/set-key "j" 'avy-goto-char))

(use-package helm
  :ensure t
  :diminish helm-mode
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (projectile-mode)
  (evil-leader/set-key "ps" 'projectile-run-shell)
  (setq projectile-completion-system 'helm))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  (define-key evil-normal-state-map (kbd "C-p") 'helm-projectile-find-file))
