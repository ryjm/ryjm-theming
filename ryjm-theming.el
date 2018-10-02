(defun ryjm/theming-load-theme (theme)
  "Set `theme' as the current theme."
  (interactive
   (list
    (intern (completing-read "Load theme: " ryjm/gui-themes nil t))))
  (when (ryjm/theming--theme-set-p)
    (disable-theme ryjm/theming-current-theme))
  (setq ryjm/theming-current-theme theme)
  (load-theme theme t)
  (ryjm/theming--make-fringe-transparent)
  (message "Loaded theme %s" theme))

(defun ryjm/theming-load-next-theme ()
  "Load the next theme in the `ryjm/gui-themes' list of themes."
  (interactive)
  (let* ((current-idx (if (ryjm/theming--theme-set-p)
                          (cl-position ryjm/theming-current-theme ryjm/gui-themes)
                        -1))
         (theme (ryjm/theming--next-element current-idx ryjm/gui-themes)))
    (ryjm/theming-load-theme theme)))

(defun ryjm/theming-load-prev-theme ()
  (interactive)
  "Load the previous theme in the `ryjm/gui-themes' list of themes."
  (let* ((current-idx (if (ryjm/theming--theme-set-p)
                          (cl-position ryjm/theming-current-theme ryjm/gui-themes)
                        1))
         (theme (ryjm/theming--prev-element current-idx ryjm/gui-themes)))
    (ryjm/theming-load-theme theme)))

(defun ryjm/theming-load-random-theme ()
  "Load a random theme from `ryjm/theming-current-theme' (or just a nice terminal
theme if we're in the terminal."
  (interactive)
  (ryjm/theming-load-theme (ryjm/random-element ryjm/gui-themes)))

;; Tells whether there's a currently set theme.
(defun ryjm/theming--theme-set-p ()
  (boundp 'ryjm/theming-current-theme))

;; Returns the element after `current-idx' in `list' (wrapping around the list).
(defun ryjm/theming--next-element (current-idx list)
  (let ((next-idx (% (+ 1 current-idx) (length list))))
    (nth next-idx list)))

;; Returns the element before `current-idx' in `list' (wrapping around the
;; list).
(defun ryjm/theming--prev-element (current-idx list)
  (let ((next-idx (% (- (+ current-idx (length list)) 1) (length list))))
    (nth next-idx list)))

(defun ryjm/theming--make-fringe-transparent ()
  (set-face-attribute 'fringe nil
                      :foreground (face-foreground 'default)
                      :background (face-background 'default)))

(provide 'ryjm-theming)
