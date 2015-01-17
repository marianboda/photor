React = require 'react'
R = React.DOM
Node = require './Node'
_ = require 'lodash'
TreeNode = require './TreeNode'

Tree = React.createClass
  displayName: 'Tree'
  selectedItem: null

  getInitialState: ->
    collapsed: false

  clickHandler: (e) ->
    @props.onClick?(e)
    @selectedItem = e
    @forceUpdate()

  render: ->
    return R.div {} unless @props.data?

    collapsed = @props.collapsed ? @state.collapsed
    treeNodeProps =
      onClick: @clickHandler
      collapsed: collapsed
      name: @props.data.name
      items: @props.data.items
      selectedItem: @selectedItem

    R.div {key: @props.key, className:'reac-tree'},
      React.createElement TreeNode, treeNodeProps

module.exports = Tree
