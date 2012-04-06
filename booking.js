SMR = {
  reservations: function() {
    return _.sortBy(SMR.Store.reservations, function(r) { return r.startTime() })
  },
  listReservations: function() {
    SMR.Store.loadReservations( SMR.MainView.renderReservations )
  },
  saveReservation: function(reservation) {
    SMR.Store.saveReservation(reservation,
      function(){
        SMR.MainView.hideDetail()
        SMR.MainView.renderReservations()},
      function(type, resources){
        switch(type) {
          case 'Overlap':
            SMR.MainView.renderReservations()
            SMR.MainView.mergeOverlapConflict(type, reservation, resources)
            break
          case 'Concurrent Edit':
            SMR.MainView.mergeEditConflict(type, reservation, resources)
            break
          case 'Deleted':
            SMR.MainView.mergeRestoreConflict(type, reservation, resources)
            break
        }
      })
  },
  deleteReservation: function(reservation) {
    SMR.MainView.hideDetail()
    SMR.Store.deleteReservation(reservation,
      SMR.MainView.renderReservations,
      function(type, resources) {
        SMR.MainView.mergeDeleteConflict(type, reservation, resources) })
  },
  acceptReservation: function(reservation) {
    SMR.Store.mergeReservation(reservation)
    SMR.MainView.hideDetail()
    $('#js-flash').empty()
    SMR.MainView.renderReservations()
  },
  overwriteReservation: function(reservation, resource) {
    reservation.timestamp = resource.timestamp // up to current version
    this.saveReservation(reservation)
  },
  forcedeleteReservation: function(reservation, resource) {
    reservation.timestamp = resource.timestamp // up to current version
    this.deleteReservation(reservation)
  },
  deletedReservation: function(reservation, signature) {
    reservation.timestamp = signature.timestamp
    SMR.Store.removeReservation(reservation.id())
    SMR.MainView.hideDetail()
    SMR.MainView.renderReservations()
  },
  recreateReservation: function(reservation, signature) {
    SMR.Store.removeReservation(reservation.id())
    reservation.resetNew()
    this.saveReservation(reservation)
  },
}

SMR.Store = {
  reservations: [],
  loadReservations: function(done) {
    this.reservations = []
    var self = this
    $.getJSON('booking-api')
      .success(function(data, status) {
        _.each(data, function(json) {
          self._addReservation( self._newReservationFromJson(json) )
        })
        done()
      })
  },
  retrieveReservations: function(ids) {
    var resources = []
    var self = this
    _.each(ids, function(id) {
      $.ajax({type: 'GET',
              url:  'booking-api/' + id,
              dataType: 'json',
              async: false})
        .success(function(json) {
              resources.push( self._newReservationFromJson(json) )
        })
      })
    return resources
  },
  saveReservation: function(reservation, afterSuccess, afterError) {
    if( reservation.conflict() ){
      afterError('Conflict')
      return
    }
    if( reservation.isNew() ){
      this.createReservation(reservation, afterSuccess, afterError)
    } else {
      this.updateReservation(reservation, afterSuccess, afterError)
    }
  },
  createReservation: function(reservation, afterSuccess, afterError) {
    $.post('booking-api',
            JSON.stringify(reservation),
            'json')
      .success(function(jsonSig) {
            reservation.guid = jsonSig.guid
            reservation.timestamp = jsonSig.timestamp
            this._addReservation(reservation)
            afterSuccess()
      }.bind(this))
      .error(function(jqXHR, status, error) {
            var exception = JSON.parse(jqXHR.responseText)
            this._handleConflict(exception, afterError)
      }.bind(this))
  },
  updateReservation: function(reservation, afterSuccess, afterError) {
    $.ajax({type: 'PUT',
            url: 'booking-api/' + reservation.id(),
            data: JSON.stringify(reservation),
            dataType: 'json' })
      .success(function(jsonSig, status) {
            reservation.timestamp = jsonSig.timestamp
            this.mergeReservation(reservation)
            afterSuccess()
      }.bind(this))
      .error(function(jqXHR, status, error) {
            var exception = JSON.parse(jqXHR.responseText)
            this._handleConflict(exception, afterError)
      }.bind(this))
  },
  deleteReservation: function(reservation, afterSuccess, afterError) {
    $.ajax({type: 'DELETE',
        url: 'booking-api/' + reservation.id() + '/' + reservation.timestamp,
        dataType: 'json' })
        .success(function(jsonSig, status) {
          reservation.timestamp = jsonSig.timestamp
          this.removeReservation(reservation.id())
          afterSuccess()
        }.bind(this))
        .error(function(jqXHR, status, error) {
              var exception = JSON.parse(jqXHR.responseText)
              this._handleConflict(exception, afterError)
        }.bind(this))
  },
  mergeReservation: function(reservation) {
    var resa = this._findReservation(reservation.id())
    if( resa == undefined ) {
      this._addReservation(reservation)
    } else {
      _.extend(resa, reservation)
    }
  },
  removeReservation: function(id) {
    var i = this.reservations.indexOf(this._findReservation(id))
    this.reservations.splice(i, 1)
  },
  _newReservationFromJson: function(json) {
    return new SMR.Reservation().fromJSON(json)
  },
  _addReservation: function(reservation) {
    this.reservations.push(reservation)
  },
  _findReservation: function(id) {
    return _.find(this.reservations, function(res){ return res.id() == id })
  },
  _handleConflict: function(conflict, afterError) {
    var type = conflict.conflict
    var remotes = conflict.resources
    if( type != 'Deleted' ) {
      var ids = _.map(remotes, function(res){ return res.guid })
      remotes = this.retrieveReservations(ids)
      if( type == 'Overlap' ) {
        _.each(remotes, function(res) {
          this.mergeReservation(res)
        }.bind(this))
      }
    }
    afterError(type, remotes)
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
    this.timestamp = json.timestamp
    return this
  },
  id: function() {
    return this.guid
  },
  isNew: function() {
    return this.guid === undefined
  },
  resetNew: function() {
    this.guid = undefined
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
      return this.id() != resa.id() && this.overlaps(resa)
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
    return this.renderDateTime(this.startTime()) + ' until ' + this.renderTime(this.endTime())
  },
})

