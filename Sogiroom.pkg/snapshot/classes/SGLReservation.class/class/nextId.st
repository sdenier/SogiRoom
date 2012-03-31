
!SGLReservation class methodsFor: 'id generation'!
nextId

	^ IdMutex critical: [ NextId := NextId + 1 ]! !
