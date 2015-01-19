DB = require 'nedb'
$q = require 'q'
fs = require 'fs'
config = require '../config'

db =
  dir: new DB {filename: "#{config.DB_PATH}/dirs.nedb", autoload: true}
  photo: new DB {filename: "#{config.DB_PATH}/photos.nedb", autoload: true}
  scanningPaths: new DB {filename: "#{config.DB_PATH}/scanningPaths.nedb", autoload: true}

db.dir.ensureIndex {fieldName: 'path', unique: true}, (err) ->
  # console.error err if err?
db.photo.ensureIndex {fieldName: 'path', unique: true}, (err) ->
  # console.error err if err?
db.scanningPaths.ensureIndex {fieldName: 'path', unique: true}, (err) ->

class DbService
  constructor: ->
  getSome: ->
    console.log 'gettin some'

  addScanningPath: (path) ->
    db.scanningPaths.insert {path: path}

  getScanningPaths: () ->
    defer = $q.defer()
    db.scanningPaths.find {}, (err, rec) ->
      defer.resolve(rec)
    defer.promise

  addDir: (dir) ->
    db.dir.find {path: dir.path}, (err, rec) ->
      return if rec.length > 0
      db.dir.insert dir, (err, rec) ->
        console.error err if err?

  getPhoto: (path) ->
    defer = $q.defer()
    db.photo.findOne {path:path}, (err, rec) ->
      defer.resolve(rec)
    defer.promise

  getPhotos: ->
    defer = $q.defer()
    db.photo.find {}, (err, rec) ->
      defer.resolve(rec)
    defer.promise

  photoCount: ->
    @recordCount 'photo'

  recordCount: (collection, filter = {}) ->
    defer = $q.defer()
    db[collection].count filter, (err, count) ->
      defer.resolve(count)
    defer.promise

  addPhoto: (photo) ->
    defer = $q.defer()
    db.photo.insert photo, (err, newrec) ->
      # if err?
      #   console.error err
      #   return defer.reject err
      defer.resolve newrec
    defer.promise

  getDirs: () ->
    defer = $q.defer()
    db.dir.find {}, (err, recs) ->
      if err? then defer.reject err else defer.resolve recs
    defer.promise

  cleanAll: () ->
    defer = $q.defer()
    async.parallel [
      (callback) -> db.photo.remove {}, {multi: true}, (err, num) ->
        callback(err, num)
      (callback) -> db.dir.remove {}, {multi: true}, (err, num) ->
        callback(err, num)
    ], (err, results) ->
        if err?
          defer.reject err
        else
          defer.resolve results
    defer.promise

module.exports = DbService
