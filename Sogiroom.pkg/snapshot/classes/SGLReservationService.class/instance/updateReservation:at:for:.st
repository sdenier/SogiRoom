
!SGLReservationService methodsFor: 'actions'!
updateReservation: guid at: dateTime for: duration

	| resa |
	resa := SGLReservation forId: guid date: dateTime asDate at: dateTime asTime for: duration.

	resa conflicts ifNotEmptyDo: [ :conflicts |
		SGLConflict signal: #Overlap withResources: (conflicts collect: #signature) ].

	resa timestamp: self nextTimestamp.
	resa := (SGLRoom default findReservation: guid) updateWith: resa.
	^ resa! !
