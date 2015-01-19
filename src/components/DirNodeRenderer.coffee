React = require 'react'
R = React.DOM

TreeNode = React.createClass
  displayName: 'TreeNodeTitle'
  getInitialState: ->
    # collapsed: true
    null

  clickHandler: (e) ->
    target = e.dispatchMarker.split('.').pop()
    if target is '$toggler'
      @props.onToggle?(e)
    else
      @props.onClick?(e)

  render: ->
    unless @props.items?
      return R.div {}
    collapsed = @props.collapsed ? @state.collapsed
    triangle = if collapsed then '\u25b6' else '\u25bc'
    triangle = '' if @props.items.length is 0
    lengthString = if @props.items.length > 0 then @props.items.length + '' else '--'
    filesCount = if @props.data.files? then @props.data.files.length else '-'
    deepFilesCount = @props.data.deepFilesCount ? '-'

    R.div {onClick: @clickHandler, className: 'tree-node' + if @props.selected then ' selected' else ''},
      R.div {className: 'node-toggler', key: 'toggler'}, triangle
      R.div {className: 'node-label'}, @props.data.name
      R.div {className: 'size-label'}, filesCount + ' | ' + deepFilesCount

module.exports = TreeNode
