;; title: Olacoin (OLA) - A Stacks Fungible Token
;; version: 1.0.0
;; summary: Olacoin is a fungible token built on Stacks blockchain implementing SIP-010 standard
;; description: A community-driven digital currency with governance features and sustainable tokenomics

;; SIP-010 compliant fungible token implementation
;; Note: For production deployment, use the official SIP-010 trait reference

;; Define the fungible token
(define-fungible-token olacoin)

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_OWNER_ONLY (err u100))
(define-constant ERR_NOT_TOKEN_OWNER (err u101))
(define-constant ERR_INSUFFICIENT_BALANCE (err u102))
(define-constant ERR_INVALID_AMOUNT (err u103))
(define-constant ERR_MINT_FAILED (err u104))
(define-constant ERR_BURN_FAILED (err u105))
(define-constant TOKEN_MAX_SUPPLY u1000000000000000) ;; 10 billion tokens with 6 decimals
(define-constant TOKEN_NAME "Olacoin")
(define-constant TOKEN_SYMBOL "OLA")
(define-constant TOKEN_DECIMALS u6)

;; Data variables
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var contract-owner principal CONTRACT_OWNER)
(define-data-var total-supply uint u0)
(define-data-var mint-enabled bool true)

;; Data maps
(define-map approved-contracts principal bool)

;; SIP-010 Implementation

;; Transfer function
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) ERR_NOT_TOKEN_OWNER)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-transfer? olacoin amount sender recipient)
  )
)

;; Get token name
(define-read-only (get-name)
  (ok TOKEN_NAME)
)

;; Get token symbol
(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

;; Get token decimals
(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

;; Get token balance
(define-read-only (get-balance (who principal))
  (ok (ft-get-balance olacoin who))
)

;; Get total supply
(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

;; Get token URI
(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Administrative Functions

;; Mint tokens (only owner)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_OWNER_ONLY)
    (asserts! (var-get mint-enabled) ERR_MINT_FAILED)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (<= (+ (var-get total-supply) amount) TOKEN_MAX_SUPPLY) ERR_MINT_FAILED)
    (try! (ft-mint? olacoin amount recipient))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok amount)
  )
)

;; Burn tokens
(define-public (burn (amount uint) (owner principal))
  (begin
    (asserts! (or (is-eq tx-sender owner) (is-eq tx-sender (var-get contract-owner))) ERR_NOT_TOKEN_OWNER)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (>= (ft-get-balance olacoin owner) amount) ERR_INSUFFICIENT_BALANCE)
    (try! (ft-burn? olacoin amount owner))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok amount)
  )
)

;; Set token URI (only owner)
(define-public (set-token-uri (value (optional (string-utf8 256))))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_OWNER_ONLY)
    (ok (var-set token-uri value))
  )
)

;; Transfer ownership (only current owner)
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_OWNER_ONLY)
    (var-set contract-owner new-owner)
    (ok true)
  )
)

;; Toggle minting (only owner)
(define-public (toggle-mint-enabled)
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_OWNER_ONLY)
    (var-set mint-enabled (not (var-get mint-enabled)))
    (ok (var-get mint-enabled))
  )
)

;; Approve contract for transfers
(define-public (set-contract-approved (contract principal) (approved bool))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_OWNER_ONLY)
    (map-set approved-contracts contract approved)
    (ok approved)
  )
)

;; Read-only functions

;; Get contract owner
(define-read-only (get-contract-owner)
  (var-get contract-owner)
)

;; Check if minting is enabled
(define-read-only (is-mint-enabled)
  (var-get mint-enabled)
)

;; Check if contract is approved
(define-read-only (is-contract-approved (contract principal))
  (default-to false (map-get? approved-contracts contract))
)

;; Get max supply
(define-read-only (get-max-supply)
  TOKEN_MAX_SUPPLY
)

;; Calculate percentage of total supply
(define-read-only (get-supply-percentage (amount uint))
  (if (> (var-get total-supply) u0)
    (/ (* amount u10000) (var-get total-supply)) ;; Return basis points (1/10000)
    u0
  )
)

;; Initialize contract with initial supply to deployer
(begin
  (try! (ft-mint? olacoin u1000000000000 CONTRACT_OWNER)) ;; Mint 1M tokens initially
  (var-set total-supply u1000000000000)
  (var-set token-uri (some u"https://olacoin.io/metadata.json"))
)
