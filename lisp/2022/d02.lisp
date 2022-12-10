(in-package :advent/2022)

(defparameter *d2/input*
  (uiop:read-file-string (asdf:system-relative-pathname :advent "2022/d02.input")))

(defparameter *d2/test* "A Y
B X
C Z")

(defun d2/parse (input)
  (mapcar (lambda (x) (split "\\s" x))
          (split "\\n" input)))

(defun compute-rps-score (game)
  (+ (cond ((string= "X" (cadr game)) 1)
           ((string= "Y" (cadr game)) 2)
           ((string= "Z" (cadr game)) 3)
           (t (progn (break) 0)))
     (cond ((or (and (string= "A" (car game)) (string= "Y" (cadr game)))
                (and (string= "B" (car game)) (string= "Z" (cadr game)))
                (and (string= "C" (car game)) (string= "X" (cadr game)))) 6)
           ((or (and (string= "A" (car game)) (string= "X" (cadr game)))
                (and (string= "B" (car game)) (string= "Y" (cadr game)))
                (and (string= "C" (car game)) (string= "Z" (cadr game)))) 3)
           (t 0))))

(defun compute-rps-score-2 (game)
  (+ (cond ((string= "X" (cadr game)) 0)
           ((string= "Y" (cadr game)) 3)
           ((string= "Z" (cadr game)) 6)
           (t (progn (break) 0)))
     (cond ((or (and (string= "A" (car game)) (string= "X" (cadr game)))
                (and (string= "B" (car game)) (string= "Z" (cadr game)))
                (and (string= "C" (car game)) (string= "Y" (cadr game)))) 3)
           ((or (and (string= "A" (car game)) (string= "Z" (cadr game)))
                (and (string= "B" (car game)) (string= "Y" (cadr game)))
                (and (string= "C" (car game)) (string= "X" (cadr game)))) 2)
           (t 1))))

(defun d2/t1 ()
  (every #'identity
            (list (= 8 (compute-rps-score '("A" "Y")))
               (= 1 (compute-rps-score '("B" "X")))
               (= 6 (compute-rps-score '("C" "Z")))
               (= 15 (d2/p1 *d2/test*)))))

(defun d2/t2 ()
  (every #'identity
            (list (= 12 (d2/p2 *d2/test*)))))

(defun d2/p1 (input)
  (reduce '+ (mapcar 'compute-rps-score (d2/parse input))))

(defun d2/p2 (input)
  (reduce '+ (mapcar 'compute-rps-score-2 (d2/parse input))))

(defun d2/summary ()
  (format t "~%Day 2: Rock Paper Scissors")
  (format t "~%  Puzzle 1:")
  (print-result (d2/p1 *d2/input*))
  (format t "~%  Puzzle 2:")
  (print-result (d2/p2 *d2/input*)))
