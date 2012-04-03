
!SGLConflict class methodsFor: 'exceptioninstantiator'!
signal: type withResources: resources

	^ self new
		messageText: type ;
		resources: resources ;
		signal! !
