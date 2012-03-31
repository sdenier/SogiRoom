
!SGLRoomReservationHandler methodsFor: 'http requests'!
list
	<get>
	<produces: 'text/json'>

	^ (Array streamContents: [ :str | |dict|
		SGLRoom default reservations do: [ :resa |
			str nextPut: resa ]
		]) asJavascript ! !
