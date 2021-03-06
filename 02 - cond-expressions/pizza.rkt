;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pizza) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define s 6)
(define m 8)
(define l 9.50)
(define be 18)
(define s-top 1)
(define p-top 1.50)
(define h-price 0.50)
(define sl 8)

;; (pizza-adjust size nstopp nptopp code) produces the final price
;;   of a pizza based on code, a function is applied to each
;;   coupon deal that a customer may have
;; pizza-adjust: Num Nat Nat Sym -> Sym
;; Examples:
(check-expect (pizza-adjust 8 3 2 'half-off) 7)
(check-expect (pizza-adjust 6 3 4 'monkey) 15)

(define (pizza-adjust size nstopp nptopp code)
  (cond
    [(symbol=? code 'half-off)
     (* (+ size (* nstopp s-top)(* nptopp p-top)) h-price)]
    [(symbol=? code 'big-eater) be]
    [(symbol=? code 'supersize)
     (+ s (* nstopp s-top)(* nptopp p-top))]
    [(symbol=? code 'solo)
     (cond
       [(and (= size s)(= nstopp 0)(= nptopp 2))
        (+ size sl)]
       [else
        (+ size (* nstopp s-top)(* nptopp p-top))])]
    [(symbol=? code 'none)(+ size (* nstopp s-top)(* nptopp p-top))]
    [else (+ size (* nstopp s-top)(* nptopp p-top))]))

;; Tests:
(check-expect (pizza-adjust 6 1 1 'none) 8.5)
(check-expect (pizza-adjust 8 2 4 'popcorn) 16)
(check-expect (pizza-adjust 9.50 2 5 'half-off) 9.5)
(check-expect (pizza-adjust 8 2 3 'big-eater) 18)
(check-expect (pizza-adjust 6 0 2 'solo) 14)
(check-expect (pizza-adjust 8 0 0 'none) 8)

;; (pizza-price size nstopp nptopp code) produces the final price of
;;   a pizza based on the {size, nstopp, nptopp, code}, each specific
;;   code corresponds to a coupon deal for the final price of the
;;   pizza
;; pizza-price: Sym Nat Nat Sym -> Num
;; requires: size must be one of: {'small, 'medium, 'large}
;;           nstopp, nptopp must be a natural number
;;           code must be one of: {'half-off, 'supersize, 'big-eater,
;;                                 'none, 'solo}
;; Examples:
(check-expect (pizza-price 'medium 3 2 'half-off) 7)
(check-expect (pizza-price 'small 3 4 'monkey) 15)             

(define (pizza-price size nstopp nptopp code)
  (pizza-adjust
   (cond
     [(symbol=? size 'small) s]
     [(symbol=? size 'medium) m]
     [(symbol=? size 'large) l]) 
   nstopp nptopp code))

;; Tests:
(check-expect (pizza-price 'small 1 1 'none) 8.5)
(check-expect (pizza-price 'medium 2 4 'popcorn) 16)
(check-expect (pizza-price 'large 2 5 'half-off) 9.5)
(check-expect (pizza-price 'medium 2 3 'big-eater) 18)
(check-expect (pizza-price 'small 0 2 'solo) 14)
(check-expect (pizza-price 'medium 0 0 'none) 8)