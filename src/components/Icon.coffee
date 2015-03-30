React = require 'react'
R = React.DOM
Types = React.PropTypes
SVG = React.createFactory require('react-svg')

Icon = React.createClass
  displayName: 'Icon'

  propTypes: ->
    icon: Types.string
    classes: Types.array

  render: ->
    classes = ['svg-icon']
    classes = classes.concat @props.classes if @props.classes?

    R.div {onClick: @props.onClick}, '-icon-'
      # SVG
      #   path: "assets/entypo/#{@props.icon}.svg"
      #   className: classes.join ' '

module.exports = Icon
