
!SGLRoomReservationEditor methodsFor: 'as yet unclassified'!
renderContentOn: html

	html form: [
		html text: 'Date:'.
		html textInput
			id: 'date';
			on: #date of: reservation.
		html break.
		html text: 'Time:'.
		html textInput
			id: 'time';
			on: #time of: reservation.
		html break.
		html text: 'Duration:'.
		html numberInput
			id: 'duration';
			on: #duration of: reservation.
		html break.
		html submitButton
			callback: [ self save ];
			with: 'Book' ]! !
