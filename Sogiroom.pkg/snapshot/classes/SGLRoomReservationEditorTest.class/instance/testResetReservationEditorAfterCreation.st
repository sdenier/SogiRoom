
!SGLRoomReservationEditorTest methodsFor: 'as yet unclassified'!
testResetReservationEditorAfterCreation
	
	| resp |
	self createReservationForDay: '2011-12-21' at: '15:30:00' for: '30'.
	resp := self lastResponse.
	self assert: nil equals: (resp entityWithId: 'date') value.
	self assert: nil equals: (resp entityWithId: 'time') value.
	self assert: nil equals: (resp entityWithId: 'duration') value.! !
