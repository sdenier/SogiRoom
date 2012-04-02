
!SGLRoomReservationHandler methodsFor: 'http requests'!
delete: id timestamp: timestamp
	<delete>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| deleted |
	deleted := SGLRoom default deleteReservation: id asInteger.
	deleted timestamp: self nextTimestamp.
	^ (deleted signature add: #state -> #deleted ; yourself) asJavascript! !