SMR.MainView = {
  renderReservations: function() {
    $('#js-reservations').empty()
    var list = $('<ul>')
    SMR.reservations().forEach(function(resa) {
      var li = $('<li>', {'data-id': resa.id()})
      var link = $('<a>', {href: '#'})
        .html(resa.renderDate())
        .click(function() {
          SMR.MainView.renderReservation(resa)
        })
      li.append(link).append(' ' + resa.renderTime(resa.startTime()) + ' - ' + resa.renderTime(resa.endTime()))

      var editLink = $('<a href="#">edit</a>').click(function() {
        SMR.EditView.editReservation(_.clone(resa))
      })
      var deleteLink = $('<a href="#">delete</a>').click(function() {
        SMR.deleteReservation(resa)
      })
      li.append(' (').append(editLink).append(' ').append(deleteLink).append(')')
      list.append(li)
    })
    $('#js-reservations').append(list)

    var newLink = $('<a href="#">New</a>').click(function() {
      SMR.EditView.editReservation(new SMR.Reservation())
    })
    $('#js-reservations').append(newLink).append(' ')

    var refreshLink = $('<a href="#">Refresh</a>').click( SMR.listReservations )
    $('#js-reservations').append(refreshLink)
  },
  renderReservation: function(reservation) {
    var resa_dom = $('<p>')
    resa_dom.html(reservation.render())
    $('#js-reservation-detail').empty().append(resa_dom)
  },
  hideDetail: function() {
    $('#js-reservation-detail').empty()
  },
  showException: function(exception) {
    $('#js-flash').html(exception)
  },
  mergeOverlapConflict: function(type, reservation, resources) {
    this.showException(type)
    SMR.MergeOverlapView.showConflict(reservation, resources)
  },
  mergeEditConflict: function(type, reservation, resources) {
    this.showException(type)
    SMR.MergeEditView.showConflict(reservation, resources[0])
  },
  mergeRestoreConflict: function(type, reservation, resources) {
    this.showException(type)
    SMR.MergeRestoreView.showConflict(reservation, resources[0])
  },
  mergeDeleteConflict: function(type, reservation, resources) {
    this.showException(type)
    SMR.MergeDeleteView.showConflict(reservation, resources[0])
  },
}

SMR.EditView = {
  template: '<p>Date:<input id="date" type="text"><br>Time:<input id="time" type="text"><br>Duration:<input id="duration" type="number"><br><input id="save" value="Book" type="submit"><input id="cancel" value="Cancel" type="button"></p>',
  editReservation: function(reservation) {
    $('#js-reservation-detail').empty().append(this.template)
    var dateField = $('#date').val(reservation.startTime().toString("yyyy-MM-dd"))
    var timeField = $('#time').val(reservation.startTime().toString("HH:mm"))
    var durationField = $('#duration').val(reservation.duration / 60000)
    $('#save')
      .val( reservation.isNew() ? 'Book' : 'Update' )
      .click(function(){
        $('#js-flash').empty()
        reservation.datetime = Date.parse(dateField.val() + ' ' + timeField.val())
        reservation.duration = durationField.val() * 60000
        SMR.saveReservation(reservation)
    })
    $('#cancel').click(function() {
      $('#js-reservation-detail').empty()
      $('#js-flash').empty()
    })
  },
}

