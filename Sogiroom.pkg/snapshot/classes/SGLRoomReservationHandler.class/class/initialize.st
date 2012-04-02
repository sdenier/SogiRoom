
!SGLRoomReservationHandler class methodsFor: 'class initialization'!
initialize
	WAAdmin register: self at: 'booking-api'.
	
	TsMutex := Mutex new.
	Timestamp := 0! !
