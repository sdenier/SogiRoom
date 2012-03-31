
!SGLRoomReservationAppTest methodsFor: 'as yet unclassified'!
testAddOneReservation

	| date duration time |
	date := '2011-12-21'.
	time := '15:30:00'.
	duration := '30'.

	self createReservationForDay: date at: time for: duration.
	self assert: (self lastResponse containsString: date).
	self assert: (self lastResponse containsString: '15:30').
	self assert: (self lastResponse containsString: duration).! !
