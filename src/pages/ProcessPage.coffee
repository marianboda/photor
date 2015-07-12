Object.assign = require 'object-assign'

_ = require 'lodash'
DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
Button = require '../components/IconButton'

Page = React.createClass
  displayName: 'ProcessPage'
  mixins: [Reflux.ListenerMixin]

  getInitialState: ->
    tableWidth: 700
    tableHeight: 700

  componentDidMount: ->
    if this.refs.processPage
      console.log 'width', this.refs.processPage.getDOMNode().offsetWidth
    @_update()
    @listenTo DirStore, @forceUpdate
    window.addEventListener 'resize', @_onResize

  componentWillUnmount: ->
    window.removeEventListener 'resize', @_onResize

  _onResize: ->
    clearTimeout @_updateTimer
    @_updateTimer = setTimeout @_update, 16

  _update: ->
    @setState
      tableWidth: this.refs.processPage.getDOMNode().offsetWidth
      tableHeight: 400 #this.refs.processPage.getDOMNode().offsetHeight

  processButtonHandler: (e) -> Actions.process()

  render: ->
    rowGetter = (index) -> _.extend {index: index}, DirStore.photos[index]

    rows = Math.min DirStore.photos.length, 20
    items = []
    if rows > 0
      for i in [0..rows]
        item = R.div {},
          R.span {}, DirStore.photos[i].name + ' ' + DirStore.photos[i].path
        items.push item

    R.div {ref: 'processPage', className: 'process-page'},
      R.div {className: 'content'}, items
      R.div {className: 'bottom-bar'},
        React.createElement Button, {icon: 'eye', onClick: @processButtonHandler}
        React.createElement Button, {icon: 'cross', onClick: -> Actions.stopProcess()}
        R.span {}, "TOTAL FILES: #{DirStore.photos.length}"
        R.progress {value: DirStore.processedFiles, max: DirStore.photos.length, style: {width: '100%'}}

module.exports = Page
