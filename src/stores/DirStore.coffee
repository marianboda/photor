Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'
DB = require '../services/NeDbService'

console.log 'DirStore INITIALIZATION -------'

dataStore =
  scannedFiles: 0
  totalFiles: 0
  photos: []
  dirs: []
  DB: new DB
  init: ->
    console.log 'dataStore initializing'
    @DB.getPhotos().then( (data) =>
      console.log data.length
      @photos = data[0..20]
      @trigger()
    )
    @DB.getDirs().then( (data) =>
      @dirs = data
      @trigger()
    )
    @listenTo Actions.scan, ->
      console.log 'listened'
      @scan()
  dirToDB: (dir) ->
    @DB.addDir {path: dir, added: new Date()}
  photoToDB: (photo) ->
    @DB.getPhoto(photo.path + 'adf').then (data) ->
      return if data?
      @DB.addPhoto photo
      # @photos.push photo
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
      @dirToDB b
      currentDir = getSubtree b
      for f in files
        currentDir.items.push {name: f.split('/').pop(), key: f, items: []}
        @photoToDB {path: f}
        @scannedFiles++
      @data = I.Map dirTree
      @trigger({})

  data: I.Map {name: 'default', items: [{name: '1', items: [{name: '1.1', items: []}]}]}

module.exports = Reflux.createStore dataStore
