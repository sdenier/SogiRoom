
!SGLReservation methodsFor: 'testing'!
conflicts

	^ SGLRoom default reservations select: [ :resa | self guid ~= resa guid and: [ self overlaps: resa ]]! !
