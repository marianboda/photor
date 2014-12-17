React = require 'react'
R = React.DOM

TreeNode = React.createClass
  displayName: 'TreeNode'
  getInitialState: ->
    collapsed: true

  clickHandler: (e) ->
    @setState collapsed: !@state.collapsed
    console.log 'clicked', @state.collapsed

  render: ->
    collapsed = @props.collapsed ? @state.collapsed
    triangle = if collapsed then '\u25b6' else '\u25bc'
    triangle = '' if @props.items.length is 0
    nodes = if collapsed then null else @props.items.map (item) ->
      React.createElement TreeNode, item
    lengthString = if @props.items.length > 0 then @props.items.length + '' else '-'

    R.div {key: @props.key, className:'treeNode'},
      R.div {onClick: @clickHandler, className: 'nodeName'},
        R.span {className: 'dirTriangle'}, triangle
        R.span {}, @props.name
        R.span {className: 'sizeLabel'}, lengthString
      R.div {className: 'treeSubNodes'}, nodes unless collapsed

module.exports = TreeNode
