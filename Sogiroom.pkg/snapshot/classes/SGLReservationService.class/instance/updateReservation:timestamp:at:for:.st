
!SGLReservationService methodsFor: 'actions'!
updateReservation: guid timestamp: ts at: dateTime for: duration

	| resa newResa |
	resa := SGLRoom default findReservation: guid.
	resa timestamp > ts ifTrue: [
		SGLConflict signal: 'Concurrent Edit' withResources: {resa signature} ].

	newResa := SGLReservation forId: guid date: dateTime asDate at: dateTime asTime for: duration.
	newResa conflicts ifNotEmptyDo: [ :conflicts |
		SGLConflict signal: #Overlap withResources: (conflicts collect: #signature) ].

	resa updateWith: newResa ; timestamp: self nextTimestamp.
	^ resa! !
