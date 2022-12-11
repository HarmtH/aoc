(defpackage #:advent-of-code-2022
  (:nicknames :advent/2022)
  (:use #:cl #:alexandria #:serapeum #:advent)
  (:import-from :ppcre :split)
  (:export #:d1/summary
           #:d1/p1
           #:d1/p2))
