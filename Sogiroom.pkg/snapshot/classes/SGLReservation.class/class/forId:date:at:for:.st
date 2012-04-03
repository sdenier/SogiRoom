
!SGLReservation class methodsFor: 'initialize-release'!
forId: id date: aDate at: aTime for: aDuration 
	^ self basicNew
			initializeWith: id ;
			date: aDate;
			time: aTime;
			duration: aDuration;
			yourself! !
