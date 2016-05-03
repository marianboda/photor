React = require 'react'
R = React.DOM
Types = React.PropTypes

Icon = React.createClass
  displayName: 'Thumb'

  propTypes: ->
    src: Types.string
    classes: Types.array

  render: ->
    classes = ['thumb']
    classes = classes.concat @props.classes if @props.classes?

    R.div {className: classes},
      R.img {src: @props.src}

module.exports = Icon
