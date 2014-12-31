DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'

console.log 'count '+DirStore.DB.photoCount()

Page = React.createClass
  displayName: 'HomePage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  render: ->
    R.div {},
      R.h3 {}, 'HOME'
      R.hr {}
      R.div {},
        R.h3 {}, 'DIRS'
        R.p( {}, photo.path) for photo in DirStore.dirs
        R.h3 {}, 'FILES'
        R.p( {}, photo.path) for photo in DirStore.photos

module.exports = Page
