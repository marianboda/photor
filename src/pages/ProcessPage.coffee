DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'

Page = React.createClass
  displayName: 'ProcessPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  render: ->
    R.div {},
      R.h3 {}, 'PROCESS'
      R.hr {}


module.exports = Page
