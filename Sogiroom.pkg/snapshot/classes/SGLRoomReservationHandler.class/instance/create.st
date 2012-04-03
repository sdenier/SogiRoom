
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
	do: [ :conflict | | doc |
		doc := Dictionary new
				add: #conflict -> conflict type ;
				add: #resources -> conflict resources ;
				yourself.
		self requestContext respond: [ :response |
			response 	document: doc asJavascript
						mimeType: (WAMimeType fromString: 'text/json').
			response status: WAResponse statusConflict. ]]! !
