#! /usr/bin/env -S guile -e main -s
!#

(use-modules (ice-9 ftw))
(use-modules (ice-9 match))
(use-modules (srfi srfi-1))
(use-modules (srfi srfi-37))

(define (debug x)
  (format (current-output-port) "~a\n" x)
  x)

(define typemap
  '(("otp" .  "Makefile.otp")
    ("beam" . "Makefile.beam")
    ("web"  . "Makefile.web")))

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

(define (mkdir-with-parents dir)
  "Create directory DIR and all its ancestors."
  (let ((not-slash (char-set-complement (char-set #\/))))
    (let loop ((components (string-tokenize dir not-slash))
               (root ""))
      (match components
             ((head tail ...)
              (let ((file (string-append root "/" head)))
		(unless (file-exists? file)
		  (mkdir file))
		(loop tail file)))
             (_ #t)))))

(define* (copy-dir src-dir dest-dir)
  (for-each (lambda (f)
	      (let ((dest (string-append (canonicalize-path dest-dir) "/" (basename f))))
		(display (format #f "COPYING: ~a -> ~a\n" f dest))
		(copy-file f dest)))
	    (list-files (debug src-dir))))

(define (main args)
  (let* ((pfx (getenv "PREFIX"))
	 (results (make-hash-table 2))
	 (options `(,(option '(#\v "version") #f #f
			     (lambda _ (display "kbuild-config version 0.1.5\n") (quit)))
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
    (let ((extensions
	   (map
	    (lambda (x)
	      (let ((entry (assoc x typemap)))
		(if entry
		    (cdr entry)
		    (begin
		      (format (current-error-port) "Invalid type: ~a\n" x)
		      (quit 1)))))
	    (hashq-ref results 'types))))
      (system* "mkdir" "--parents" "kbuild/kconfig")
      (system* "mkdir" "--parents" "kbuild/ext")
      (copy-dir (string-append pfx "/lib") "kbuild")
      (copy-dir (string-append pfx "/lib/kconfig") "kbuild/kconfig")
      (for-each (lambda (x)
		  (let ((src (string-append pfx "/lib/ext/" x))
			(dest (string-append "kbuild/ext/" x)))
		    (display (format #f "COPYING: ~a -> ~a\n" src dest))
		    (copy-file src dest)))
		extensions))))
