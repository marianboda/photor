Object.assign = require 'object-assign'

_ = require 'lodash'
DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
DirStore = require '../stores/DirStore'
FixedDataTable = require 'fixed-data-table'
Table = FixedDataTable.Table
Column = FixedDataTable.Column

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

  render: ->

    rowGetter = (index) -> _.extend {index: index}, DirStore.photos[index]

    tableProps =
      rowGetter: rowGetter
      headerHeight: 50
      height: @state.tableHeight
      width: @state.tableWidth
      rowsCount: DirStore.photos.length
      rowHeight: 28

    R.div {ref: 'processPage'},
      React.createElement Table, tableProps,
        React.createElement Column,
          {label: '#', cellRenderer: ((a,b,c,index) -> R.span {}, index+1), width: 50, align: 'right'}
        React.createElement Column, {label: 'PATH', dataKey: 'path', width: 750}

module.exports = Page
