
!SGLReservation methodsFor: 'testing'!
conflicts

	^ SGLRoom default reservations select: [ :resa | self ~= resa and: [ self overlaps: resa ]]! !
