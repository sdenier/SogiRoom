
!SGLReservation methodsFor: 'comparing'!
hash

	^ (self date hash bitXor: self time hash) bitXor: self duration hash! !
