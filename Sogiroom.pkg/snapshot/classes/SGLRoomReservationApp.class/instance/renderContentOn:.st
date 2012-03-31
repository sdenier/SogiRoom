
!SGLRoomReservationApp methodsFor: 'as yet unclassified'!
renderContentOn: html

	html heading: 'Sogilis Meeting Room Reservation'.
	self reservations do: [:resa|
		html text: resa printString ; break ].
	html render: editor.! !
