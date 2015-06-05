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

    R.div {onClick: @props.onClick}, "-#{@props.icon}-"
      # R.svg
      #   width: 24
      #   height: 24
      #   viewBox: "0 0 20 20"
      # ,
      #   R.path
      #     d: "M12.496,17.414c-0.394-1.096-1.805-4.775-2.39-6.297c-1.103,0.737-2.334,1.435-3.512,1.928c-0.366,1.28-1.094,3.709-1.446,4.033c-0.604,0.557-0.832,0.485-0.925-0.279c-0.093-0.764-0.485-3.236-0.485-3.236s-2.162-1.219-2.84-1.568s-0.667-0.591,0.057-0.974c0.422-0.223,2.927-0.085,4.242,0.005c0.861-0.951,1.931-1.882,2.993-2.679C6.975,7.271,4.04,4.672,3.156,3.923C2.38,3.265,3.235,3.126,3.235,3.126c0.39-0.07,1.222-0.132,1.628-0.009c2.524,0.763,6.442,2.068,7.363,2.376c0.353-0.249,0.737-0.52,1.162-0.821c4.702-3.33,5.887-2.593,6.111-2.27s0.503,1.701-4.199,5.032c-0.425,0.301-0.808,0.573-1.16,0.823c-0.029,0.98-0.157,5.151-0.311,7.811c-0.025,0.428-0.367,1.198-0.565,1.544C13.263,17.612,12.841,18.377,12.496,17.414z"

      # SVG
      #   path: "assets/entypo/#{@props.icon}.svg"
      #   className: classes.join ' '

module.exports = Icon
