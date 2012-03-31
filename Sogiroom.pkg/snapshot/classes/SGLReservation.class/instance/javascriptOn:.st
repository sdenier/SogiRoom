
!SGLReservation methodsFor: 'json-export'!
javascriptOn: aStream
	^ Dictionary new
		add: 'guid' -> self guid ;
		add: 'datetime' -> self dateAndTime asString ;
		add: 'duration' -> self duration ;
		javascriptOn: aStream! !
