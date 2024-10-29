(use-trait prediction-market-trait
  (begin
    (define-public (create-market (event-name (string-utf8 64)) (outcome-count uint))
      ...)
    (define-public (place-bet (market-id uint) (outcome uint) (bet-amount uint))
      ...)
    (define-public (resolve-market (market-id uint) (winning-outcome uint))
      ...)
    (define-public (withdraw (market-id uint) (outcome uint))
      ...)
  ))

(define-map markets
  { market-id: uint }
  { event-name: (string-utf8 64),
    outcome-count: uint,
    total-bets: uint,
    outcomes: (list 10 { name: (string-utf8 32), total-bets: uint, payout-rate: uint }),
    status: bool })

(define-map bets
  { market-id: uint, bettor: principal, outcome: uint }
  { bet-amount: uint, payout-amount: uint })

(define-public (create-market (event-name (string-utf8 64)) (outcome-count uint))
  (let ((market-id (+ (map-get? markets { }) 1)))
    (map-insert markets { market-id: market-id }
      { event-name: event-name,
        outcome-count: outcome-count,
        total-bets: 0,
        outcomes: (list-repeat outcome-count { name: "", total-bets: 0, payout-rate: 0 }),
        status: false })
    market-id))

(define-public (place-bet (market-id uint) (outcome uint) (bet-amount uint))
  (let ((market (map-get? markets { market-id: market-id })))
    (if (and market (< outcome (get outcome-count market)))
      (begin
        (map-insert bets { market-id: market-id, bettor: tx-sender, outcome: outcome }
          { bet-amount: bet-amount, payout-amount: 0 })
        (map-set markets { market-id: market-id }
          (let ((updated-market (get market)))
            (map-set (get outcomes updated-market) outcome
              (let ((outcome-data (get-list-item (get outcomes updated-market) outcome)))
                (! (+ (get total-bets updated-market) bet-amount)
                   (update total-bets updated-market))
                (! (+ (get total-bets outcome-data) bet-amount)
                   (update total-bets outcome-data)))))
            updated-market))
        true)
      false)))

(define-public (resolve-market (market-id uint) (winning-outcome uint))
  (let ((market (map-get? markets { market-id: market-id })))
    (if (and market (< winning-outcome (get outcome-count market)) (not (get status market)))
      (begin
        (map-set markets { market-id: market-id }
          (let ((updated-market (get market)))
            (! true (update status updated-market))
            updated-market))
        (let ((total-bets (get total-bets market))
              (winning-outcome-data (get-list-item (get outcomes market) winning-outcome))
              (payout-rate (/ (* 10000 (get total-bets winning-outcome-data)) total-bets)))
          (map-get-all bets { market-id: market-id }
            (lambda (bet)
              (let ((payout-amount (/ (* (get bet-amount bet) 10000) payout-rate)))
                (map-set bets (get bet)
                  (! payout-amount (update payout-amount bet)))))))
        true)
      false)))

