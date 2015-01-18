Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'
DB = require '../services/NeDbService'
fs = require 'fs'
async = require 'async'
Path = require 'path'
config = require '../config'
TreeUtils = require '../utils/TreeUtils'
_ = require 'lodash'

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
  selectedDir: null
  currentPhotos: []

  DB: new DB
  init: ->
    @DB.getPhotos().then (data) =>
      console.log 'Photos in db: ', data.length
      @photos = data
      @currentPhotos = data[0..30]
      @trigger()

    @dirsFromDB()

    @listenTo Actions.scan, -> @scan()

    @listenTo Actions.selectDirectory, (dir) ->
      @currentPhotos = @photos.filter (item) -> item.dir is dir
      @selectedDir = dir
      @trigger()

    @listenTo Actions.addDirectoryToLibrary, (dirs) ->
      @scanningPaths = _.uniq(@scanningPaths.concat(dirs).sort())
      @trigger()

    @listenTo Actions.removeDirectoryFromLibrary, (path) ->
      @scanningPaths = _.without @scanningPaths, path
      @trigger()

  dirsFromDB: ->
    @DB.getDirs().then (data) =>
      console.log 'dirs in db: ', data.length
      console.log data[0...5]

      dirTree =  TreeUtils.buildTree _.sortBy(data,'path'), null, null, 'name'

      newTree = TreeUtils.transform dirTree, (item) ->
        # console.log item.name

        item.count = item.items.length + item.items.reduce (prev, current) ->
          prev + (current.count ? 0)
        ,0
        item.unrecognizedCount = (item.unrecognizedCount ? 0) + item.items.reduce (prev, current) ->
          prev + (current.unrecognizedCount ? 0)
        ,0

        item.deepFilesCount = if item.files?.length? then item.files.length else 0
        item.deepFilesCount += item.items.reduce (prev, current) ->
          prev + (current.deepFilesCount ? 0)
        ,0

      console.log data
      console.log 'new Tree'

      console.log newTree

      @dirTree = newTree
      @trigger()

  dirToDB: (dir) ->
    dbRec = {}
    for field of dir
      dbRec[field] = dir[field] unless field in ['items']
    @DB.addDir dbRec # {path: dir.path, added: new Date()}

  photoToDB: (photo) ->
    # @DB.getPhoto(photo.path + 'adf').then (data) ->
    #   return if data?
    @DB.addPhoto photo
    # console.log 'todb', photo
      # @photos.push photo

  scan: ->
    @files = 0
    @scannedFiles = 0
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
            dirObject.parent.items.push dirRecord
          else
            @dirs.push dirRecord
      @files++

    processFile = (fileObject) =>
      @photoToDB fileObject
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
                    dir: dirPath
                    path: filePath
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
