
!SGLRoomReservationHandler methodsFor: 'http requests'!
delete: id timestamp: timestamp
	<delete>
	<produces: 'text/json'>
	<consumes: '*/*'>

	| deleted |
	deleted := SGLReservationService default delete: id asInteger timestamp: timestamp asInteger.
	^ deleted deletedSignature asJavascript! !
