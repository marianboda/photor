Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'
DB = require '../services/NeDbService'
fs = require 'fs'
async = require 'async'
Path = require 'path'


console.log 'DirStore INITIALIZATION -------'

dataStore =
  scanningPaths: [
    "#{process.env.HOME}/temp"
  ]
  scannedFiles: 0
  totalFiles: 0
  photos: []
  dirs: []
  files: 0


  DB: new DB
  init: ->
    console.log 'dataStore initializing'
    @DB.getPhotos().then (data) =>
      console.log data.length
      @photos = data
      @trigger()

    @DB.getDirs().then (data) =>
      @dirs = data
      @trigger()

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
        console.log "#{dir} DONE!!", list

    processDir = (path) =>
      walkQueue.push path,
        (err, dirRecord) => @dirToDB(dirRecord)
      @files++

    processFile = (fileObject) =>
      @photoToDB fileObject
      @scannedFiles++
      # @trigger({})

    walkQueue = async.queue (dirPath, callback)->
      fs.readdir dirPath, (err, files) ->
        console.log '%cdir: ' + dirPath, 'color: #FF6600'
        thisDir =
          path: dirPath
          files: []
          dirs: []


        async.each files,
          (f, callback) ->
            filePath = dirPath + Path.sep + f
            fs.lstat filePath, (err, stat) ->
              if stat.isDirectory()
                thisDir.dirs.push
                  path: filePath
                  stat: stat
                processDir filePath
              if stat.isFile()
                thisDir.files.push
                  # path: dirPath + Path.sep + f
                  name: f
                  stat: stat
                processFile
                  path: dirPath + Path.sep + f
                  name: f
                  dir: dirPath
                  stat: stat
              callback()
        , (err) ->
          console.log '%c ---- ' + dirPath, 'color: #006699'

          callback(err, thisDir)
    ,2

    walkQueue.drain = =>
      console.log "Q DONE: " + @files

    @scanningPaths.map (item) -> walkQueue.push item

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
