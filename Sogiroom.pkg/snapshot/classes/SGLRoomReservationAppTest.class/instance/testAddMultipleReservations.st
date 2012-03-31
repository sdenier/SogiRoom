
!SGLRoomReservationAppTest methodsFor: 'as yet unclassified'!
testAddMultipleReservations
	self createReservationForDay: '2011-12-21' at: '15:30:00' for: '30'.
	self assert: (self lastResponse containsString: '2011-12-21@15:30 - 30 minutes').
	self createReservationForDay: '2012-11-01' at: '00:45:00' for: '23'.
	self assert: (self lastResponse containsString: '2012-11-01@00:45 - 23 minutes').
! !
