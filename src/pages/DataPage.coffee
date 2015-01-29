DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
Tree = require '../components/Tree'
DirNodeRenderer = require '../components/DirNodeRenderer'
Actions = require '../actions'

Page = React.createClass
  displayName: 'DataPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  treeItemClickHandler: (event) ->
    Actions.selectDirectory(event)

  render: ->
    R.div {},
      R.div {id: 'left_panel'},
        React.createElement Tree,
          selectedItem: DirStore.selectedDir
          onClick: @treeItemClickHandler
          data: DirStore.dirTree
          persistKey: 'dirTree'
          nodeRenderer: DirNodeRenderer
        # React.createElement Tree,
        #   selectedItem: DirStore.selectedDir
        #   onClick: @treeItemClickHandler
        #   data: DirStore.dirTree
        #   persistKey: 'dirTree'
        #   nodeRenderer: DirNodeRenderer
      R.div {id: 'right_content'},
        R.p {}, 'count: ' + DirStore.currentPhotos.length
        R.table {},
          R.tbody {},
            R.tr({key: item.name}, [R.td({key: item.name}, i),R.td({key: 'td2'+item.name}, item.name)]) for item,i in DirStore.currentPhotos

module.exports = Page
