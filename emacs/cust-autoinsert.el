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

; Manage settings which can be used elsewhere in the templates:
(defun project-settings (filename)
  "*Determine/set the project settings for the file named FILENAME."
  (cond ((string-match "/classlib/" filename)
	 `((copyright-owner		. "Shaun Ashby <shaun@ashby.ch>")
	   (copyright-desc		. "C++ Class Library")
	   (copyright-year		. ,(concat "2012-"
						   (substring
						    (current-time-string) -4)))
	   (copyright-style		. single-line)
	   (copyright-prefix		. "//")
	   (copyright-separator		. nil)
	   (project-conf-file		. "classlib/system.h")
	   (package-prefix		. "classlib")
	   (package-root		. "../COPYING")
	   ))

	((string-match "/Projects/" filename)
	 '((project-conf-file		. "config.h")
	   (license-type                . gpl)
	   ))
	(t
	 '((project-conf-file           . "include/arch.h")
	   (license-type                . apache2)
	   ))
	))

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
// Created: " (format-time-string "%Y-%m-%d %T%z") "
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
    ;; Configuration headers:
    (("config\\.h\\'" . "GNU-like config.h Header File.")
     nil
"
/* config.h */
#ifndef " prefix "
 #define " prefix " 1
//<<<< INCLUDES                                                       >>>>

//<<<< PRIVATE DEFINES                                                >>>>


#endif
")
    ;; C/C++ header files 
    (("\\.\\(h\\|hxx\\)\\'" . "C/C++ Header File")
     nil
     '(setq class (file-name-sans-extension (buffer-name)))
     '(setq guard (concat (upcase class) "_H"))
"#ifndef " guard "
#define " guard " 1
//________________________________________________________________________
// File: " (buffer-name) "
//________________________________________________________________________
//
// Author: " (user-full-name)  " <" user-mail-address ">
// Created: " (format-time-string "%Y-%m-%d %T%z") "
// Revision: $Id" "$
// Description: " (read-string "Description: ") "
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
  // virtual ~" class "();
  // implicit copy constructor
  // implicit assignment operator
  // implicit destructor
private:
  // " class "(const " class " & r);
  // " class " & operator=(const " class " & r);
};

//<<<< INLINE PUBLIC FUNCTIONS                                        >>>>
// inline std::ostream & operator<< (std::ostream & O, const " class " & rhs);

//<<<< INLINE MEMBER FUNCTIONS                                        >>>>

#endif // " guard "
")
    ;; Autoconf configuration files:
    (("configure\\.\\(in\\|ac\\)\\'" . "Autoconf Input Files")
     nil
     "dnl Process this file with autoconf to produce a `configure' script
dnl ____________________________________________________________________
dnl  File: " (buffer-name) "
dnl ____________________________________________________________________
dnl
dnl  Author: " (user-full-name)  " <" user-mail-address ">
dnl  Created: " (format-time-string "%Y-%m-%d %T%z") "
dnl  Revision: $Id" "$
dnl  Description: " (read-string "Description: ") "
dnl
dnl  Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
dnl
dnl --------------------------------------------------------------------
AC_PREREQ(2.69)
AC_REVISION($Revision: 0.1 $)

dnl Initialisation:
AC_INIT(" (read-string "Unique file: ")")\n"
"AC_CONFIG_HEADER(" (read-string "config.h path (RET for none): ") & ")\n" | -17
     "SCREAM_INIT

dnl Configure locally and nested packages:
SCREAM_CONFIG_LOCAL
"
     (if (y-or-n-p "Does the package contain other packages? ")
	 "SCREAM_CONFIG_PACKAGES\n"
       nil)
     "\n" _ "

dnl Generate output files:
AC_OUTPUT(Makefile src/Makefile)
")
    ;; Java:
    (("\\.\\(jni\\|java\\)\\'" . "Java Source File")
     nil
     '(setq class (file-name-sans-extension (buffer-name)))
"//____________________________________________________________________
// File: " (buffer-name) "
//____________________________________________________________________
//
// Author: " (user-full-name)  " <" user-mail-address ">
// Created: " (format-time-string "%Y-%m-%d %T%z") "
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
 Created: " (format-time-string "%Y-%m-%d %T%z") "
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
 Created: " (format-time-string "%Y-%m-%d %T%z") "
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
    ;; Python:
    (("\\.py\\'" . "Python Source File")
     nil
     '(setq python-version (read-string "Python version?: "))
"#!/usr/bin/env python" python-version "
##____________________________________________________________________
## File: " (buffer-name) "
##____________________________________________________________________
##
## Author: " (user-full-name)  " <" user-mail-address ">
## Created: " (format-time-string "%Y-%m-%d %T%z") "
## Revision: $Id" "$
## Description: " (read-string "Description: ") "
##
## Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
##
##--------------------------------------------------------------------

if __name__ == \"__main__\":
  " - "
")
    ;; Ruby:
    (("\\.\\(rb\\|erb\\)\\'" . "Ruby Script/ERB Source File")
     nil
"#!/usr/bin/env ruby
#____________________________________________________________________
# File: " (buffer-name) "
#____________________________________________________________________
#
# Author: " (user-full-name)  " <" user-mail-address ">
# Created: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$
# Description: " (read-string "Description: ") "
#
# Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
#
#--------------------------------------------------------------------
  " - "
")
    ;; Perl:
    (("\\.pl\\'" . "Perl Script Source File")
     nil
"#!/usr/bin/env perl
#____________________________________________________________________
# File: " (buffer-name) "
#____________________________________________________________________
#
# Author: " (user-full-name)  " <" user-mail-address ">
# Created: " (format-time-string "%Y-%m-%d %T%z") "
# Revision: $Id" "$
# Description: " (read-string "Description: ") "
#
# Copyright (C) " (format-time-string "%Y") " " (user-full-name) "
#
#--------------------------------------------------------------------

use 5.0010;
"
(if (y-or-n-p "Use Moose? ")
    "use Moose;"
"
use warnings;
use strict;
") "
" - "
")
) auto-insert-alist))

;; Automatic insertion of content from templates
;;
;; GNU env:
(define-auto-insert             "Makefile.in" "GNU/Makefile.in")
;; Licenses:
(define-auto-insert             "LICENSE-2.0" "License/Apache-v2.0.txt")
(define-auto-insert             "COPYING"     "License/GPLv3.txt")
;; Ruby files:
(define-auto-insert             "Gemfile"     "Ruby/Gemfile")
