DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
DirStore = require '../stores/DirStore'
# FixedDataTable = require 'fixed-data-table'
# Table = FixedDataTable.Table
# Column = FixedDataTable.Column

Page = React.createClass
  displayName: 'ProcessPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  render: ->

    rowGetter = (index) ->
      {a: 3, name: 'Sranda'}

    files = DirStore.photos.map (item) ->
      R.tr {},
        R.td {}, item.name
        R.td {}, 'lala'


    R.div {},
      R.h3 {}, 'PROCESS'
      R.hr {}
      R.table {},
        R.tbody {},
          R.tr {},
            R.th {}, 'name'
            R.th {}, '--'
          files

      # React.createElement Table, {rowGetter: rowGetter}
      #   React.createElement Column,


module.exports = Page
