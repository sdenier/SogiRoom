
!SGLRoomReservationHandler methodsFor: 'http requests'!
put_update: id
	<put>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| json dateTime duration resa timestamp |
	json := self parseJsonBody.
	dateTime := (DateAndTime fromString: (json at: 'datetime')) withoutOffset asLocal.
	duration := (json at: 'duration') milliSeconds.
	timestamp := (json at: 'timestamp') asInteger.

	[	resa := SGLReservationService default updateReservation: id asInteger
												timestamp: timestamp
												at: dateTime
												for: duration.
		^ resa signature asJavascript ]
	
	on: SGLConflict
	do: [ :conflict | self handleConflict: conflict ]! !
