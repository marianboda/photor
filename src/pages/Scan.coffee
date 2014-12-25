DirStore = require '../stores/DirStore'
TreeNode = require '../tree'

Page = React.createClass
  displayName: 'SubPage'
  render: ->
    console.log 'subpage props', @props
    React.DOM.div {},
      React.DOM.h3 {}, 'SCAN: ' + @props.params.id
      React.createElement TreeNode,
        collapsed: false
        items: DirStore.data.get('items')
        name: DirStore.data.get('name')

module.exports = Page
