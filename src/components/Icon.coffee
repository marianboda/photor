React = require 'react'
R = React.DOM
Types = React.PropTypes
# SVG = React.createFactory require('react-svg')
iconShapes = require '../../app/assets/icons.js'

Icon = React.createClass
  displayName: 'Icon'

  propTypes: ->
    icon: Types.string
    classes: Types.array

  render: ->
    classes = ['svg-icon']
    classes = classes.concat @props.classes if @props.classes?
    paths = iconShapes[@props.icon] ? iconShapes.aircraft
    svgProps =
      width: 20
      height: 20
      viewBox: "0 0 20 20"
      className: classes.join(' ')

    svgContent = paths.map (i) -> R.path({fill: "#bada55", d: i})
    R.div {onClick: @props.onClick},
      R.svg svgProps, svgContent

module.exports = Icon
