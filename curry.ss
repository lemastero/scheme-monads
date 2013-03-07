(module curry scheme
  (provide curried-lambda define-curried)

  (define-syntax curried-lambda
    (syntax-rules ()
      ((_ () body)
       (lambda args
         (if (null? args)
             body
             apply body args)))
      ((_ (arg) body)
       (letrec
           ((partial-application
             (lambda args
               (if (null? args)
                   partial-application
                   (let ((arg (car args))
                         (rest (cdr args)))
                     (if (null? rest)
                         body
                         (apply body rest)))))))
         partial-application))
      ((_ (arg args ...) body)
       (letrec
           ((partial-application
             (lambda all-args
               (if (null? all-args)
                   partial-application
                   (let ((arg (car all-args))
                         (rest (cdr all-args)))
                     (let ((next (curried-lambda (args ...) body)))
                       (if (null? rest)
                           next
                           (apply next rest))))))))
         partial-application))))

  ;; curried defines
  (define-syntax define-curried
    (syntax-rules ()
      ((define-curried (name args ...) body)
       (define name (curried-lambda (args ...) body)))
      ((define-curried (name) body)
       (define name (curried-lambda () body)))
      ((define-curried name body)
       (define name body)))))