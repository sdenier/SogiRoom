
!SGLRoomReservationHandler methodsFor: 'http requests'!
delete: id
	<delete>
	<produces: 'text/json'>
	<consumes: '*/*'>

	SGLRoom default deleteReservation: id asInteger. 
	^ 'Deleted'! !
