
!SGLReservation methodsFor: 'printing'!
printOn: stream

	stream nextPutAll: self printDate;
			nextPut: $@;
			nextPutAll: self printTime;
			nextPutAll: ' - ';
			nextPutAll: self printDurationInMinutes;
			nextPutAll: ' minutes'! !
