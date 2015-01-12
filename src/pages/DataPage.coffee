DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
TreeNode = require '../components/Tree'

Page = React.createClass
  displayName: 'DataPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  render: ->
    R.div {},
      R.h3 {}, 'DATA'
      R.hr {}
      React.createElement TreeNode,
        items: DirStore.dirTree['items']
        name: DirStore.dirTree['name']

module.exports = Page
