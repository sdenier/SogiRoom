
!SGLReservationTest methodsFor: 'as yet unclassified'!
testCreation

	| resa |
	resa := SGLReservation forStringDate: '2011-12-21' at: '15:30' for: '30'.
	self assert: '2011-12-21' equals: resa printDate.
	self assert: '15:30' equals: resa printTime.
	self assert: '30' equals: resa printDurationInMinutes.! !
