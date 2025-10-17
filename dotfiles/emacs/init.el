(require 'package)
;; (add-to-list 'package-archives
;; 	     ;; '("melpa" . "https://melpa.org/packages/"))
;; 	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; Install user-specified packages
;; (setq url-http-attempt-keepalives nil)	     
(package-initialize)
;; (package-refresh-contents)
;; (setq ensure-packages '(distinguished-theme magit))
;; (dolist (p ensure-packages)
;;     (when (not (package-installed-p p))
;;       (package-install p)))

;; Startup
(setq init-home-dir (file-name-directory user-init-file))
(global-git-commit-mode)

;; UI tweaks
(setq inhibit-startup-screen t)
;; All modes
(global-set-key (kbd "C-c o") 'ff-find-other-file)

;; octave-mode
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(custom-enabled-themes (quote (distinguished)))
 '(custom-safe-themes
   (quote
    ("aae95fc700f9f7ff70efbc294fc7367376aa9456356ae36ec234751040ed9168" default)))
 '(fill-column 80)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Terminus" :foundry "xos4" :slant normal :weight normal :height 151 :width normal)))))
