
!SGLReservation methodsFor: 'json-export'!
javascriptOn: aStream
	^ Dictionary new
		add: 'guid' -> self guid ;
		add: 'timestamp' -> self timestamp ;
		add: 'datetime' -> self startTime asString ;
		add: 'duration' -> self duration ;
		javascriptOn: aStream! !
