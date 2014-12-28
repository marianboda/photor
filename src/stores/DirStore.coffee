Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'

console.log 'DirStore INITIALIZATION -------'

dataStore =
  init: ->
    console.log 'dataStore initializing'
    @listenTo Actions.scan, ->
      console.log 'listened'
      @scan()

  scan: ->
    console.log 'SCANNING STARTED'
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
          if item.name is p
            found = i
            break
        if found is -1
          current.items.push {name: p, key: path, items: []}
          found = current.items.length-1
        current = current.items[found]
      current

    file.walk process.env.HOME + '/temp', (a, b, dirs, files) =>
      currentDir = getSubtree b
      for f in files
        currentDir.items.push {name: f.split('/').pop(), key: f, items: []}
      @data = I.Map dirTree

  data: I.Map {name: 'default', items: [{name: '1', items: [{name: '1.1', items: []}]}]}

module.exports = Reflux.createStore dataStore
