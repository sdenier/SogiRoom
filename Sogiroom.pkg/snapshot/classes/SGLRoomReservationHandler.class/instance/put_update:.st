
!SGLRoomReservationHandler methodsFor: 'http requests'!
put_update: id
	<put>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| json dateTime duration resa |
	json := self parseJsonBody.
	dateTime := (DateAndTime fromString: (json at: 'datetime')) withoutOffset asLocal.
	duration := (json at: 'duration') milliSeconds.

	[	resa := SGLReservationService default updateReservation: id asInteger at: dateTime for: duration.
		^ resa signature asJavascript ]
	
	on: SGLConflict
	do: [ :conflict | self handleConflict: conflict ]! !
