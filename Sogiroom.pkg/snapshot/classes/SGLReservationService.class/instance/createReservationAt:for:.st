
!SGLReservationService methodsFor: 'actions'!
createReservationAt: dateTime for: duration

	| newResa |
	newResa := SGLReservation forDate: dateTime asDate at: dateTime asTime for:  duration.

	newResa conflicts ifNotEmptyDo: [ :conflicts |
		SGLConflict signal: #Overlap withResources: (conflicts collect: #signature) ].

	newResa timestamp: self nextTimestamp.
	SGLRoom default addReservation: newResa.
	^ newResa! !
