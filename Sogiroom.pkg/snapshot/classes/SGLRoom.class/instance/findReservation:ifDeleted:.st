
!SGLRoom methodsFor: 'resources'!
findReservation: id ifDeleted: aBlock

	^ reservations
		detect: [ :resa | resa guid = id ]
		ifNone: [ |deleted|
				  deleted := tombstones detect: [ :resa | resa guid = id ].
				  aBlock value: deleted ]! !
