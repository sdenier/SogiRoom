
!SGLRoomReservationEditor methodsFor: 'as yet unclassified'!
save

	|newRes|
	newRes := reservation.
	reservation := SGLReservation new.
	newRes save.
	self answer: newRes! !
