
!SGLRoom methodsFor: 'resources'!
deleteReservation: aReservation

	reservations remove: aReservation.
	tombstones add: aReservation.
	^ aReservation! !
