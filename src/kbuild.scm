#! /usr/bin/env -S guile -e main -s
!#

(use-modules (ice-9 ftw))
(define typemap
  '(("otp" . "Makefile.otp")
    ("beam" . "Makefile.beam")))

(define (list-files dir)
  (define (enter? file stat result)
    (string= file dir))

  (define (leaf file stat result)
    (cons file result))

  (define (down name stat result) result)
  (define (up name stat result) result)
  (define (skip name stat result) result)

  (define (error name st errno result)
    (format (current-error-port) "warning: ~a: ~a~%"
	    name (strerror errno))
    result)

  (file-system-fold enter? leaf down up skip error
		    '()
		    dir))


(use-modules (srfi srfi-37))
(define (main args)
  (let* ((pfx (getenv "PREFIX"))
	 (results (make-hash-table 2))
	 (options `(,(option '(#\v "version") #f #f
			     (lambda _ (display "kbuild-config version 0.1.0\n") (quit)))
		    ,(option '(#\h "help") #f #f
			     (lambda _ (display "\
kbuild [options]
  -v, --version    Display version
  -h, --help       Display this help
")
				     (quit)))
		    ,(option '(#\t "type") #t #f
			     (lambda (o n type seeds)
			       (let ((types (hashq-ref results 'types)))
				 (hashq-set! results 'types (cons type types))
				 seeds
				 ))))))
    (hashq-set! results 'types '())
    (args-fold args
		       options
		       (lambda (o n x vals)
			 (display "unrecognized option " n))
		       (lambda (op loads) (cons op loads))
		       '())
    (if (access? "kbuild" F_OK) #t (mkdir "kbuild"))
    (display (list-files "src/kbuild"))
    ;; (for-each
    ;;  (lambda (x)
    ;;    (let ((entry (assoc x typemap)))
    ;; 	 (if entry
    ;; 	     (let* ((filename (cdr entry))
    ;; 		    (src (string-append pfx "/lib/" filename))
    ;; 		    (dest (string-append "kbuild/" filename)))
    ;; 	       (display (format #f "COPYING: ~a -> ~a\n" src dest))
    ;; 	       (copy-file src dest))
    ;; 	     (begin
    ;; 	       (format (current-error-port) "Invalid type: ~a\n" x)
    ;; 	       (display (hashq-ref results 'types))
    ;; 	       (quit 1)))))
    ;;  (hashq-ref results 'types))
    (display "ok.\n")
    (newline)))
