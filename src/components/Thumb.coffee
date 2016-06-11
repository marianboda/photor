React = require 'react'
R = React.DOM
Types = React.PropTypes

defThumbStyle =
  width: 200
  height: '100%'
  border: '1px solid #333333'
  backgroundColor: '#555555'
  textAlign: 'center'
  paddingTop: 50

Icon = React.createClass
  displayName: 'Thumb'

  propTypes: ->
    src: Types.string
    classes: Types.array

  render: ->
    classes = ['thumb']
    classes = classes.concat @props.classes if @props.classes?
    classes.push 'selected' if @props.selected

    children = if @props.src?
        (R.img {src: @props.src, onDoubleClick: @props.onDoubleClick, onClick: @props.onClick})
      else
        (R.div {style: defThumbStyle}, @props.name)

    R.div {className: classes.join(' ')}, children

module.exports = Icon
