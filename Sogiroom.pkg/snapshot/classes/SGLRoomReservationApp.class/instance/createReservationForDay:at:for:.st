
!SGLRoomReservationApp methodsFor: 'as yet unclassified'!
createReservationForDay: date at: time for: duration
	
	room addReservation: (SGLReservation forStringDate: date at: time for: duration)! !
