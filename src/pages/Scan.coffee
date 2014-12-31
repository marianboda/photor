DirStore = require '../stores/DirStore'
TreeNode = require '../tree'
DB = require '../services/NeDbService'
ProcessService = require '../services/ProcessService'
Reflux = require 'reflux'
React = require 'react'
R = React.DOM

console.log 'screen SCAN INITIALIZATION ========'
console.log 'process.env.NODE_PATH', process.env.NODE_PATH

Actions = require '../actions'

Page = React.createClass
  displayName: 'SubPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  buttonClickHandler: ->
    # console.log 'yeah, it was clicked'
    Actions.scan()

  render: ->
    R.div {},
      R.h3 {}, 'SCAN: ' + @props.params.id
      React.createElement TreeNode,
        items: DirStore.data.get('items') #DirStore.data.get('items')
        name: DirStore.data.get('name') #DirStore.data.get('name')
      R.hr {}
      R.button {onClick: @buttonClickHandler}, 'SCAN'
      R.button {}, 'SOMETHIN ELSE'
      R.hr {}
      R.p {}, DirStore['scannedFiles']

module.exports = Page
