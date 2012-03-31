
!SGLTRoomReservationTest methodsFor: 'as yet unclassified'!
testCreateOneReservation

	| date duration time |
	date := '2011-12-21'.
	time := '15:30:00'.
	duration := '30'.

	self createReservationForDay: date at: time for: duration.
	self assert: date equals: self lastReservation printDate.
	self assert: '15:30' equals: self lastReservation printTime.
	self assert: duration equals: self lastReservation printDurationInMinutes.! !
