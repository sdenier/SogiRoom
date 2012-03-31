
!SGLReservation methodsFor: 'actions'!
save

	self date: self date asDate.
	self time: self time asTime.
	self duration: self duration asInteger minutes! !
