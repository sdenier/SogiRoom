
!SGLReservation methodsFor: 'comparing'!
= anObject

	^ self species = anObject species and: [
		self date = anObject date & self time = anObject time & self duration = anObject duration ]! !
