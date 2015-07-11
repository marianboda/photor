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
    R.div {className: 'datapage-content'},
      R.div {id: 'left-panel'},
        React.createElement Tree,
          selectedItem: DirStore.selectedDir
          onClick: @treeItemClickHandler
          data: DirStore.dirTree
          persistKey: 'dirTree'
          nodeRenderer: DirNodeRenderer
      R.div {id: 'right-content', className: 'photo-container'},
        for item,i in DirStore.currentPhotos when item.hash?
          Element Thumb, {src: "file://#{config.THUMB_PATH}/#{item.hash[0..1]}/#{item.hash[0..19]}.jpg"}

module.exports = Page
