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
 auto-insert-directory          "~/.env/templates/"
 auto-insert-alist
 (append
  ;; C++ source files
  '((
     ("\\.\\(cc\\|C\\|cpp\\|cxx\\)\\'" . "C++ Source File")
     nil
     '(setq class (filename-sans-extension (buffer-name)))
     ;;
"//_______________________________________________________________________
// File: " (buffer-name) "
//________________________________________________________________________
//
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$
//
// Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
//
//
//------------------------------------------------------------------------

//<<<< INCLUDES                                                       >>>>

#include \"" class ".h\"

//<<<< PRIVATE DEFINES                                                >>>>
//<<<< PRIVATE CONSTANTS                                              >>>>
//<<<< PRIVATE TYPES                                                  >>>>
//<<<< PRIVATE VARIABLE DEFINITIONS                                   >>>>
//<<<< PUBLIC VARIABLE DEFINITIONS                                    >>>>
//<<<< CLASS STRUCTURE INITIALIZATION                                 >>>>
//<<<< PRIVATE FUNCTION DEFINITIONS                                   >>>>
//<<<< PUBLIC FUNCTION DEFINITIONS                                    >>>>
//<<<< MEMBER FUNCTION DEFINITIONS                                    >>>>

" class "::" class " (" _ ") {
}")
    ;; Package config.h
    (
     ("config\\.h" . "C/C++ Package Configuration Header File")
     nil
     '(setq copy "MyCopyRight")
     '(setq prefix (filename-sans-extension(buffer-name)))
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
     '(setq class (file-name-sans-extension (buffer-name)))
     '(setq guard "MYCLASS_H")
"//_______________________________________________________________________
// File: " (buffer-name) "
//________________________________________________________________________
//
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$
//
// Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
//
//
//------------------------------------------------------------------------

//<<<< INCLUDES                                                       >>>>
//<<<< PUBLIC DEFINES                                                 >>>>
//<<<< PUBLIC CONSTANTS                                               >>>>
//<<<< PUBLIC TYPES                                                   >>>>
//<<<< PUBLIC VARIABLES                                               >>>>
//<<<< PUBLIC FUNCTIONS                                               >>>>
//<<<< CLASS DECLARATIONS                                             >>>>

class " class " {
public:
  " class "(" _ ");
  // implicit copy constructor
  // implicit assignment operator
  // implicit destructor
private:

};

//<<<< INLINE PUBLIC FUNCTIONS                                        >>>>
//<<<< INLINE MEMBER FUNCTIONS                                        >>>>

#endif // " guard "
"
)
    ;; Java:
    (("\\.\\(jni\\|java\\)\\'" . "Java Source File")
     nil
     '(setq class (file-name-sans-extension (buffer-name)))
     '(setq guard "MYCLASS_H")
"//____________________________________________________________________
// File: " (buffer-name) "
//____________________________________________________________________
//
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$
//
// Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "
//
//--------------------------------------------------------------------
")
    ;; C:
    (("\\.c\\'" . "C Source File")
     nil
"/*********************************************************************
 File: " (buffer-name) "
----------------------------------------------------------------------

 Author: " (user-full-name)  " <" user-mail-address ">
 Update: " (format-time-string "%Y-%m-%d %T%z") "
 Revision: $Id" "$

 Copyright: " (format-time-string "%Y") " (C) " (user-full-name) "

*********************************************************************/
")) auto-insert-alist))

;; Automatic insertion of content from templates:
;;(define-auto-insert             "\.rb" "hello.rb")
