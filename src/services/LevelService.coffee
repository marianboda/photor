level = require 'level'

config = require '../config'

db = level "#{config.DB_PATH}/db.level"
console.log 'works :)'

class LevelService
  constructor: -> console.log 'constructing leveldb'

module.exports = new LevelService()
