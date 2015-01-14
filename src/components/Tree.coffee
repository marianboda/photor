React = require 'react'
R = React.DOM
Node = require './Node'
_ = require 'lodash'

TreeNode = React.createClass
  displayName: 'TreeNode'
  getInitialState: ->
    collapsed: true

  clickHandler: (e) ->
    console.log 'treeEve', @props
    @setState collapsed: !@state.collapsed
    @props.onClick?(@props.path)

  render: ->
    unless @props.items?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed

    # console.log 'props: ', @props
    nodes = if collapsed then null else @props.items.map (item) =>
      React.createElement TreeNode, _.extend(item, {onClick: @props?.onClick, key: item.path})

    R.div {key: @props.key, className:'treeNode'},
      React.createElement Node, {onClick: @clickHandler, collapsed, name: @props.name, items: @props.items}
      R.div {className: 'treeSubNodes'}, nodes unless collapsed

module.exports = TreeNode
