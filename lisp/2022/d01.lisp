(in-package :advent/2022)

(defparameter *d1/input*
  (uiop:read-file-string
   (asdf:system-relative-pathname :advent "2022/d01.input") ))

(defparameter *d1/test* "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000")

(defun d1/parse (input)
  (mapcar #'(lambda (x) (mapcar #'parse-integer (split "\\n" x)))
          (split "\\n\\n" input)))

(defun compute-elf-calories (calorie-list)
  (reduce '+ calorie-list))

(defun compute-elves-calories (calorie-list-list)
  (mapcar 'compute-elf-calories calorie-list-list))

(defun d1/p1 (input)
  (reduce 'max (compute-elves-calories (d1/parse input))))

(defun d1/p2 (input)
  (reduce '+
          (subseq (sort (compute-elves-calories (d1/parse input)) '>)
                  0 3)))

(defun d1/t1 ()
  (every #'identity
         (list (= 6000 (compute-elf-calories '(1000 2000 3000)))
               (= 4000 (compute-elf-calories '(4000)))
               (= 24000 (d1/p1 *d1/test*)))))

(defun d1/t2 ()
  (every #'identity
         (list (= 45000 (d1/p2 *d1/test*)))))

(defun d1/summary ()
  (format t "~%Day 1: Calorie Counting")
  (format t "~%  Puzzle 1:")
  (print-result (d1/p1 *d1/input*))
  (format t "~%  Puzzle 2:")
  (print-result (d1/p2 *d1/input*)))
