
!SGLRoomReservationHandler methodsFor: 'http requests'!
create
	<post>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| json newResa dateTime |
	json := self parseJsonBody.
	dateTime := (DateAndTime fromString: (json at: 'datetime')) withoutOffset asLocal.
	newResa := SGLRoom default addReservation:
		(SGLReservation forDate: dateTime asDate at: dateTime asTime for: (json at: 'duration') milliSeconds).
	newResa timestamp: self nextTimestamp.
	^ newResa signature asJavascript ! !
