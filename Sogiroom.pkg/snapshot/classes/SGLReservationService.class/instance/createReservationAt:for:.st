
!SGLReservationService methodsFor: 'actions'!
createReservationAt: dateTime for: duration

	| newResa json |
	newResa := SGLReservation
					forDate: dateTime asDate
					at: dateTime asTime
					for:  duration.
	newResa conflicts ifNotEmptyDo: [ :conflicts |
		SGLConflict signal: #Overlap withResources: (conflicts collect: #signature) ].
	SGLRoom default addReservation: newResa.
	newResa timestamp: self nextTimestamp.
	^ newResa! !
