
!SGLRoomReservationHandler methodsFor: 'http requests'!
get: id
	<get>
	<produces: 'text/json'>

	| guid |
	guid := id asInteger.
	^ (SGLRoom default findReservation: guid) asJavascript ! !
