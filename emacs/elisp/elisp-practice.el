This buffer is for notes you don't want to save, and for Lisp evaluation.
If you want to create a file, visit that file with C-x C-f,
then enter the text in that file's own buffer.

(defun insert-class (&optional classname)
  "Add a new class description"
  (interactive)
  (setq classname (read-string "Class name: "))
  (insert 
   "\n#ifndef " (format "%-20s" (concat (upcase classname) "_H"))
   "\n#define " (format "%-20s" (concat (upcase classname) "_H"))
   "\n"
   "\n// Define a new class:"
   "\nclass " (format "%-20s" classname)
   "\n{"
   "\npublic:                          // Public parts"
   "\n" (format "   %-30s" (concat classname "();")) "// Default constructor"
   "\n" (format "   %-30s" (concat "~" classname "();")) "// Default destructor"
   "\n\n   // Public methods"
   "\n\n\n\n"
   "\nprivate:                         // Private parts"
   "\n\n\n\n"
   "\nprotected:                       // Protected parts"
   "\n\n"
   "\n};"
   "\n\n#endif\n"
   ))
