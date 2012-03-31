
!SGLRoomReservationApp methodsFor: 'accessing'!
initialize

	super initialize.
	room := SGLRoom default.
	editor := SGLRoomReservationEditor new.
	editor onAnswer: [:answer | room addReservation: answer ].! !
