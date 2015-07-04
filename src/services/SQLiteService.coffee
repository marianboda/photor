SQL = require 'sqlite3'
config = require '../config'
humps = require 'humps'
db = new SQL.Database "#{config.DB_PATH}/db.sqlite"

# db.serialize ->

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
    keys = ['path', 'name', 'files_count', 'deep_files_count', 'deep_unrecognized_count']
    vals = keys.map (i) -> "\"#{dir[humps.camelize(i)]}\""
    db.run "INSERT OR IGNORE INTO dir (#{keys.join(',')}) VALUES (#{vals.join(',')})"

module.exports = new SQLiteService()
