Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'
DB = require '../services/NeDbService'
fs = require 'fs'
async = require 'async'
Path = require 'path'

dataStore =
  scanningPaths: [
    "#{process.env.HOME}/temp/raw/aaa/ccc/eee"
    # "#{process.env.HOME}/temp"
  ]
  scannedFiles: 0
  totalFiles: 0
  photos: []
  dirs: []
  files: 0

  processingTree: {}

  DB: new DB
  init: ->
    @DB.getPhotos().then (data) =>
      # console.log data.length
      @photos = data[0..30]
      @trigger()

    # @DB.getDirs().then (data) =>
    #   console.log 'dirs in db: ', data.length
    #   @dirs = data[0..30]
    #   @trigger()

    @listenTo Actions.scan, ->
      console.log 'listened'
      @scan()

  dirToDB: (dir) ->
    @DB.addDir dir # {path: dir.path, added: new Date()}

  photoToDB: (photo) ->
    @DB.getPhoto(photo.path + 'adf').then (data) ->
      return if data?
      @DB.addPhoto photo
      # @photos.push photo

  scan: ->
    @files = 0
    console.log 'SCANNING STARTED'
    dirTree =
      name: 'TEMP'
      items: []
    getSubtree = (path) ->
      parts = path.split(Path.sep)
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


    scanDir = (dir, callback) ->
      fs.readdir dir, (err, list) ->
        # console.log "#{dir} DONE!!", list

    processDir = (dirObject) =>
      path = dirObject.path
      parentPath = if dirObject.parent? then dirObject.parent.path else null
      walkQueue.push path,
        # (err, dirRecord) => @dirToDB(dirRecord)
        (err, dirRecord) =>
          if dirObject.parent?
            console.log 'dirOb', dirObject
            dirObject.parent.items.push dirRecord
          else
            @dirs.push dirRecord

          console.log dirRecord, parentPath
      @files++

    processFile = (fileObject) =>
      # @photoToDB fileObject
      @scannedFiles++
      # @trigger({})

    walkQueue = async.queue (dirPath, callback)->
      fs.readdir dirPath, (err, files) ->
        thisDir = {path: dirPath, files: [], dirs: [], items:[]}
        async.each files,
          (f, callback) ->
            filePath = dirPath + Path.sep + f
            fs.lstat filePath, (err, stat) ->
              if stat.isDirectory()
                thisDir.dirs.push f
                processDir
                  path: filePath
                  parent: thisDir
              if stat.isFile()
                thisDir.files.push f
              callback()
        , (err) ->
          callback(err, thisDir)
    ,2

    walkQueue.drain = =>
      console.log "Q DONE: " + @files, @dirs


    @scanningPaths.map (item) -> processDir {path: item}

    # scanDir(process.env.HOME + '/temp')

    # file.walk process.env.HOME + '/temp', (err, path, dirs, files) =>
    #   current =
    #     directFilesCount: 0
    #     # totalFilesCount: 0
    #     # directUnrecognizedCount: 0
    #     # totalFilesCount: 0
    #
    #   currentDir = getSubtree path
    #   for f in files
    #     currentDir.items.push {name: f.split('/').pop(), key: f, items: []}
    #     current.directFilesCount += 1
    #     @photoToDB {path: f}
    #     @scannedFiles++
    #
    #   @dirToDB
    #     path: path
    #     directFilesCount: current.directFilesCount
    #
    #   @data = I.Map dirTree
    #   @trigger({})

  data: I.Map {name: '_blank', items: []}

module.exports = Reflux.createStore dataStore
