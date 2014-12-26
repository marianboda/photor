DirStore = require '../stores/DirStore'
TreeNode = require '../tree'
DB = require '../services/NeDbService'
ProcessService = require '../services/ProcessService'

console.log 'screen SCAN INITIALIZATION ========'

dirTree =
  name: 'TEMP'
  items: []

getSubtree = (path) ->
  parts = path.split('/')
  parts.shift() if parts[0] is ''
  current = dirTree
  for p in parts
    found = -1
    for item, i in current.items
      # console.log item.name, p
      if item.name is p
        found = i
        break
    if found is -1
      current.items.push {name: p, items: []}
      found = current.items.length-1
    current = current.items[found]
  current


file.walk process.env.HOME + '/temp', (a, b, dirs, files) ->
  # console.log 'walk ' + b + ' (' + dirs.length + ', ' + files.length + ')'
  currentDir = getSubtree b
  for f in files
    currentDir.items.push {name: f.split('/').pop(), items: []}
  console.log 'walked', dirTree




Page = React.createClass
  displayName: 'SubPage'
  render: ->
    console.log 'subpage props', @props
    React.DOM.div {},
      React.DOM.h3 {}, 'SCAN: ' + @props.params.id
      React.createElement TreeNode,
        collapsed: false
        items: dirTree.items #DirStore.data.get('items')
        name: dirTree.name #DirStore.data.get('name')

module.exports = Page
