
!SGLReservation methodsFor: 'json-export'!
signature

	^ Dictionary new
		add: 'guid' -> self guid ;
		add: 'timestamp' -> self timestamp ;
		yourself! !
