
!SGLReservationService class methodsFor: 'class initialization'!
initialize
	Default := self new.
	TsMutex := Mutex new.
	Timestamp := 0! !
