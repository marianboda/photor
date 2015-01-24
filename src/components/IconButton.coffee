React = require 'react'
R = React.DOM
Types = React.PropTypes
# _ = require 'lodash'
SVG = React.createFactory require('react-svg')


IconButton = React.createClass
  displayName: 'IconButton'

  propTypes: ->
    icon: Types.string
  #   persistKey: Types.string
  #   selectedItem: Types.string
  #   collapsed: Types.bool
  #   nodeRenderer: Types.element

  # getInitialState: ->
  #   collapsed: false

  # clickHandler: (e) ->
  #   @props.onClick?(e)
  #   @forceUpdate()

  render: ->
    elems = [
      SVG
        path: "assets/entypo/#{@props.icon}.svg"
        className: 'svg-icon'
    ]
    elems.push R.span {className: 'button-text'}, this.props.children if this.props.children?
    R.button {onClick: @props.onClick},
      elems
      # SVG
      #   path: "assets/entypo/#{@props.icon}.svg"
      #   className: 'svg-icon'
      # R.span {className: 'button-text'}, this.props.children


module.exports = IconButton
