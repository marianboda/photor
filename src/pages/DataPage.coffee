DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
Tree = require '../components/Tree'
DirNodeRenderer = require '../components/DirNodeRenderer'
Actions = require '../actions'
config = require '../config'
Element = React.createElement
Thumb = require '../components/Thumb'

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
      R.div {id: 'right_content'},
        Element Thumb, {src: "file://#{config.THUMB_PATH}/#{item.hash[0...16]}.jpg"} for item,i in DirStore.currentPhotos when item.hash?

module.exports = Page
