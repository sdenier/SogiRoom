
!SGLRoomReservationHandler methodsFor: 'request helpers'!
parseJsonBody
	^ JSJsonParser parse: self requestContext request rawBody! !
