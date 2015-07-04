level = require 'level'

config = require '../config'

db = level "#{config.DB_PATH}/db.level"

class LevelService
  constructor: -> console.log 'constructing leveldb'
  # addDir: (dir) ->
  #   db.dir.find {path: dir.path}, (err, rec) ->
  #     return if rec.length > 0
  #     db.dir.insert dir, (err, rec) ->
  #       console.error err if err?
module.exports = new LevelService()
