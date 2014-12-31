DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'

console.log 'count '+DirStore.DB.photoCount()

Page = React.createClass
  displayName: 'HomePage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate(); console.log('fuck')

  render: ->
    R.div {},
      R.h3 {}, 'HOME'
      R.hr {}
      R.div {},
        R.p( {}, photo.path) for photo in DirStore.photos

module.exports = Page
