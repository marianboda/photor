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
  scanningPaths: []
  ignorePaths: []
  scannedFiles: 0
  photos: []
  dirTree: {name: 'root', items: []}
  files: 0
  selectedDir: null
  currentPhotos: []

  DB: new DB
  init: ->
    @loadScanningPaths()
    @loadIgnorePaths()
    @loadPhotos()
    @loadDirs()

    @listenTo Actions.scan, @scan

    @listenTo Actions.selectDirectory, (dir) ->
      @currentPhotos = @photos.filter (item) -> item.dir is dir
      @selectedDir = dir
      @trigger()

    @listenTo Actions.addDirectoryToLibrary, (paths) ->
      newPaths = _.without(paths, @scanningPaths)
      @scanningPaths = _.uniq(@scanningPaths.concat(newPaths).sort())
      @DB.addScanningPath s for s in newPaths
      @trigger()

    @listenTo Actions.removeDirectoryFromLibrary, (path) ->
      @scanningPaths = _.without @scanningPaths, path
      @DB.removeScanningPath path
      @trigger()

    @listenTo Actions.addIgnorePath, (paths) ->
      newPaths = _.without(paths, @ignorePaths)
      @ignorePaths = @ignorePaths.concat(newPaths).sort()
      @DB.addIgnorePath s for s in newPaths
      @trigger()

    @listenTo Actions.removeIgnorePath, (path) ->
      @ignorePaths = _.without @ignorePaths, path
      @DB.removeIgnorePath path
      @trigger()

  loadPhotos: ->
    @DB.getPhotos().then (data) =>
      console.log 'Photos in db: ', data.length
      @photos = data
      @trigger()

  loadScanningPaths: ->
    @DB.getScanningPaths().then (data) =>
      @scanningPaths = data.map (item) -> item.path
      @trigger()

  loadIgnorePaths: ->
    @DB.getIgnorePaths().then (data) =>
      @ignorePaths = data.map (item) -> item.path
      @trigger()

  loadDirs: ->
    @DB.getDirs().then (data) =>
      console.log 'dirs in db: ', data.length
      @dirTree = TreeUtils.buildTree _.sortBy(data,'path'), null, null, 'name'
      @trigger()

  dirToDB: (dir) ->
    dbRec = {}
    for field of dir
      dbRec[field] = dir[field] unless field in ['items']
    @DB.addDir dbRec # {path: dir.path, added: new Date()}

  photoToDB: (photo) -> @DB.addPhoto photo

  scan: ->
    @scannedFiles = 0
    console.log 'SCANNING STARTED'
    dirs = []

    processDir = (dirObject) =>
      walkQueue.push dirObject.path, (e, ob) -> dirs.push ob

    processFile = (fileObject) =>
      @photoToDB fileObject
      @scannedFiles++
      @trigger()

    ignorePaths = @ignorePaths
    walkQueue = async.queue (dirPath, callback)->
      fs.readdir dirPath, (err, files) ->
        thisDir = {path: dirPath, name: Path.basename(dirPath), files: [], items:[], unrecognizedCount: 0}
        async.each files,
          (f, eachCallback) ->
            filePath = dirPath + Path.sep + f
            fs.lstat filePath, (err, stat) ->
              if stat.isDirectory()
                if filePath not in ignorePaths
                  processDir {path: filePath}
              if stat.isFile()
                if isRecognized(f)
                  thisDir.files.push f
                  processFile {name: f, dir: dirPath, path: filePath, stat: stat}
                else
                  thisDir.unrecognizedCount += 1
              eachCallback()
        , (err) -> callback(err, thisDir)
    ,2

    isRecognized = (item) ->
      Path.extname(item).substring(1).toLowerCase() in config.ACCEPTED_FORMATS

    walkQueue.drain = =>
      console.log "Q DONE: ", dirs
      dirTree = TreeUtils.buildTree dirs, null, null, 'name'

      newTree = TreeUtils.transformPost dirTree, (item) ->
        subCountReducer = (field) ->
          (prev, current) -> prev + (current[field] ? 0)
        sumField = (node, field, initField) ->
          reducer = subCountReducer(field)
          node.items.reduce reducer, (node[initField] ? 0)

        item.filesCount = if item.files?.length? then item.files.length else 0
        item.deepFilesCount = sumField item, 'deepFilesCount', 'filesCount'
        item.deepUnrecognizedCount = sumField item, 'deepUnrecognizedCount', 'unrecognizedCount'

      TreeUtils.traverse newTree, (item) -> console.log item #@DB.addDir
      TreeUtils.traverse newTree, @DB.addDir

      @dirTree = newTree
      console.log @dirTree
      @trigger {}

    @scanningPaths.map (item) -> processDir {path: item}

module.exports = Reflux.createStore dataStore
