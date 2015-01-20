React = require 'react'
R = React.DOM
Types = React.PropTypes
_ = require 'lodash'
TreeNode = require './TreeNode'

Tree = React.createClass
  displayName: 'Tree'

  propTypes: ->
    data: Types.object
    persistKey: Types.string
    selectedItem: Types.string
    collapsed: Types.bool
    nodeRenderer: Types.element

  # getInitialState: ->
  #   collapsed: false

  clickHandler: (e) ->
    @props.onClick?(e)
    @forceUpdate()

  render: ->
    return R.div {} unless @props.data?

    # collapsed = @props.collapsed ? @state.collapsed
    treeNodeProps =
      onClick: @clickHandler
      # collapsed: collapsed
      data: @props.data
      name: @props.data.name
      items: @props.data.items
      path: @props.path
      selectedItem: @props.selectedItem
      persistKeyPrefix: @props.persistKey
      nodeRenderer: @props.nodeRenderer

    R.div {key: @props.key, className:'reac-tree'},
      React.createElement TreeNode, treeNodeProps

module.exports = Tree
