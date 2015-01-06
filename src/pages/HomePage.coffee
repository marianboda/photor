DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'

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
        R.h3 {}, 'DIRS: ' + DirStore.dirs.length
        R.ul {},
          R.li( {}, photo.path) for photo in DirStore.dirs
        R.h3 {}, 'FILES: ' + DirStore.photos.length

module.exports = Page
