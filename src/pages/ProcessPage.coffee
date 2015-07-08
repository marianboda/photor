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
    @listenTo DirStore, -> @forceUpdate()
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

  processButtonHandler: (e) ->
    Actions.process()

  render: ->
    rowGetter = (index) -> _.extend {index: index}, DirStore.photos[index]

    tableProps =
      rowGetter: rowGetter
      headerHeight: 50
      height: @state.tableHeight
      width: @state.tableWidth
      rowsCount: DirStore.photos.length
      rowHeight: 28

    rows = Math.min DirStore.photos.length, 50
    items = []
    if rows > 0
      for i in [0..rows]
        item = R.div {},
          R.span {}, DirStore.photos[i].name + ' ' + DirStore.photos[i].path
        items.push item

    R.div {ref: 'processPage'},
      # React.createElement Table, tableProps,
      #   React.createElement Column,
      #     {label: '#', cellRenderer: ((a,b,c,index) -> R.span {}, index+1), align: 'right'}
      #   React.createElement Column, {label: 'PATH', dataKey: 'path', width: 600}
      #   # React.createElement Column, {label: 'DIR', dataKey: 'dir', width: 200}
      #   React.createElement Column, {label: 'HASH', dataKey: 'hash', width: 50}

      R.h2 {}, "TOTAL FILES: #{DirStore.photos.length}"
      R.div {}, items

      React.createElement Button, {icon: 'eye', onClick: @processButtonHandler}
      React.createElement Button, {icon: 'cross', onClick: -> Actions.stopProcess()}
      R.progress {value: DirStore.processedFiles, max: DirStore.photos.length, style: {width: '100%'}}

module.exports = Page
