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
      @photos = data
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
    @DB.addDir {path: dir.path, files: dir.directFilesCount, added: new Date()}

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

    file.walk process.env.HOME + '/temp', (err, path, dirs, files) =>
      current =
        directFilesCount: 0
        # directUnrecognizedCount: 0
        # totalFilesCount: 0

      currentDir = getSubtree path
      for f in files
        currentDir.items.push {name: f.split('/').pop(), key: f, items: []}
        current.directFilesCount += 1
        @photoToDB {path: f}
        @scannedFiles++

      @dirToDB
        path: path
        directFilesCount: current.directFilesCount

      @data = I.Map dirTree
      @trigger({})

  data: I.Map {name: '_blank', items: []}

module.exports = Reflux.createStore dataStore
