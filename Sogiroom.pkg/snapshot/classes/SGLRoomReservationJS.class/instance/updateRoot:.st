
!SGLRoomReservationJS methodsFor: 'updating'!
updateRoot: anHtmlRoot

	super updateRoot: anHtmlRoot.
	anHtmlRoot script url: SGLFileLibrary / #underscoreminJs.
	anHtmlRoot script url: SGLFileLibrary / #dateJs.
	anHtmlRoot script url: SGLFileLibrary / #bookingJs! !
