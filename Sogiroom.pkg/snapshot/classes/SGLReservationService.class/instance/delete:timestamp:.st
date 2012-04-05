
!SGLReservationService methodsFor: 'actions'!
delete: guid timestamp: timestamp

	| toDelete |
	toDelete := SGLRoom default
				findReservation: guid
				ifDeleted: [ :deleted | ^ deleted ].
	
	toDelete timestamp > timestamp ifTrue: [
		SGLConflict signal: 'Concurrent Edit' withResources: {toDelete signature} ].
	
	SGLRoom default deleteReservation: toDelete.
	toDelete timestamp: self nextTimestamp.
	^ toDelete! !
