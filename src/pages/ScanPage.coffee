DirStore = require '../stores/DirStore'
TreeNode = require '../components/Tree'
DB = require '../services/NeDbService'
ProcessService = require '../services/ProcessService'
Reflux = require 'reflux'
React = require 'react'
R = React.DOM

Actions = require '../actions'

Page = React.createClass
  displayName: 'SubPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  buttonClickHandler: ->
    Actions.scan()

  processButtonClickHandler: ->
    # Actions.processDirTree()

  render: ->
    # console.log 'rndr'
    R.div {},
      R.h3 {}, 'SCAN: ' + @props.params.id
      R.h4 {}, 'Scanned Paths:'
      R.ul {},
        DirStore.scanningPaths.map \
          (item) -> R.li {key: item}, item
      R.h4 {}, 'Tree:'
      React.createElement TreeNode,
        items: DirStore.data.get('items') #DirStore.data.get('items')
        name: DirStore.data.get('name') #DirStore.data.get('name')
      R.hr {}
      R.button {onClick: @buttonClickHandler}, 'SCAN'
      R.button {onClick: @processButtonClickHandler}, 'PROCESS TREE'
      R.hr {}
      R.p {}, DirStore['scannedFiles']

module.exports = Page
