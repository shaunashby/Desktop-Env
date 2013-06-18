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
     '(setq class (file-name-sans-extension (buffer-name)))
"//_______________________________________________________________________
// File: " (buffer-name) "
//________________________________________________________________________
//
// Author: " (user-full-name)  " <" user-mail-address ">
// Update: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$
// Description: " (read-string "Description: ") "
//
// Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
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
// Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
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
// Description: " (read-string "Description: ") "
//
// Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
//
//--------------------------------------------------------------------
")

    ;; C main:
    (("main.c\\'" . "C Source File for Executables")
     nil
"/*****************************************************************************************
 File: " (buffer-name) "
-------------------------------------------------------------------------------------------

 Author: " (user-full-name)  " <" user-mail-address ">
 Update: " (format-time-string "%Y-%m-%d %T%z") "
 Revision: $Id" "$
 Description: " (read-string "Description: ") "

 Copyright (C) " (format-time-string "%Y") " " (user-full-name) "

 Licensed under the Apache License, Version 2.0 (the \"License\");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an \"AS IS\" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*******************************************************************************************/
#include <stdlib.h>
#include <stdio.h>

/* main */
int main(int argc, char *argv[]) {
  " - "
}")
    ;; Other C files:
    (("\\.c\\'" . "C Source File")
     nil
     '(setq project (read-string "Project name: "))
"/*****************************************************************************************
 File: " (buffer-name) "
-------------------------------------------------------------------------------------------

 Author: " (user-full-name)  " <" user-mail-address ">
 Update: " (format-time-string "%Y-%m-%d %T%z") "
 Revision: $Id" "$
 Description: " (read-string "Description: ") "

 Copyright (C) " (format-time-string "%Y") " " (user-full-name) "

 This file is part of " project ".

 " project " is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 " project " is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with " project ". If not, see <http://www.gnu.org/licenses/>.

*******************************************************************************************/
")
    ;; License files:
    (("LICENSE.txt" . "License file for GNU-like packages")
     nil
     "
")
) auto-insert-alist))

;; Automatic insertion of content from templates:
(define-auto-insert             "COPYING" "License/GPLv3.txt")
