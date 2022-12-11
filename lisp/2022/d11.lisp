(in-package :advent/2022)

(defparameter *d11/input*
  (uiop:read-file-string (asdf:system-relative-pathname :advent "2022/d11.input")))

(defparameter *d11/test* "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1")

(defclass monkey ()
  ((items
    :initarg :items
    :accessor items)
   (mutate
    :initarg :mutate
    :reader mutate)
   (toss
    :initarg :toss
    :reader toss)
   (divisor
    :initarg :divisor
    :reader divisor)
   (mutations
    :initform 0
    :accessor mutations)))

(defparameter *monkey-pattern*
"Monkey .+:
  Starting items: (.+)
  Operation: new = old (.) (.+)
  Test: divisible by (.+)
    If true: throw to monkey (.+)
    If false: throw to monkey (.+)
")

(defmethod monkey-push ((self monkey) item)
  (setf (items self) (cons item (items self))))

(defmethod run ((self monkey) simplify)
  (let ((olditems (items self)))
    (setf (items self) ())
    (incf (mutations self) (length olditems))
    (mapcar (compose (toss self) simplify (mutate self))
            olditems)))

(defun parse-mutate (stroperator stroperand)
  (let ((operator (if (string= stroperator "+") #'+ #'*))
        (operand (parse-integer stroperand :junk-allowed t)))
    (lambda (x) (funcall operator x (or operand x)))))

(defun parse-toss (divisor targett targetf)
  (lambda (item) (cons (if (= (mod item (parse-integer divisor)) 0)
                           (parse-integer targett)
                           (parse-integer targetf))
                       item)))

(defun d11/parse (input &aux (monkeys nil))
  (cl-ppcre:do-register-groups (items operator operand divisor targett targetf)
      (*monkey-pattern* input)
    (push (make-instance 'monkey
                         :items (mapcar #'parse-integer (split ", " items))
                         :mutate (parse-mutate operator operand)
                         :divisor (parse-integer divisor)
                         :toss (parse-toss divisor targett targetf))
          monkeys))
  (reverse monkeys))

(defun d11/t1 ()
  (every #'identity
         (list (= 10605 (d11/p1 *d11/test*)))))

(defun d11/t2 ()
  (every #'identity
         (list (= 2713310158 (d11/p2 *d11/test*)))))

(defun compute-monkey-business (monkeys times simplify)
  (dotimes (n times)
    (loop for monkey in monkeys
          do (loop for tossed in (run monkey simplify)
                   do (monkey-push (nth (car tossed) monkeys) (cdr tossed)))))
  (reduce #'* (subseq (sort (mapcar #'mutations monkeys) #'>) 0 2)))

(defun d11/p1 (input)
  (let ((monkeys (d11/parse input))
        (simplify (lambda (item) (floor item 3))))
    (compute-monkey-business monkeys 20 simplify)))

(defun d11/p2 (input)
  (let* ((monkeys (d11/parse input))
        (simplify (lambda (item) (mod item (reduce #'* (mapcar #'divisor monkeys))))))
    (compute-monkey-business monkeys 10000 simplify)))

(defun d11/summary ()
  (format t "~%Day 11: Monkey in the Middle")
  (format t "~%  Puzzle 1:")
  (print-result (d11/p1 *d11/input*))
  (format t "~%  Puzzle 2:")
  (print-result (d11/p2 *d11/input*)))
