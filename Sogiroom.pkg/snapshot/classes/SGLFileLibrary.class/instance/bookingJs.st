
!SGLFileLibrary methodsFor: 'uploaded'!
bookingJs
	^ 'SMR = {
  reservations: function() {
    return SMR.Store.reservations
  },
  listReservations: function() {
    SMR.Store.loadReservations( SMR.MainView.renderReservations )
  },
  getReservation: function(id) {
    SMR.Store.fetchReservation(id, function(id) {
      SMR.MainView.renderReservation(id) })
  },
  saveReservation: function(reservation) {
    try {
      SMR.Store.saveReservation(reservation, SMR.MainView.renderReservations)
      return true
    } catch(ex) {
      SMR.MainView.showException(ex)
      return false
    }
  },
  deleteReservation: function(reservation) {
    $(''#js-reservation-detail'').empty()
    SMR.Store.deleteReservation(reservation, SMR.MainView.renderReservations)
  },
}

SMR.Store = {
  reservations: [],
  loadReservations: function(done) {
    var self = this
    $.getJSON(''booking-api'')
      .success(function(data, status) {
        _.each(data, function(json) {
          self._mergeReservation( self._newReservationFromJson(json) )
        })
        done()
      })
  },
  fetchReservation: function(id, done) {
    $.getJSON(''booking-api/'' + id)
      .success(function(json, status) {
        var reservation = this._mergeReservation( this._newReservationFromJson(json) )
        done(reservation)
      }.bind(this))
  },
  saveReservation: function(reservation, done) {
    if( reservation.conflict() ){
      throw "Conflict"
    }
    if( reservation.isNew() ){
      this.createReservation(reservation, done)
    } else {
      this.updateReservation(reservation, done)
    }
  },
  createReservation: function(reservation, done) {
    $.post(''booking-api'',
        JSON.stringify(reservation),
        function(guid) {
          reservation.guid = parseInt(guid)
          this.reservations.push(reservation)
          done()
        }.bind(this),
        ''json'')
  },
  updateReservation: function(reservation, next) {
    $.ajax({type: ''PUT'',
        url: ''booking-api/'' + reservation.id(),
        data: JSON.stringify(reservation),
        complete: function(data, status) {
          next()
        },
        dataType: ''json'' })
  },
  deleteReservation: function(reservation, next) {
    $.ajax({type: ''DELETE'',
        url: ''booking-api/'' + reservation.id(),
        complete: function(data, status) {
          var i = this.reservations.indexOf(reservation)
          this.reservations.splice(i, 1)
          next()
        }.bind(this),
        dataType: ''json'' }).done(function() {console.log(''done'')})
  },
  _newReservationFromJson: function(json) {
    return new SMR.Reservation().fromJSON(json)
  },
  _findReservation: function(id, ifNone) {
    var resa = _.find(this.reservations, function(res){ return res.id() == id })
    if( resa == undefined ){
      resa = ifNone()
    }
    return resa
  },
  _mergeReservation: function(resa) {
    return this._findReservation(resa.id(), function() {
      this.reservations.push(resa)
    }.bind(this))
  },
}

SMR.Reservation = function Reservation(attributes) {
  attributes    = attributes || {}
  this.datetime = attributes.datetime || new Date()
  this.duration = attributes.duration || 3600000
}
$.extend(SMR.Reservation.prototype, {
  fromJSON: function(json) {
    this.guid = json.guid
    this.datetime = new Date(json.datetime)
    this.duration = json.duration
    return this
  },
  id: function() {
    return this.guid
  },
  isNew: function() {
    return this.guid === undefined
  },
  startTime: function() {
    return this.datetime
  },
  endTime: function() {
    return new Date(this.datetime).add({milliseconds: this.duration})
  },
  overlaps: function(reservation) {
    return this.startTime() < reservation.endTime() && reservation.startTime() < this.endTime()
  },
  conflict: function() {
    return _.any(SMR.Store.reservations, function(resa) {
      return this !!== resa && this.overlaps(resa)
    }.bind(this))
  },
  renderDate: function() {
    return this.startTime().toString("d-MMM-yyyy")
  },
  renderTime: function(datetime) {
    return datetime.toString("HH:mm")
  },
  renderDateTime: function(datetime) {
    return this.renderDate(datetime) + " @ " + this.renderTime(datetime)
  },
  render: function() {
    return this.renderDateTime(this.startTime()) + '' until '' + this.renderTime(this.endTime())
  },
})

SMR.MainView = {
  renderReservations: function() {
    $(''#js-reservations'').empty()
    var list = $(''<ul>'')
    SMR.reservations().forEach(function(resa) {
      var li = $(''<li>'', {''data-id'': resa.id()})
      var link = $(''<a>'', {href: ''#''})
        .html(resa.renderDate())
        .click(function() {
          SMR.getReservation(resa.id())
        })
      li.append(link).append('' '' + resa.renderTime(resa.startTime()) + '' - '' + resa.renderTime(resa.endTime()))

      var editLink = $(''<a href="#">edit</a>'').click(function() {
        SMR.EditView.editReservation(resa)
      })
      var deleteLink = $(''<a href="#">delete</a>'').click(function() {
        SMR.deleteReservation(resa)
      })
      li.append('' ('').append(editLink).append('' '').append(deleteLink).append('')'')
      list.append(li)
    })
    $(''#js-reservations'').append(list)

    var newLink = $(''<a href="#">New</a>'').click(function() {
      SMR.EditView.editReservation(new SMR.Reservation())
    })
    $(''#js-reservations'').append(newLink).append('' '')
    
    var refreshLink = $(''<a href="#">Refresh</a>'').click( SMR.listReservations )
    $(''#js-reservations'').append(refreshLink)
  },
  renderReservation: function(reservation) {
    var resa_dom = $(''<p>'')
    resa_dom.html(reservation.render())
    $(''#js-reservation-detail'').empty().append(resa_dom)
  },
  showException: function(exception) {
    $(''#js-flash'').html(exception)
  },
}

SMR.EditView = {
  template: ''<p>Date:<input id="date" type="text"><br>Time:<input id="time" type="text"><br>Duration:<input id="duration" type="number"><br><input id="save" value="Book" type="submit"></p>'',
  editReservation: function(reservation) {
    $(''#js-reservation-detail'').empty().append(this.template)
    var dateField = $(''#date'').val(reservation.startTime().toString("yyyy-MM-dd"))
    var timeField = $(''#time'').val(reservation.startTime().toString("HH:mm"))
    var durationField = $(''#duration'').val(reservation.duration / 60000)
    $(''#save'')
      .val( reservation.isNew() ? ''Book'' : ''Update'' )
      .click(function(){
        $(''#js-flash'').empty()
        reservation.datetime = Date.parse(dateField.val() + '' '' + timeField.val())
        reservation.duration = durationField.val() * 60000
        if( SMR.saveReservation(reservation) ){
          $(''#js-reservation-detail'').empty()
        }
    })
  },
}

$(document).ready(function(){
  SMR.listReservations()
})
'! !