
!SGLReservation methodsFor: 'printing'!
printTime
	^ String streamContents: [:str|
		time print24: true showSeconds: false on: str ]! !
