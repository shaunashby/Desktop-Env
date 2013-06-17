;;____________________________________________________________________ 
;; File: cust-autoinsert.el
;;____________________________________________________________________ 
;;  
;; Author: Shaun Ashby <shaun@ashby.ch>
;; Update: 2013-06-17 11:44:38+0200
;; Revision: $Id$ 
;;
;; Copyright: 2013 (C) Shaun Ashby
;;
;;--------------------------------------------------------------------

;; Set up autoinsert-mode first:
(load-library "autoinsert")
(add-hook 'find-file-hooks 'auto-insert)

;; Set up the mappings between file types and content to be inserted:
(setq
 auto-insert			t
 auto-insert-alist
 (append
  ;; C++ source files
  '((
     ("\\.\\(cc\\|C\\|cpp\\|cxx\\)\\'" . "C++ Program File")
     nil
     '(setq blah "TheBlah")
     ;;
     "//<<<<<< INCLUDES                                                       >>>>>>

" blah "#include \"" blah "\"

//<<<<<< PRIVATE DEFINES                                                >>>>>>
//<<<<<< PRIVATE CONSTANTS                                              >>>>>>
//<<<<<< PRIVATE TYPES                                                  >>>>>>
//<<<<<< PRIVATE VARIABLE DEFINITIONS                                   >>>>>>
//<<<<<< PUBLIC VARIABLE DEFINITIONS                                    >>>>>>
//<<<<<< CLASS STRUCTURE INITIALIZATION                                 >>>>>>
//<<<<<< PRIVATE FUNCTION DEFINITIONS                                   >>>>>>
//<<<<<< PUBLIC FUNCTION DEFINITIONS                                    >>>>>>
//<<<<<< MEMBER FUNCTION DEFINITIONS                                    >>>>>>

" blah "::" blah " (" _ ") {
}")
    ;; Package config.h
    (
     ("config\\.h\\'" . "C/C++ Package Configuration Header File")
     nil
     '(setq copy "MyCopyRight")
     ;;
     copy
"
# ifndef " prefix "_API
#  define " prefix "_API
# endif

#endif // " guard "
")
    ;; C/C++ header files 
    (("\\.\\(h\\|hxx\\)\\'" . "C/C++ Header File")
     nil
"
//<<<<<< INCLUDES                                                       >>>>>>
//<<<<<< PUBLIC DEFINES                                                 >>>>>>
//<<<<<< PUBLIC CONSTANTS                                               >>>>>>
//<<<<<< PUBLIC TYPES                                                   >>>>>>
//<<<<<< PUBLIC VARIABLES                                               >>>>>>
//<<<<<< PUBLIC FUNCTIONS                                               >>>>>>
//<<<<<< CLASS DECLARATIONS                                             >>>>>>

class " class " {
 public:
   " class " (" _ ");
   // implicit copy constructor
   // implicit assignment operator
   // implicit destructor
 private:

};

//<<<<<< INLINE PUBLIC FUNCTIONS                                        >>>>>>
//<<<<<< INLINE MEMBER FUNCTIONS                                        >>>>>>

#endif // " guard "
"
)) auto-insert-alist))
