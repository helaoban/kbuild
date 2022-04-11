#! /usr/bin/env -S guile -e main -s
!#

(define typemap
  '(("otp" . "Makefile.otp")
    ("beam" . "Makefile.beam")))

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
    (for-each
     (lambda (x)
       (let ((entry (assoc x typemap)))
	 (if entry
	     (let* ((filename (cdr entry))
		    (src (string-append pfx "/lib/" filename))
		    (dest (string-append "kbuild/" filename)))
	       (display (format #f "COPY OP: ~a -> ~a\n" src dest))
	       (copy-file src dest))
	     (begin
	       (format (current-error-port) "Invalid type: ~a\n" x)
	       (display (hashq-ref results 'types))
	       (quit 1)))))
     (hashq-ref results 'types))
    (display "ok.\n")
    (newline)))
