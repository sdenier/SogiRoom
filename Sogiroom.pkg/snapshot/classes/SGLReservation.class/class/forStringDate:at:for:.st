
!SGLReservation class methodsFor: 'initialize-release'!
forStringDate: aDateString at: aTimeString for: aDurationString 
	^ self basicNew
			initializeWith: self nextId ;
			date: aDateString;
			time: aTimeString;
			duration: aDurationString;
			save;
			yourself! !