SMR.MergeEditView = {
  parent: function() {
    return $('#js-reservation-detail')
  },
  resourceTemplate: function(resource) {
    return '<p>Reservation has changed on server:<br>' + resource.render() + '<br><input id="accept" value="Accept" type="submit"></p>'
  },
  showRemoteResource: function(resource) {
    this.parent().append(this.resourceTemplate(resource))
    $('#accept').click(function() {
      SMR.acceptReservation(resource)
    })
  },
  editTemplate: '<p>Date:<input id="date" type="text"><br>Time:<input id="time" type="text"><br>Duration:<input id="duration" type="number"><br><input id="overwrite" value="Overwrite" type="submit"><input id="cancel" value="Cancel" type="button"></p>',
  editReservation: function(reservation, resource) {
    this.parent().append(this.editTemplate)
    var dateField = $('#date').val(reservation.startTime().toString("yyyy-MM-dd"))
    var timeField = $('#time').val(reservation.startTime().toString("HH:mm"))
    var durationField = $('#duration').val(reservation.duration / 60000)
    $('#overwrite').click(function(){
      $('#js-flash').empty()
      reservation.datetime = Date.parse(dateField.val() + ' ' + timeField.val())
      reservation.duration = durationField.val() * 60000
      SMR.overwriteReservation(reservation, resource)
    })
    $('#cancel').click(function() {
      $('#js-reservation-detail').empty()
      $('#js-flash').empty()
    })
  },
  showConflict: function(reservation, resource) {
    this.parent().empty()
    this.showRemoteResource(resource)
    this.editReservation(reservation, resource)
  }
}

SMR.MergeOverlapView = {
  parent: function() {
    return $('#js-reservation-detail')
  },
  resourceTemplate: function(resource) {
    return '<br>' + resource.render()
  },
  showRemoteResources: function(resources) {
    var dom = _.reduce(resources, function(dom, res){
      return dom + this.resourceTemplate(res)
    }.bind(this), "Conflicting reservations:")
    this.parent().append("<p>" + dom + "</p>")
  },
  editTemplate: '<p>Date:<input id="date" type="text"><br>Time:<input id="time" type="text"><br>Duration:<input id="duration" type="number"><br><input id="update" value="Update" type="submit"><input id="cancel" value="Cancel" type="button"></p>',
  editReservation: function(reservation) {
    this.parent().append(this.editTemplate)
    var dateField = $('#date').val(reservation.startTime().toString("yyyy-MM-dd"))
    var timeField = $('#time').val(reservation.startTime().toString("HH:mm"))
    var durationField = $('#duration').val(reservation.duration / 60000)
    $('#update')
      .val( reservation.isNew() ? 'Book' : 'Update' )
      .click(function(){
        $('#js-flash').empty()
        reservation.datetime = Date.parse(dateField.val() + ' ' + timeField.val())
        reservation.duration = durationField.val() * 60000
        SMR.saveReservation(reservation)
    })
    $('#cancel').click(function() {
      $('#js-reservation-detail').empty()
      $('#js-flash').empty()
    })
  },
  showConflict: function(reservation, resources) {
    this.parent().empty()
    this.showRemoteResources(resources)
    this.editReservation(reservation)
  }
}

SMR.MergeRestoreView = {
  parent: function() {
    return $('#js-reservation-detail')
  },
  resourceTemplate: function(resource) {
    return '<p>Reservation has been deleted on server:<br>' + resource.render() + '<br><input id="recreate" value="Recreate" type="submit"><input id="delete" value="Delete" type="submit"><input id="cancel" value="Cancel" type="submit"></p>'
  },
  showConflict: function(reservation, signature) {
    this.parent().empty().append(this.resourceTemplate(reservation))
    $('#recreate').click(function() {
      $('#js-flash').empty()
      SMR.recreateReservation(reservation, signature)
    })
    $('#delete').click(function(){
      $('#js-flash').empty()
      SMR.deletedReservation(reservation, signature)
    })
    $('#cancel').click(function() {
      $('#js-reservation-detail').empty()
      $('#js-flash').empty()
    })
  }
}

SMR.MergeDeleteView = {
  parent: function() {
    return $('#js-reservation-detail')
  },
  resourceTemplate: function(resource) {
    return '<p>Reservation has changed on server:<br>' + resource.render() + '<br><input id="accept" value="Accept" type="submit"><input id="forcedelete" value="Force delete" type="submit"><input id="cancel" value="Cancel" type="submit"></p>'
  },
  showConflict: function(reservation, resource) {
    this.parent().empty().append(this.resourceTemplate(resource))
    $('#accept').click(function() {
      SMR.acceptReservation(resource)
    })
    $('#forcedelete').click(function(){
      $('#js-flash').empty()
      SMR.forcedeleteReservation(reservation, resource)
    })
    $('#cancel').click(function() {
      $('#js-reservation-detail').empty()
      $('#js-flash').empty()
    })
  }
}

$(document).ready(function(){
  SMR.listReservations()
})
