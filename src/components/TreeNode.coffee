React = require 'react'
R = React.DOM
Node = require './Node'
_ = require 'lodash'

TreeNode = React.createClass
  displayName: 'TreeNode'
  getInitialState: ->
    savedState = JSON.parse(localStorage.getItem("DirTreeNode-"+@props?.path))
    collapsed: savedState ? true

  clickHandler: (e) ->
    @props.onClick?(@props.path)

  toggleHandler: (e) ->
    collapsed = !@state.collapsed
    console.log 'collapsed', collapsed, typeof collapsed
    if collapsed
      localStorage.removeItem("DirTreeNode-"+@props?.path)
    else
      localStorage.setItem("DirTreeNode-"+@props?.path, JSON.stringify(collapsed))
    @setState collapsed: collapsed

  render: ->
    unless @props.items?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed

    selected = @props.selectedItem is @props.path
    nodes = if collapsed then null else @props.items.map (item) =>
      React.createElement TreeNode, _.extend(item, {onClick: @props?.onClick, key: item.path, selectedItem: @props.selectedItem})

    R.div {key: @props.key, className:'tree-node-container'},
      React.createElement Node, {onClick: @clickHandler, onToggle: @toggleHandler, collapsed: collapsed, name: @props.name, items: @props.items, selected: selected}
      R.div {className: 'tree-sub-nodes'}, nodes unless collapsed

module.exports = TreeNode
