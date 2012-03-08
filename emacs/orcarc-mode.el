;;; orcarc-mode.el --- major mode for editing ORCA .orcarc configuration files
;;
;; Keywords:	CMS, ORCA, configuration 
;; Author:	Shaun ASHBY (Shaun.Ashby@cern.ch)
;; Last edit:	28-05-02
;;
;; It is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; It is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your copy of Emacs; see the file COPYING.  If not, write
;; to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;
;; Information for use:
;; -----------------------------------------------
;; 
;; I couldn't get text-mode to run font-lock on my .orcarc files,
;; so I wrote this instead. Define a list of parameters to highlight
;; in orcarc-font-lock-keywords, or add to these using font-lock-add-keywords.
;; To enable automatic selection of this mode when appropriate files are
;; visited, add the following to your favourite site or personal Emacs
;; configuration file:
;;
;;   (autoload 'orcarc-mode "orcarc-mode" "autoloaded" t)
;;   (add-to-list 'auto-mode-alist '("\\orcarc\\'" . orcarc-mode))
;;   (add-to-list 'auto-mode-alist '("\\.orcarc\\'" . orcarc-mode))
;;
;;

;; Some CARF parameters. Perhaps these could be added to an Imenu menu
;; and each option could invoke a simple function to insert a value at point).
;;
;;                                 CMSRandom:Seeds
                                                         
;;                 bool
;;                                 Verbose:info
;;                                                         true
;;                 bool
;;                                 Verbose:test
;;                                                         false
;;                 bool
;;                                 Verbose:debug
;;                                                         false
;;                 Vectorstring
;;                                 FZInputFiles
                                                         
;;                 int
;;                                 G3FZ:SkipEv
;;                                                         0
;;                 float
;;                                 DBPopulator:MaxDBSize
;;                                                         1.0
;;                 int
;;                                 DBPopulator:CommitInterval
;;                                                         200
;;                 bool
;;                                 DBPopulator:UseMutex
;;                                                         true
;;                 bool
;;                                 DBPopulator:UnNamedContainers
;;                                                         false
;;                 int
;;                                 DataSet:JobsPerDB
;;                                                         4
;;                 int
;;                                 DataSet:DBPoolIncrement
;;                                                         1
;;                 string
;;                                 EDLocation::EventDB
;;                                                         Events
;;                 Vectorstring
;;                                 EDLocation::OtherDBs
                                                         
;;                 bool
;;                                 GoPersistent
;;                                                         false
;;                 bool
;;                                 Digi:Update
;;                                                         false
;;                 string
;;                                 InputCollections
                                                         
;;                 string
;;                                 OutputDataset
                                                         
;;                 unsigned int
;;                                 InputRun
;;                                                         0
;;                 unsigned int
;;                                 FirstEvent
;;                                                         0
;;                 int
;;                                 MaxEvents
;;                                                         -1
;;                 bool
;;                                 MemoryDebug
;;                                                         false
;;                 EnumPUGenType
;;                                 PUGenerator:Type
;;                                                         Poisson (Auto, Fixed, Poisson, HIC)
;;                 bool
;;                                 PUGenerator:NoReuse
                                                         
;;                 bool
;;                                 PUGenerator:AllEvents
;;                                                         false
;;                 string
;;                                 PUGenerator:xxx
                                                         
;;                 int
;;                                 PUGenerator:FirstEvent
;;                                                         -1
;;                 float
;;                                 PUGenerator:MaxRange
;;                                                         10.
;;                 float
;;                                 PUGenerator:AverageEvents
;;                                                         0.
;;                 int
;;                                 PUGenerator:MinBunch
;;                                                         999
;;                 int
;;                                 PUGenerator:MaxBunch
;;                                                         -999

