
!SGLRoomReservationHandler methodsFor: 'error handlers'!
handleConflict: conflict
	| doc |
	doc := Dictionary new
		add: #conflict -> conflict type;
		add: #resources -> conflict resources;
		yourself.
	^ self requestContext
		respond: [ :response | 
			response document: doc asJavascript mimeType: (WAMimeType fromString: 'text/json').
			response status: WAResponse statusConflict ]! !
