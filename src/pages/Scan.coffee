Page = React.createClass
  displayName: 'SubPage'
  render: ->
    console.log 'subpage props', @props
    React.DOM.div {},
      React.DOM.h3 {}, 'SUBPAGE: ' + @props.params.id
      React.createElement TreeNode,
        collapsed: false
        items: treeDataStore.data.get('items')
        name: treeDataStore.data.get('name')

module.exports = Page
