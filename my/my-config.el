;;; -*- no-byte-compile: t; lexical-binding: t; -*-

;; Theme
(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'modus-vivendi t))

;; Font
(set-face-attribute 'default nil
                    :height 120 :weight 'normal :family "Iosevka NFM")

;; --- Input method ---
(setq default-input-method "russian-computer")

;; Set the fringes to match the pixel height of a character. This ensures the
;; fringe is wide enough, scaling dynamically with the current font size.
(fringe-mode (frame-char-width))

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
;; Read: https://www.jamescherti.com/emacs-display-line-numbers-mode-performance/
(setq-default display-line-numbers-type t)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
(setq treesit-font-lock-level 4)

;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; Paren match highlighting
(show-paren-mode 1)

;; In Emacs, customization variables modified via the UI (e.g., M-x customize)
;; are typically stored in a separate file, commonly named 'custom.el'. To
;; ensure these settings are loaded during Emacs initialization, it is necessary
;; to explicitly load this file if it exists.
(load custom-file 'noerror 'no-message)

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  ;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
  ;; versions, except for emacs-mac.
  ;;
  ;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
  ;; this version of Emacs natively supports smooth scrolling.
  ;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
  (setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
  (pixel-scroll-precision-mode 1))

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                              "*Minibuf-0*"
                              "*Minibuf-1*"
                              "*Minibuf-2*"
                              "*Minibuf-3*"
                              "*Minibuf-4*"
                              "*Compile-Log*"
                              "*inferior-lisp*"
                              "*Fuzzy Completions*"
                              "*Apropos*"
                              "*Help*"
                              "*cvs*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*esh command on file*"))
(winner-mode 1)

(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "•")
(setq uniquify-after-kill-buffer-p t)

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(window-divider-mode 1)

;; Enables visual indication of minibuffer recursion depth after initialization.
(minibuffer-depth-indicate-mode 1)

;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)

;; When tooltip-mode is enabled, certain UI elements (e.g., help text,
;; mouse-hover hints) will appear as native system tooltips (pop-up windows),
;; rather than as echo area messages. This is useful in graphical Emacs sessions
;; where tooltips can appear near the cursor.
(setq tooltip-hide-delay 20)    ; Time in seconds before a tooltip disappears (default: 10)
(setq tooltip-delay 0.4)        ; Delay before showing a tooltip after mouse hover (default: 0.7)
(setq tooltip-short-delay 0.08) ; Delay before showing a short tooltip (Default: 0.1)
(tooltip-mode 1)

;; Keep unmodified buffers A/B/C at session end
(setq ediff-keep-variants t)

;; Automatically apply verified, safe file-local variables. This eliminates
;; confirmation prompts when loading files, while ensuring that unauthorized or
;; risky configurations are silently ignored.
(setq enable-local-variables :safe)

;; Can switch between windows by Shift+arrow
;; (windmove-default-keybindings)

;; Org-mode
(setq org-agenda-files '("~/org"))
;; Make it available at startup too, if you like

;; Bind ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

(provide 'my-config)
