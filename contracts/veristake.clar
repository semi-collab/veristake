;; VeriStake Protocol: Decentralized Event Verification & Reward System
;;
;; A revolutionary blockchain-based platform that transforms event management
;; through cryptographic proof-of-presence and automated reward distribution.
;; Built on Stacks Layer 2 for Bitcoin-secured transparency and scalability.
;;
;; Core Features:
;; - Immutable Attendance Records: Cryptographically secured check-in/out system
;; - Smart Reward Distribution: Automated STX payouts based on participation metrics
;; - Decentralized Verification: Community-driven validation with trusted authorities
;; - Multi-Tier Incentives: Base rewards + performance bonuses for engagement
;; - Enterprise Integration: Scalable infrastructure for conferences, workshops, and corporate events
;;
;; Perfect for:
;; - Conference organizers seeking transparent attendance tracking
;; - Educational institutions requiring verifiable participation
;; - Corporate training programs with completion incentives
;; - DAO governance with participation-based rewards
;; - Web3 events needing trustless verification systems
;;
;; Security Model:
;; Built with enterprise-grade security, multi-signature treasury management,
;; and comprehensive audit trails anchored to the Bitcoin blockchain.

;; ERROR CODES & CONSTANTS

;; Core Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-CLAIMED (err u101))
(define-constant ERR-EVENT-NOT-ENDED (err u102))
(define-constant ERR-EVENT-ENDED (err u103))
(define-constant ERR-NO-REWARD (err u104))
(define-constant ERR-EVENT-NOT-FOUND (err u105))
(define-constant ERR-INSUFFICIENT-FUNDS (err u106))
(define-constant ERR-INVALID-DURATION (err u107))
(define-constant ERR-ALREADY-REGISTERED (err u108))
(define-constant ERR-INVALID-START-HEIGHT (err u110))
(define-constant ERR-INVALID-REWARD (err u111))
(define-constant ERR-INVALID-MIN-ATTENDANCE (err u112))
(define-constant ERR-EVENT-NOT-ACTIVE (err u120))
(define-constant ERR-NO-CHECKIN-RECORD (err u121))
(define-constant ERR-ALREADY-VERIFIED (err u122))
(define-constant ERR-INVALID-ATTENDEE (err u123))

;; Admin Error Codes
(define-constant ERR-INVALID-ADDRESS (err u1002))
(define-constant ERR-ALREADY-VERIFIER (err u1003))
(define-constant ERR-NOT-VERIFIER (err u1004))
(define-constant ERR-INVALID-AMOUNT (err u1005))
(define-constant ERR-EVENT-ALREADY-INACTIVE (err u1006))
(define-constant ERR-TRANSFER-FAILED (err u1007))

;; String Validation Error Codes
(define-constant ERR-INVALID-NAME (err u2000))
(define-constant ERR-INVALID-DESCRIPTION (err u2001))
(define-constant ERR-CONTAINS-INVALID-CHARS (err u2002))

;; Validation Constants
(define-constant MIN-NAME-LENGTH u3)
(define-constant MAX-NAME-LENGTH u50)
(define-constant MIN-DESC-LENGTH u10)
(define-constant MAX-DESC-LENGTH u200)
(define-constant MAX-DURATION u52560) ;; ~1 year in blocks (10-min blocks)
(define-constant MIN-DURATION u144) ;; ~1 day in blocks
(define-constant MAX-REWARD u1000000000000) ;; 1000 STX maximum reward
(define-constant BURN-ADDRESS 'SP000000000000000000002Q6VF78)

;; DATA VARIABLES

(define-data-var contract-owner principal tx-sender)
(define-data-var event-counter uint u0)
(define-data-var treasury-balance uint u0)

;; DATA MAPS

;; Event Registry
(define-map events
  uint
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    start-height: uint,
    end-height: uint,
    base-reward: uint,
    bonus-reward: uint,
    min-attendance-duration: uint,
    organizer: principal,
    is-active: bool,
  }
)

;; Attendance Tracking System
(define-map event-attendance
  {
    event-id: uint,
    attendee: principal,
  }
  {
    check-in-height: uint,
    check-out-height: uint,
    duration: uint,
    verified: bool,
  }
)