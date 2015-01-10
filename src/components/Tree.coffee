React = require 'react'
R = React.DOM
Node = require './Node'

TreeNode = React.createClass
  displayName: 'TreeNode'
  getInitialState: ->
    collapsed: true

  clickHandler: (e) ->
    console.log 'treeEve'
    @setState collapsed: !@state.collapsed

  render: ->
    unless @props.items?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed
    nodes = if collapsed then null else @props.items.map (item) ->
      React.createElement TreeNode, item

    R.div {key: @props.key, className:'treeNode'},
      React.createElement Node, {onClick: @clickHandler, collapsed, name: @props.name, items: @props.items}
      R.div {className: 'treeSubNodes'}, nodes unless collapsed

module.exports = TreeNode
