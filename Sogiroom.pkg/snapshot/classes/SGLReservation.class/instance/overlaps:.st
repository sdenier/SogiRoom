
!SGLReservation methodsFor: 'testing'!
overlaps: aReservation

	^ self startTime < aReservation endTime and: [ aReservation startTime < self endTime ]! !
