#lang racket
;; config
(define from-file "path.txt")
(define dest-file "path_gen.txt")
(define sep ";")

;; holder
(define folder-to-add (make-parameter '()))

(define (lines-to-path content)
  (string-replace (string-replace content "\r" "") "\n" ";"))

;; path.txt -> path_gen.txt
(define (compile from to)
  (unless (file-exists? from)
    (raise (string-append "No such file: " from)))
  (display (string-append "Compiling " from " to " to))

  (define content (file->string from)) ; read content
  
  (when (file-exists? to) ; clean old file
    (delete-file to))
  (display-to-file (lines-to-path content) to))

(define (add-folder folder)
  (display (string-append "Adding folder " folder))
  (raise "TODO"))

;; main program
(command-line
  #:program "Path"
  #:once-each ; TODO, many + (folder-to-add (cons folder (folder-to-add))) ?
  [("-a" "--add") folder ; take a parameter
                  ("Add a folder to the %PATH%")
                  (folder-to-add folder)]
  #:args ()

  (unless (null? (folder-to-add)) (add-folder (folder-to-add)))
  (compile from-file dest-file))