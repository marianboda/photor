DB = require 'nedb'
$q = require 'q'

db =
  dir: new DB {filename: "#{DB_PATH}/dirs.nedb", autoload: true}
  photo: new DB {filename: "#{DB_PATH}/photos.nedb", autoload: true}

db.dir.ensureIndex {fieldName: 'path', unique: true}, (err) ->
  console.error err if err?

class DbService
  constructor: ->
    console.log 'DbService started'
  getSome: ->
    console.log 'gettin some'

  addDir: (dir) ->
    db.dir.find {path: dir.path}, (err, rec) ->
      db.dir.insert dir, (err, rec) ->
        console.error err if err?

  getPhoto: (path) ->
    defer = $q.defer()
    db.photo.findOne {path:path}, (err, rec) ->
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
      if err?
        console.error err
        return defer.reject err
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
