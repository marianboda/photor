DirStore = require '../stores/DirStore'
TreeNode = require '../components/Tree'
DB = require '../services/NeDbService'
ProcessService = require '../services/ProcessService'
Reflux = require 'reflux'
React = require 'react'
R = React.DOM

remote = require 'remote'
Dialog = remote.require 'dialog'

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

  addDirectoryHandler: ->
    Dialog.showOpenDialog {properties: ['openDirectory', 'multiSelections']}, (files) ->
      Actions.addDirectoryToLibrary files

  removeDirectoryHandler: (e) ->
    Actions.removeDirectoryFromLibrary e.dispatchMarker.split('.').pop()[1..]

  render: ->
    R.div {},
      R.h4 {}, 'Scanned Paths:'
      R.ul {},
        DirStore.scanningPaths.map \
          (item) => R.li {key: item}, [item, R.button({onClick: @removeDirectoryHandler, key: item}, '-')]
      R.button {onClick: @addDirectoryHandler}, '+'
      R.button {onClick: @buttonClickHandler}, 'SCAN'
      R.button {onClick: @processButtonClickHandler}, 'PROCESS TREE'
      R.hr {}
      R.p {}, DirStore['scannedFiles']

module.exports = Page
