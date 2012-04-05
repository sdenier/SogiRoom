
!SGLReservation methodsFor: 'json-export'!
deletedSignature

	^ self signature add: #status -> #deleted ; yourself! !
