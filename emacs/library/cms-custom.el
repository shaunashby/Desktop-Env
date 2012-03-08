;; cms-custom.el --- Customisations for the CMS software.

(setq compile-command		"eval `scram runtime -sh`; scram b"
      gc-cons-threshold		8388607)

(load-library "cms-utils")
(load-library "cms-insert")
(load-library "cms-cc-mode")
(load-library "cms-cc-faces")
(load-library "cms-faces")
(load-library "cms-lxr")
