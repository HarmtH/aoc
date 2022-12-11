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

(defmethod monkey-push ((self monkey) item)
  (setf (items self) (cons item (items self))))

(defmethod run ((self monkey) simplify)
  (let ((olditems (items self)))
    (setf (items self) ())
    (incf (mutations self) (length olditems))
    (mapcar (compose (toss self) simplify (mutate self))
            olditems)))

(defun parse-mutate (string)
  (let ((operator (if (char= (char string 23) #\+) #'+ #'*))
        (operand (parse-integer (subseq string 25) :junk-allowed t)))
    (lambda (x) (funcall operator x (or operand x)))))

(defun parse-toss (monkeyinfo)
  (lambda (item) (cons (if (= (mod item (parse-integer (subseq (nth 3 monkeyinfo) 21))) 0)
                           (parse-integer (subseq (nth 4 monkeyinfo) 29))
                           (parse-integer (subseq (nth 5 monkeyinfo) 30)))
                       item)))

(defun parse-items (string)
  (mapcar #'parse-integer
          (split ", " (subseq string 18))))

(defun d11/parse (input)
  (loop for monkey in (split "\\n\\n" input)
        for monkeyinfo = (split "\\n" monkey)
        collect (make-instance 'monkey
                               :items (parse-items (nth 1 monkeyinfo))
                               :mutate (parse-mutate (nth 2 monkeyinfo))
                               :divisor (parse-integer (subseq (nth 3 monkeyinfo) 21))
                               :toss (parse-toss monkeyinfo))))

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
