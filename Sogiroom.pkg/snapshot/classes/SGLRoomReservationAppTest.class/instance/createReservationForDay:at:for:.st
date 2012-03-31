
!SGLRoomReservationAppTest methodsFor: 'as yet unclassified'!
createReservationForDay: date at: time for: duration

	| resp |
	resp := self lastResponse.
	(resp entityWithId: 'date') value: date.
	(resp entityWithId: 'time') value: time.
	(resp entityWithId: 'duration') value: duration.
	(resp buttonWithValue: 'Book') click.! !
