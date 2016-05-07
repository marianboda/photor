React = require 'react'
R = React.DOM
Types = React.PropTypes
Node = require './NodeRenderer'
_ = require 'lodash'

TreeNode = React.createClass
  displayName: 'TreeNode'

  propTypes: ->
    persistKeyPrefix: Types.string
    nodeRenderer: Types.object
    data: Types.object

  getDefaultProps: ->
    persistKeyPrefix: 'TreeNode'
    nodeRenderer: Node

  getInitialState: ->
    savedState = JSON.parse(localStorage.getItem(@props.persistKeyPrefix + "-" + @props.path))
    collapsed: savedState ? true

  clickHandler: (e) ->
    @props.onClick?(@props.path)

  toggleHandler: (e) ->
    collapsed = !@state.collapsed
    if collapsed
      localStorage.removeItem("#{@props.persistKeyPrefix}-#{@props.path}")
    else
      localStorage.setItem("#{@props.persistKeyPrefix}-#{@props.path}", JSON.stringify(collapsed))
    @setState collapsed: collapsed

  render: ->
    unless @props.items?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed

    selected = @props.selectedItem is @props.path

    items = _.orderBy(@props.items, ['deepFilesCount'], ['desc'])

    nodes = if collapsed then null else items.map (item) =>
      React.createElement TreeNode,
        key: item.path
        data: item
        name: item.name
        path: item.path
        items: item.items
        onClick: @props?.onClick
        selectedItem: @props.selectedItem
        persistKeyPrefix: @props.persistKeyPrefix
        nodeRenderer: @props.nodeRenderer

    R.div {key: @props.key, className: 'tree-node-container'},
      React.createElement @props.nodeRenderer,
        onClick: @clickHandler
        onToggle: @toggleHandler
        collapsed: collapsed
        name: @props.name
        data: @props.data
        items: @props.items
        selected: selected
        persistKeyPrefix: @props.persistKeyPrefix
        value: @props.deepFilesCount
      R.div {className: 'tree-sub-nodes'}, nodes unless collapsed

module.exports = TreeNode
