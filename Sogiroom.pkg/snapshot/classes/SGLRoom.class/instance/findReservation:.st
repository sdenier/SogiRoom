
!SGLRoom methodsFor: 'resources'!
findReservation: id

	^ reservations detect: [ :resa | resa guid = id ]! !
