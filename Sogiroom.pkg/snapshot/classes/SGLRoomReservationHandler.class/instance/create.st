
!SGLRoomReservationHandler methodsFor: 'http requests'!
create
	<post>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| json newResa dateTime |
	json := self parseJsonBody.
	dateTime := (DateAndTime fromString: (json at: 'datetime')) withoutOffset asLocal.
	newResa := SGLReservation
					forDate: dateTime asDate
					at: dateTime asTime
					for: (json at: 'duration') milliSeconds.
	newResa conflicts ifNotEmptyDo: [ :conflicts | | doc |
		doc := Dictionary newFromPairs: #(conflict Overlap).
		doc add: #resources -> (conflicts collect: #signature).
		self requestContext respond: [ :response |
			response document: doc asJavascript mimeType: (WAMimeType fromString: 'text/json').
			response status: WAResponse statusConflict. ]
		].
	SGLRoom default addReservation: newResa.
	newResa timestamp: self nextTimestamp.
	^ newResa signature asJavascript ! !
