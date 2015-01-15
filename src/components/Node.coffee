React = require 'react'
R = React.DOM

TreeNode = React.createClass
  displayName: 'TreeNodeTitle'
  getInitialState: ->
    collapsed: true

  clickHandler: (e) ->
    # console.log 'node event'
    # @setState collapsed: !@state.collapsed

  render: ->
    unless @props.items?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed
    triangle = if collapsed then '\u25b6' else '\u25bc'
    triangle = '' if @props.items.length is 0
    nodes = if collapsed then null else @props.items.map (item) ->
      React.createElement TreeNode, item
    lengthString = if @props.items.length > 0 then @props.items.length + '' else '--'

    R.div {onClick: @props.onClick, className: 'nodeName'},
      R.span {className: 'dirTriangle'}, triangle
      R.span {}, @props.name
      R.span {className: 'sizeLabel'}, lengthString

module.exports = TreeNode
