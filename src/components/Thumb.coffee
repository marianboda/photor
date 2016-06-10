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

    children = if @props.src?
        (R.img {src: @props.src, onDoubleClick: @props.clickHandler})
      else
        (R.div {style: defThumbStyle}, @props.name)

    R.div {className: classes}, children

module.exports = Icon
