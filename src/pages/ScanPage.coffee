DirStore = require '../stores/DirStore'
TreeNode = require '../components/Tree'
DB = require '../services/NeDbService'
ProcessService = require '../services/ProcessService'
Reflux = require 'reflux'
React = require 'react'
R = React.DOM
Button = require '../components/IconButton'
Icon = require '../components/Icon'

remote = require 'remote'
Dialog = remote.require 'dialog'

Actions = require '../actions'

Page = React.createClass
  displayName: 'SubPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  scanButtonHandler: ->
    Actions.scan()

  processButtonClickHandler: ->
    # Actions.processDirTree()

  addDirectoryHandler: ->
    Dialog.showOpenDialog {properties: ['openDirectory', 'multiSelections']}, (files) ->
      Actions.addDirectoryToLibrary files

  removeDirectoryHandler: (e) ->
    path = e.dispatchMarker.split('.')
    path.pop()
    Actions.removeDirectoryFromLibrary path.pop()[1..]

  addIgnorePathHandler: ->
    Dialog.showOpenDialog {properties: ['openDirectory', 'multiSelections']}, (paths) ->
      Actions.addIgnorePath paths

  removeIgnorePathsHandler: (e) ->
    path = e.dispatchMarker.split('.')
    path.pop()
    console.log path
    Actions.removeIgnorePath path.pop()[1..]

  render: ->
    R.div {},
      R.h4 {}, 'Scanned Paths'
      R.table {},
        R.tbody {},
          DirStore.scanningPaths.map (item) =>
            R.tr {key: item},
              R.td {key: item+'_td'}, item
              R.td {},
                React.createElement Icon,
                  icon: 'squared-minus'
                  key: item
                  classes: ['delete']
                  onClick: @removeDirectoryHandler
          R.tr {},
            R.td {colSpan: 2},
              React.createElement Icon,
                icon: 'squared-plus'
                classes: ['add']
                onClick: @addDirectoryHandler

      R.h4 {}, 'Ignore Paths'
      R.table {},
        R.tbody {},
          DirStore.ignorePaths.map (item) =>
            R.tr {key: item},
              R.td {key: item+'_td'}, item
              R.td {},
                React.createElement Icon,
                  icon: 'squared-minus'
                  key: item
                  classes: ['delete']
                  onClick: @removeIgnorePathsHandler
          R.tr {},
            R.td {colSpan: 2},
              React.createElement Icon,
                icon: 'squared-plus'
                classes: ['add']
                onClick: @addIgnorePathHandler

      R.br {}
      React.createElement Button, {icon: 'cycle', onClick: @scanButtonHandler}
      R.hr {}
      R.p {}, DirStore['scannedFiles']

module.exports = Page
