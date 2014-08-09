#lang racket
;; config
(define +from-file+ "path.txt")
(define +dest-file+ "path_gen.txt")
(define +path-sep+ ";")

;; holder
(define *folders-to-add* (make-parameter '()))

;; global helpers
; raises an exception if the file doesn't exist
(define (ensure-file-exists file)
  (unless (file-exists? file)
    (raise (string-append "No such file: " file))))

; split by newlines, taking windows' \r into account
(define (split-newlines text)
  (string-split text #rx"\r?\n"))

;; main program
(define (compile from to line-sep folders-to-add)
  (ensure-file-exists from)
  (display (string-append "Compiling " from " to " to))

  (define lines (append
                  (split-newlines (file->string from))
                  (*folders-to-add*)))
  
  (display-lines-to-file lines from #:separator "\n" #:exists 'replace) ; overwrite original
  (display-lines-to-file lines to #:separator line-sep #:exists 'replace))

;; cli interface
(command-line
  #:program "Path"
  #:multi
  [("-a" "--add") folder
                  ("Add a folder to the %PATH%")
                  (*folders-to-add* (cons folder (*folders-to-add*)))]
  #:args ()

  (compile +from-file+ +dest-file+ +path-sep+ *folders-to-add*))