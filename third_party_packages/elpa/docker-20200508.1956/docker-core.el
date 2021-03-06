;;; docker-core.el --- Docker core  -*- lexical-binding: t -*-

;; Author: Philippe Vaucher <philippe.vaucher@gmail.com>

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:

(require 's)
(require 'dash)
(require 'transient)

(defgroup docker nil
  "Docker customization group."
  :group 'convenience)

(defcustom docker-command "docker"
  "The docker binary."
  :group 'docker
  :type 'string)

(defcustom docker-run-as-root nil
  "Run docker as root."
  :group 'docker
  :type 'boolean)

(defun docker-arguments ()
  "Return the latest used arguments in the `docker' transient."
  (car (alist-get 'docker transient-history)))

(defmacro docker-with-sudo (&rest body)
  (declare (indent defun))
  `(let ((default-directory (if (and docker-run-as-root (not (file-remote-p default-directory)))
                                "/sudo::"
                              default-directory)))
     ,@body))

(defun docker-shell-command-to-string (command)
  "Execute shell command COMMAND and return its output as a string.
Wrap the function `shell-command-to-string', ensuring variable `shell-file-name' behaves properly."
  (let ((shell-file-name (if (and (eq system-type 'windows-nt)
                                  (not (file-remote-p default-directory)))
                             "cmdproxy.exe"
                           "/bin/sh")))
    (shell-command-to-string command)))

(defun docker-run-docker (action &rest args)
  "Execute \"`docker-command' ACTION ARGS\"."
  (docker-with-sudo
    (let* ((command (s-join " " (-remove 's-blank? (-flatten (list docker-command (docker-arguments) action args))))))
      (message command)
      (docker-shell-command-to-string command))))

(provide 'docker-core)

;;; docker-core.el ends here
