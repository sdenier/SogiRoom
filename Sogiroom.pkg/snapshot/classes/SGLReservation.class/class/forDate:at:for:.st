
!SGLReservation class methodsFor: 'initialize-release'!
forDate: aDate at: aTime for: aDuration 
	^ self basicNew
			initializeWith: self nextId ;
			date: aDate;
			time: aTime;
			duration: aDuration;
			yourself! !
