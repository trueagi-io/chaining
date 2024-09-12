;; Import modules
!(register-module! ../../../chaining)
!(import! &self chaining:dtl:utils)

;; Test utility functions
! "=== Test Utility Functions ==="

;; Test add-atom-nodup
!(bind! &space-test (new-space))
!(add-atom-nodup &space-test A)
!(add-atom-nodup &space-test A)
!(assertEqualToResult
  (get-atoms &space-test)
  (A))

;; Test add-atoms-nodup
!(add-atoms-nodup &space-test (A B C A))
!(assertEqualToResult
  (get-atoms &space-test)
  (A B C))
