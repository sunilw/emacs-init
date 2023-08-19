(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-auto-complete t)
 '(custom-safe-themes
   '("2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350" "fe1c13d75398b1c8fd7fdd1241a55c286b86c3e4ce513c4292d01383de152cb7" default))
 '(lsp-intelephense-stubs
   ["apache" "wordpress" "bcmath" "bz2" "calendar" "com_dotnet" "Core" "ctype" "curl" "date" "dba" "dom" "enchant" "exif" "fileinfo" "filter" "fpm" "ftp" "gd" "hash" "iconv" "imap" "interbase" "intl" "json" "ldap" "libxml" "mbstring" "mcrypt" "meta" "mssql" "mysqli" "oci8" "odbc" "openssl" "pcntl" "pcre" "PDO" "pdo_ibm" "pdo_mysql" "pdo_pgsql" "pdo_sqlite" "pgsql" "Phar" "posix" "pspell" "readline" "recode" "Reflection" "regex" "session" "shmop" "SimpleXML" "snmp" "soap" "sockets" "sodium" "SPL" "sqlite3" "standard" "superglobals" "sybase" "sysvmsg" "sysvsem" "sysvshm" "tidy" "tokenizer" "wddx" "xml" "xmlreader" "xmlrpc" "xmlwriter" "Zend OPcache" "zip" "zlib"])
 '(package-selected-packages
   '(company-phpactor exec-path-from-shell company-web vertico corfu-candidate-overlay corfu-terminal counsel-etags alert which-key lsp-ui helm doom-themes dap-mode corfu nerd-icons-ibuffer doom-modeline verb restclient-test skewer-mode websocket nodejs-repl json-mode telephone-line minions php-mode lsp-mode company web-mode yasnippet nyan-mode emmet-mode dracula-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-default-face ((t (:foreground "white"))))
 '(erc-nick-default-face ((t (:foreground "spring green" :weight bold))))
 '(php-function-call ((t (:foreground "green")))))



;;;;;;;;;;;;;;;;;;;;
;;
;; My additions
;;
;;;;;;;;;;;;;;;;;;;;

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region
   (point-min)
   (point-max) nil
   )
  (untabify (point-min) (point-max)
            ))


;; get melpa working

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)


(which-key-mode)

(load-theme 'dracula t)
(savehist-mode 1)

(yas-global-mode 1)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets" ))


;; load snippets into yasnippet

(add-hook 'emacs-startup-hook (lambda () (yas-load-directory "/home/mantis/.emacs.d/snippets")))

;; telephone-line stuff

(telephone-line-defsegment telephone-line-flymake-segment ()
  "Wraps `flymake-mode' mode-line information in a telephone-line segment."
  (when (bound-and-true-p flymake-mode)
    (telephone-line-raw
     (if (boundp 'flymake--mode-line-format) flymake--mode-line-format
       flymake-mode-line-format) t)))


;; from the lsp guid:
;; https://emacs-lsp.github.io/lsp-mode/tutorials/php-guide/

;; (setq gc-cons-threshold (* 100 1024 1024)
    ;;  read-process-output-max (* 1024 1024) ;; this line causes autocomplete fuckery
;;      company-idle-delay 0.5
  ;;    company-minimum-prefix-length 3
   ;;   lsp-idle-delay 0.5)  ;; clangd is fast




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; emmet expansions without preview

(setq emmet-preview-default nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; get automatic completions for php


(add-hook 'php-mode-hook
          '(lambda ()
             ;; Enable auto-complete-mode
             (auto-complete-mode t)

             (require 'ac-php)
             (setq ac-sources '(ac-source-php))

             ;; As an example (optional)
             (yas-global-mode 1)

             ;; Enable ElDoc support (optional)
             (ac-php-core-eldoc-setup)

             ;; Jump to definition (optional)
             (define-key php-mode-map (kbd "M-]")
               'ac-php-find-symbol-at-point)

             ;; Return back (optional)
             (define-key php-mode-map (kbd "M-[")
               'ac-php-location-stack-back)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; set up minor modes per major mode

(add-hook 'elisp-mode-hook 'auto-complete-mode)

(add-hook 'php-mode-hook 'yas-minor-mode)
(add-hook 'php-mode-hook 'auto-complete-mode)
(add-hook 'php-mode-hook 'company-mode)
(add-hook 'php-mode-hook 'lsp)
(add-hook 'php-mode-hook 'dap-mode)
(add-hook 'php-mode-hook 'electric-pair-mode)
(add-hook 'php-mode-hook  'emmet-mode )

(add-hook 'web-mode-hook 'yas-minor-mode)
(add-hook 'web-mode-hook 'lsp-mode)
(add-hook 'web-mode-hook 'company-mode)
(add-hook 'web-mode-hook 'electric-pair-mode)
(add-hook 'web-mode-hook  'emmet-mode )


(add-hook 'js-mode-hook 'yas-minor-mode)
(add-hook 'js-mode-hook 'company-mode)
;; (add-hook 'js-mode-hook 'lsp-mode)
(add-hook 'js-mode-hook 'corfu-mode )
(add-hook 'js-mode-hook 'auto-complete-mode)
(add-hook 'js-mode-hook 'electric-pair-mode)

(add-hook 'scss-mode-hook 'company-mode)
(add-hook 'scss-mode-hook 'lsp-mode)


;; try to get autocompletions with php
;; (unless (package-installed-p 'ac-php)
;;     (package-refresh-contents)
;;     (package-install 'ac-php))


;; try and get completion candidates with lsp

(with-eval-after-load 'company-mode
  (add-to-list'company-backends '(company-tern :with company-yasnippet)  )
  (add-to-list 'company-backends company-yasnippet)
  (add-to-list 'company-backends company-css)
  (add-to-list 'company-backends company-web)
  )
  

;; unfuck lsp scss fuckery

(setq lsp-enable-links nil)


;; get PATH from shell

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


(when (daemonp)
  (exec-path-from-shell-initialize))


;; for getting completions of wordpress keywords in web mode,
;; after setting up web-mode run this:
;; M-x lsp-workspace-folders-add


;; now try to get completions for basic php stuff
;; lets try ac-php

(require 'php-mode)

(add-hook 'web-mode-hook
          '(lambda ()
             ;; Enable auto-complete-mode
             (auto-complete-mode t)

             (require 'ac-php)
             (setq ac-sources '(ac-source-php))

             ;; As an example (optional)
             (yas-global-mode 1)

             ;; Enable ElDoc support (optional)
             (ac-php-core-eldoc-setup)

             ;; Jump to definition (optional)
             (define-key php-mode-map (kbd "M-]")
               'ac-php-find-symbol-at-point)

             ;; Return back (optional)
             (define-key php-mode-map (kbd "M-[")
               'ac-php-location-stack-back)))


;; (setq lsp-completion-provider :none)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; corfu


(setq corfu-auto t
      corfu-quit-no-match 'separator)

;; this might be neccessary for something, but breaks scss mode behaviour
(setq tab-always-indent 'complete)



(telephone-line-mode 1)
