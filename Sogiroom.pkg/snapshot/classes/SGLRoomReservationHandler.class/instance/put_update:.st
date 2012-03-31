
!SGLRoomReservationHandler methodsFor: 'http requests'!
put_update: id
	<put>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| json resa dateTime |
	json := self parseJsonBody.
	resa := SGLRoom default findReservation: id asInteger.
	dateTime := (DateAndTime fromString: (json at: 'datetime')) withoutOffset asLocal.
	resa date: dateTime asDate ;
		  time: dateTime asTime ;
		  duration: (json at: 'duration') milliSeconds.
	^ 'Updated'! !
