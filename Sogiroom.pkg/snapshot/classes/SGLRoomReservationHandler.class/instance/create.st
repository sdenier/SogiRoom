
!SGLRoomReservationHandler methodsFor: 'http requests'!
create
	<post>
	<produces: 'text/json'>
	<consumes: '*/*'>
	| json dateTime duration |
	json := self parseJsonBody.
	dateTime := (DateAndTime fromString: (json at: 'datetime')) withoutOffset asLocal.
	duration := (json at: 'duration') milliSeconds.

	[ | newResa |
		newResa := SGLReservationService default createReservationAt: dateTime for: duration.
		^ newResa signature asJavascript ]

	on: SGLConflict
	do: [ :conflict | self handleConflict: conflict ]! !
