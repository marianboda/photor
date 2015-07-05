SQL = require 'sqlite3'
config = require '../config'
db = new SQL.Database "#{config.DB_PATH}/db.sqlite"
isjs = require 'is-js'

class SQLiteService
  addScanningPath: (path) ->
    db.run 'INSERT OR IGNORE INTO scanning_path (path) VALUES ("'+path+'")'

  removeScanningPath: (path) ->
    db.run 'DELETE FROM scanning_path WHERE path="'+path+'"'

  getScanningPaths: (cb) ->
    db.all 'SELECT * FROM scanning_path', cb

  addIgnorePath: (path) ->
    db.run 'INSERT OR IGNORE INTO ignore_path (path) VALUES ("'+path+'")'

  removeIgnorePath: (path) ->
    db.run 'DELETE FROM ignore_path WHERE path="'+path+'"'

  getIgnorePaths: (cb) ->
    db.all 'SELECT * FROM ignore_path', cb

  addDir: (dir) ->
    keys = ['path', 'name', 'filesCount', 'deepFilesCount', 'deepUnrecognizedCount']
    vals = keys.map (i) -> "\"#{dir[i]}\""
    db.run "INSERT OR IGNORE INTO dir (#{keys.join(',')}) VALUES (#{vals.join(',')})"

  getDirs: (cb) ->
    db.all 'SELECT * FROM dir ORDER BY path', cb

  getFiles: (cb) ->
    db.all 'SELECT * FROM file ORDER BY path', cb

  addFile: (file, cb) ->
    keys = Object.keys(file)
    vals = keys.map (i) ->
      val = file[i]
      val = JSON.stringify(val) if isjs.object(val)
      val
    q = "INSERT OR IGNORE INTO file (#{keys.join(',')}) VALUES (#{keys.map( -> '?').join(',')})"
    db.run q, vals, cb

  updateFile: (file, cb) ->
    console.log 'file.id', file.id
    # return cb()
    keys = Object.keys(file).filter (i) -> i isnt 'id'
    vals = keys.map (i) ->
      val = file[i]
      val = JSON.stringify(val) if isjs.object(val)
      val
    keyValues = keys.map (i) -> "#{i}=?"
    q = "UPDATE file SET #{keyValues.join(', ')} WHERE id=" + file.id
    db.run q, vals, cb
module.exports = new SQLiteService()
