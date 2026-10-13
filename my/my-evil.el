;;; -*- no-byte-compile: t; lexical-binding: t; -*-

;; Uncomment the following if you are using undo-fu
(setq evil-undo-system 'undo-fu)

;; Vim emulation
(use-package evil
  :init
  ;; It has to be defined before evil
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)

  ;; Make :s in visual mode operate only on the actual visual selection
  ;; (character or block), instead of the full lines covered by the selection
  (setq evil-ex-visual-char-range t)
  ;; Use Vim-style regular expressions in search and substitute commands,
  ;; allowing features like \v (very magic), \zs, and \ze for precise matches
  (setq evil-ex-search-vim-style-regexp t)
  ;; Enable automatic horizontal split below
  (setq evil-split-window-below t)
  ;; Enable automatic vertical split to the right
  (setq evil-vsplit-window-right t)
  ;; Disable echoing Evil state to avoid replacing eldoc
  (setq evil-echo-state nil)
  ;; Do not move cursor back when exiting insert state
  (setq evil-move-cursor-back nil)
  ;; Make `v$` exclude the final newline
  (setq evil-v$-excludes-newline t)
  ;; Enable fine-grained undo behavior
  (setq evil-want-fine-undo t)
  ;; Disable wrapping of search around buffer
  (setq evil-search-wrap nil)
  ;; Allow C-h to delete in insert state
  (setq evil-want-C-h-delete t)
  ;; Enable C-u to delete back to indentation in insert state
  (setq evil-want-C-u-delete t)
  ;; Whether Y yanks to the end of the line
  (setq evil-want-Y-yank-to-eol t)

  ;; Start `evil-mode'
  (evil-mode 1)

  :config
  ;; Occasionally, `evil' fails to respect `evil-search-module' when it is
  ;; defined inside the :custom block. This fix ensures the search module
  ;; is correctly set to `evil-search'.
  (setq evil-search-module 'evil-search)
  (evil-select-search-module 'evil-search-module 'evil-search))

(use-package evil-collection
  :after evil
  :init
  ;; It has to be defined before evil-collection
  (setq evil-collection-setup-minibuffer t)
  (evil-collection-init))

;; The goto-chg package is useful with Evil to jump directly to the most recent
;; edit location. This mirrors Vim's change navigation, allowing fast return to
;; where text was last modified without relying on the jump list or search.
;;
;; The goto-chg commands are bound to g; and g,
(use-package goto-chg
  :commands (goto-last-change
             goto-last-change-reverse))

;; Give Emacs tab-bar a style similar to Vim's
(use-package vim-tab-bar
  :init
  (vim-tab-bar-mode 1))

;; The evil-surround package simplifies handling surrounding characters, such as
;; parentheses, brackets, quotes, etc. It provides key bindings to easily add,
;; change, or delete these surrounding characters in pairs. For instance, you
;; can surround the currently selected text with double quotes in visual state
;; using S" or gS".
(use-package evil-surround
  :after evil
  :init
  (setq evil-surround-pairs-alist
        '((?\( . ("(" . ")"))
          (?\[ . ("[" . "]"))
          (?\{ . ("{" . "}"))

          (?\) . ("(" . ")"))
          (?\] . ("[" . "]"))
          (?\} . ("{" . "}"))

          (?< . ("<" . ">"))
          (?> . ("<" . ">"))))
  :config
  (global-evil-surround-mode 1))

;; The following code enables commenting and uncommenting by pressing gcc in
;; normal mode and gc in visual mode.
(with-eval-after-load "evil"
  (evil-define-operator my-evil-comment-or-uncomment (beg end)
    "Toggle comment for the region between BEG and END."
    (interactive "<r>")
    (comment-or-uncomment-region beg end))
  (evil-define-key 'normal 'global (kbd "gc") 'my-evil-comment-or-uncomment))

;; Uncomment the following if you are an `evil-mode' user:
(with-eval-after-load 'evil
  (define-key evil-normal-state-map "zo" 'kirigami-open-fold)
  (define-key evil-normal-state-map "zO" 'kirigami-open-fold-rec)
  (define-key evil-normal-state-map "zc" 'kirigami-close-fold)
  (define-key evil-normal-state-map "za" 'kirigami-toggle-fold)
  (define-key evil-normal-state-map "zr" 'kirigami-open-folds)
  (define-key evil-normal-state-map "zm" 'kirigami-close-folds))

(use-package enhanced-evil-paredit
  :commands enhanced-evil-paredit-mode
  :hook
  (paredit-mode . enhanced-evil-paredit-mode))

;; The `evil-matchit' package is a extensible package that allows jumping
;; between matching syntactic pairs. It provides out-of-the-box support for a
;; wide array of syntaxes, ranging from Python indentation blocks and Bash shell
;; scripting constructs to Git merge conflicts.
;;
;; Although designed to integrate cleanly with `evil-mode', the package operates
;; entirely independently and offers native commands for standard usage.
;; Additionally, it features an accessible Elisp API, enabling developers to
;; quickly write custom matching rules and integrate third-party jump functions
;; for any unsupported languages.
(use-package evil-matchit
  :commands turn-on-evil-matchit-mode
  :hook (prog-mode . turn-on-evil-matchit-mode)

  :init
  ;; Setting this to t disables the advanced Python matching algorithm.
  ;; Set to nil if you prefer the advanced block-matching behavior in Python.
  (setq evilmi-always-simple-jump t)

  ;; Uncomment the following if you are an `evil-mode' user:
  (with-eval-after-load 'evil
    (require 'evil-matchit-evil-setup))

  :config
  ;; Because evil-matchit maps its rules to traditional major modes by default,
  ;; we must manually associate the new tree-sitter modes with their respective
  ;; matching rules until the package incorporates them natively.
  (when (fboundp 'evilmi-load-plugin-rules)
    (evilmi-load-plugin-rules '(cmake-ts-mode) '(cmake))
    (evilmi-load-plugin-rules '(c-ts-mode c++-ts-mode) '(c simple))
    (evilmi-load-plugin-rules '(bash-ts-mode) '(simple sh))
    (evilmi-load-plugin-rules '(css-ts-mode) '(simple))
    (evilmi-load-plugin-rules '(php-ts-mode) '(simple template html))
    (evilmi-load-plugin-rules '(lua-ts-mode) '(simple script))
    (evilmi-load-plugin-rules '(python-ts-mode) '(simple python))
    (evilmi-load-plugin-rules '(yaml-ts-mode) '(simple yaml))))


;; For paredit+Evil mode users: enhances paredit with Evil mode compatibility
(use-package enhanced-evil-paredit
  :commands enhanced-evil-paredit-mode
  :hook
  (paredit-mode . enhanced-evil-paredit-mode))

(provide 'my-evil)
