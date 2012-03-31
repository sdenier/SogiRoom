
!SGLRoomReservationJS class methodsFor: 'class initialization'!
initialize

	| application |
	application := WAAdmin register: self asApplicationAt: 'booking'.
	application
		addLibrary: JQDeploymentLibrary! !
