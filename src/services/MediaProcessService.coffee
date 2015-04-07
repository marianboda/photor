'use strict'

Utils = require '../utils/Utils'

class MediaProcessService
  init: () ->

  hash: (record, cb) ->
    # change to immutable
    return record unless record.path?
    Utils.md5File(record.path).then (data) ->
      record.md5 = data
      console.log 'md5', record.md5
      cb null, record

module.exports = new MediaProcessService()
