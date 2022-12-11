;;;; advent.asd

(asdf:defsystem #:advent
  :serial t
  :description "Advent of Code"
  :author "Harm te Hennepe <aoc@h86.nl>"
  :license "HTH"
  :depends-on (#:cl-ppcre #:alexandria #:serapeum)
  :components ((:file "package")
               (:file "utils")
               (:module "2022"
                        :components ((:file "package")
                                     (:file "d01")
                                     (:file "d02")))))
