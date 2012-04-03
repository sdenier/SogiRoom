
!SGLReservationService class methodsFor: 'timestamp'!
nextTimestamp

	^ TsMutex critical: [ Timestamp := Timestamp + 1 ]! !
