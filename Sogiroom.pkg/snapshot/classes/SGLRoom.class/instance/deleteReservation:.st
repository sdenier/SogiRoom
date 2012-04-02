
!SGLRoom methodsFor: 'resources'!
deleteReservation: id

	^ reservations remove: (self findReservation: id)! !
