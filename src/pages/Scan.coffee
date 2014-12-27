DirStore = require '../stores/DirStore'
TreeNode = require '../tree'
DB = require '../services/NeDbService'
ProcessService = require '../services/ProcessService'

console.log 'screen SCAN INITIALIZATION ========'

Page = React.createClass
  displayName: 'SubPage'
  render: ->
    React.DOM.div {},
      React.DOM.h3 {}, 'SCAN: ' + @props.params.id
      React.createElement TreeNode,
        items: DirStore.data.get('items') #DirStore.data.get('items')
        name: DirStore.data.get('name') #DirStore.data.get('name')

module.exports = Page
