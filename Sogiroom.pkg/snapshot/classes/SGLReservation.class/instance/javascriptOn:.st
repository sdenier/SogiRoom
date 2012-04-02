
!SGLReservation methodsFor: 'json-export'!
javascriptOn: aStream
	^ Dictionary new
		add: 'guid' -> self guid ;
		add: 'timestamp' -> self timestamp ;
		add: 'datetime' -> self dateAndTime asString ;
		add: 'duration' -> self duration ;
		javascriptOn: aStream! !