;; To handle regexps:
(require 'regexp-opt)

;; Define some variables:
(defvar orcarc-mode-map nil
  "Keymap used in orcarc config mode buffers")

(defvar orcarc-mode-syntax-table nil
  "orcarc config mode syntax table")

(defvar orcarc-mode-hook nil
  "*List of hook functions run by `orcarc-mode' (see `run-hooks')")

;; Stuff for font-lock-mode:
(defconst orcarc-font-lock-keywords 
  (list
   ;; Comments starting at beginning of lines
   '("^//.*" 0 'font-lock-comment-face t)
   '("\\(FirstEvent\\|MaxEvents\\)" 1 'Orange-face t)
   '("\\(PUGenerator\\)" 1 'DarkOrchid2-face t)      
   '("\\(Barrel\\|Calo\\(RecHit\\)?\\|E\\(cal\\(TrigPrim\\)?\\|ndcap\\)\\|Hcal\\(TrigPrim\\)?\\|Muon\\|Presh\\(ower\\)?\\|Rpc\\|EndCap\\)" 1 'Aquamarine2-face t) 
   '("\\(RecApplication\\)" 1 'Turquoise2-face t)
   '("\\(FZInputFiles\\)" 1 'Green-face t)
   '("\\(G3FZ\\)" 1 'Green3-face t)
   '("\\(HepEventG3EventProxyReader\\)" 1 'DarkSlateGray4-face t)
   '("\\(DBPopulator\\)" 1 'Yellow-face t)
   '("\\(Input\\(Collections\\|Run\\)\\)" 1 'DarkOliveGreen2-face t)    
   '("\\(OutputDataSet\\)" 1 'Magenta2-face t)
   '("\\(Verbose\\)" 1 'CornflowerBlue-face t)      
   '("\\(GoPersistent\\)" 1 'CadetBlue3-face t)      
   '("FirstEvent = \\(.*\\)" 1 'modeline t)    
   '("MaxEvents = \\(.*\\)" 1 'modeline t)         
   '("FZInputFiles = \\(.*\\)" 1 'underline t)
   '("InputCollections = \\(.*\\)" 1 'underline t)
   '("OutputDataSet = \\(.*\\)" 1 'underline t)      
   '("Collection = \\(.*\\)" 1 'underline t)
   '(".*:\\([a-zA-Z0-9]*\\)" 1 'bold-italic t)
   '("^.*\\(//.*\\)" 1 'font-lock-comment-face t)
   )
  "Basic expressions to highlight in orcarc config buffers.")

;; Now a syntax table
(if orcarc-mode-syntax-table
    nil
  (setq orcarc-mode-syntax-table (copy-syntax-table nil))
  (modify-syntax-entry ?_   "_"     orcarc-mode-syntax-table)
  (modify-syntax-entry ?-   "_"     orcarc-mode-syntax-table)
  (modify-syntax-entry ?\(  "(\)"   orcarc-mode-syntax-table)
  (modify-syntax-entry ?\)  ")\("   orcarc-mode-syntax-table)
  (modify-syntax-entry ?\<  "(\>"   orcarc-mode-syntax-table)
  (modify-syntax-entry ?\>  ")\<"   orcarc-mode-syntax-table)
  (modify-syntax-entry ?\"   "\""   orcarc-mode-syntax-table))

;;;###autoload
(defun orcarc-mode ()
  "Major mode for editing orcarc configuration files.

\\{orcarc-mode-map}

\\[orcarc-mode] runs the hook `orcarc-mode-hook'."
  (interactive)
  (kill-all-local-variables)
  (use-local-map orcarc-mode-map)
  (set-syntax-table orcarc-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults)
       '(orcarc-font-lock-keywords t))
  (make-local-variable 'comment-start)
  (setq comment-start "# ")
  (make-local-variable 'comment-column)
  (setq comment-column 60)
  (setq mode-name "orcarc")
  (setq major-mode 'orcarc-mode)
  (run-hooks 'orcarc-mode-hook))

;; Finish off:
(provide 'orcarc-mode)
;;; orcarc-mode.el ends here