DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
Tree = require '../components/Tree'
Actions = require '../actions'

Page = React.createClass
  displayName: 'DataPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  treeItemClickHandler: (event) ->
    console.log 'item was clicked somehow: ', event
    # Actions.selectDirectory(event)


  render: ->
    console.log 'rendering data page'
    R.div {},
      R.div {id: 'left_panel'},
        React.createElement Tree,

          onClick: @treeItemClickHandler
          data: DirStore.dirTree
      R.div {id: 'right_content'},
        R.p {}, 'count: ' + DirStore.photos.length
        R.table {},
          R.tr({}, [R.td({}, i),R.td({}, item.name)]) for item,i in DirStore.photos

module.exports = Page
