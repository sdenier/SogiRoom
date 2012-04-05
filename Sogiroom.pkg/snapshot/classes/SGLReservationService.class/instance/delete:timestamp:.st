
!SGLReservationService methodsFor: 'actions'!
delete: guid timestamp: timestamp

	| toDelete |
	toDelete := SGLRoom default
				findReservation: guid
				ifDeleted: [ :deleted | ^ deleted ].
	
	SGLRoom default deleteReservation: toDelete.
	toDelete timestamp: self nextTimestamp.
	^ toDelete! !
