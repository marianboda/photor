React = require 'react'
R = React.DOM
Types = React.PropTypes
SVG = React.createFactory require('react-svg')

IconButton = React.createClass
  displayName: 'IconButton'

  propTypes: ->
    icon: Types.string

  render: ->
    elems = []
    elems.push SVG
      path: "assets/entypo/#{@props.icon}.svg"
      className: 'svg-icon'
    elems.push R.span {className: 'button-text'}, this.props.children if this.props.children?

    R.button {onClick: @props.onClick}, elems

module.exports = IconButton
