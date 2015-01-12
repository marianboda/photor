Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'
DB = require '../services/NeDbService'
fs = require 'fs'
async = require 'async'
Path = require 'path'
config = require '../config'

dataStore =
  scanningPaths: [
    # "#{process.env.HOME}/temp/raw/aaa/ccc/eee"
    "#{process.env.HOME}/temp"
    # "#{process.env.HOME}"
    # "/Volumes/HardDrive/Foto"
  ]
  scannedFiles: 0
  totalFiles: 0
  photos: []
  dirs: []
  dirTree: {name: 'root', items: []}
  files: 0

  DB: new DB
  init: ->
    @DB.getPhotos().then (data) =>
      # console.log data.length
      @photos = data[0..30]
      @trigger()

    @dirsFromDB()

    @listenTo Actions.scan, ->
      console.log 'listened'
      @scan()

  dirsFromDB: ->
    @DB.getDirs().then (data) =>
      console.log 'dirs in db: ', data.length
      # @dirs = data[0..30]
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
            current.items.push {name: p, items: []}
            found = current.items.length-1
          current = current.items[found]
        current

      for d in data
        console.log d.path, getSubtree(d.path)

      console.log dirTree

      @dirTree = dirTree

      @trigger()


  dirToDB: (dir) ->

    dbRec = {}

    for field of dir
      dbRec[field] = dir[field] unless field in ['items']

    # console.log dbRec

    @DB.addDir dbRec # {path: dir.path, added: new Date()}

  photoToDB: (photo) ->
    @DB.getPhoto(photo.path + 'adf').then (data) ->
      return if data?
      @DB.addPhoto photo
      # @photos.push photo

  scan: ->
    @files = 0
    console.log 'SCANNING STARTED'

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
            # console.log 'dirOb', dirObject
            dirObject.parent.items.push dirRecord
          else
            @dirs.push dirRecord

          # console.log dirRecord, parentPath
      @files++

    processFile = (fileObject) =>
      # @photoToDB fileObject
      # console.log '%csome file sent to process', 'color: #bada55'
      @scannedFiles++
      # @trigger({})

    walkQueue = async.queue (dirPath, callback)->
      fs.readdir dirPath, (err, files) ->
        thisDir = {path: dirPath, name: Path.basename(dirPath), files: [], items:[], unrecognizedCount: 0}
        async.each files,
          (f, callback) ->
            filePath = dirPath + Path.sep + f
            fs.lstat filePath, (err, stat) ->
              if stat.isDirectory()
                # thisDir.dirs.push f
                processDir
                  path: filePath
                  parent: thisDir
              if stat.isFile()
                if isRecognized(f)
                  thisDir.files.push f
                  processFile
                    name: f
                    stat: stat

                else
                  thisDir.unrecognizedCount += 1
              callback()
        , (err) ->
          callback(err, thisDir)
    ,2


    isRecognized = (item) ->
      Path.extname(item).substring(1).toLowerCase() in config.ACCEPTED_FORMATS

    isDirRelevant = (dir) ->
      return dir.deepFilesCount > 0

    processTree = (tree) ->
      processTreeNode = (oldNode, newNode) ->
        newNode.name = oldNode.name
        newNode.path = oldNode.path
        return unless oldNode.items?
        newNode.filesCount = oldNode.files.length
        newNode.deepFilesCount = oldNode.files.length
        newNode.unrecognizedFilesCount = oldNode.unrecognizedCount
        newNode.deepUnrecognizedFilesCount = oldNode.unrecognizedCount
        newNode.items = []
        for item in oldNode.items
          newSubnode = {}
          processTreeNode item, newSubnode
          newNode.deepFilesCount += newSubnode.deepFilesCount
          newNode.deepUnrecognizedFilesCount += newSubnode.deepUnrecognizedFilesCount
          if isDirRelevant(newSubnode)
            newNode.items.push newSubnode

        newNode.name += ' ' + newNode.deepFilesCount
      newTree = {}
      processTreeNode tree, newTree
      # console.log 'newTree', newTree
      newTree

    traverseTree = (node, nodeFunction, callback1) ->
      return unless node.items?

      async.each node.items, (item) ->
        if nodeFunction?
          nodeFunction item
        traverseTree item, nodeFunction
      , (err) ->
        # console.log callback1 if callback1?
        # if callback1?
          # console.log 'all Traversal done'






    walkQueue.drain = =>
      console.log "Q DONE: " + @files
      # @data = I.Map @dirs[0]
      @data = I.Map processTree(@dirs[0])
      @trigger {}

      traverseTree(@dirs[0], @dirToDB, 1)

      @trigger {}



    @scanningPaths.map (item) -> processDir {path: item}


  data: I.Map {name: '_blank', items: []}

module.exports = Reflux.createStore dataStore
