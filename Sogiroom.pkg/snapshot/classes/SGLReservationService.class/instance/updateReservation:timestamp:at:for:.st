
!SGLReservationService methodsFor: 'actions'!
updateReservation: guid timestamp: ts at: dateTime for: duration

	| resa newResa |
	resa := SGLRoom default
				findReservation: guid
				ifDeleted: [:deleted | SGLConflict signal: 'Deleted' withResources: { deleted signature }].
	newResa := SGLReservation forId: guid date: dateTime asDate at: dateTime asTime for: duration.

	resa = newResa ifTrue: [ ^ resa ]. "semantic equivalence, do nothing and return last object, even if there was a concurrent edit"

	resa timestamp > ts ifTrue: [
		SGLConflict signal: 'Concurrent Edit' withResources: {resa signature} ].

	newResa conflicts ifNotEmptyDo: [ :conflicts |
		SGLConflict signal: #Overlap withResources: (conflicts collect: #signature) ].

	resa updateWith: newResa ; timestamp: self nextTimestamp.
	^ resa! !
