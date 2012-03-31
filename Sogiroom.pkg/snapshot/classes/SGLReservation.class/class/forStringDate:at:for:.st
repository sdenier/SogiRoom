
!SGLReservation class methodsFor: 'initialize-release'!
forStringDate: aDateString at: aTimeString for: aDurationString 
	^ self new
			date: aDateString;
			time: aTimeString;
			duration: aDurationString;
			save;
			yourself! !
