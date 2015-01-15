React = require 'react'
R = React.DOM
Node = require './Node'
_ = require 'lodash'
TreeNode = require './TreeNode'

console.log 'Tree init'

Tree = React.createClass
  displayName: 'Tree'
  getInitialState: ->
    collapsed: false

  clickHandler: (e) ->
    console.log 'Tree event', e
    @props.onClick?(@props.path)

  render: ->
    unless @props.data?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed
    treeNodeProps =
      onClick: @clickHandler
      collapsed: collapsed
      name: @props.data.name
      items: @props.data.items

    console.log 'nodeprosp', treeNodeProps
    # console.log 'props: ', @props
    # nodes = if collapsed then null else @props.items.map (item) =>
    #   React.createElement TreeNode, _.extend(item, {onClick: @props?.onClick, key: item.path})

    R.div {key: @props.key, className:'tree'},
      R.h3 {}, 'Tree: '
      React.createElement TreeNode,
        treeNodeProps
      # React.createElement Node, {onClick: @clickHandler, collapsed, name: @props.data.name, items: @props.data.items}
      # R.div {className: 'treeSubNodes'}, nodes unless collapsed

module.exports = Tree
