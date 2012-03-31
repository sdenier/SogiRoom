
!SGLReservationTest methodsFor: 'as yet unclassified'!
testPrint

	| resa |
	resa := SGLReservation forStringDate: '2011-12-21' at: '15:30' for: '30'.
	self assert: '2011-12-21@15:30 - 30 minutes' equals: resa printString.
! !
