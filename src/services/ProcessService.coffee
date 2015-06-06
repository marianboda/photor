'use strict'

async = require 'async'
Q = require 'q'
MediaProcess = require './MediaProcessService'
DB = require './NeDbService'

class ProcessService
  _queue: null

  constructor: ->
    qF = (task, callback) =>
      @_process task, ->
        console.log '%cprocessing done', 'color: #F60; font-weight: bold;'
        callback null

    @_queue = async.queue qF, 2
    @_queue.drain = -> console.log '%cALL DONE', 'color: #F60; font-weight: bold;'

  queue: (record) ->
    defer = Q.defer()
    @_queue.push record, (err) ->
      return defer.reject(err) if err?
      defer.resolve(record)
    defer.promise

  killQueue: -> @_queue.kill()

  updateRecord: (record, cb) ->
    DB.updatePhoto(record).then (res) ->
      cb res

  _process: (task, cb) ->
    initWaterfall = (cb) -> cb(null, task)
    onDone = (err) ->
      console.log 'waterfall done', err
      cb()

    async.waterfall [
      initWaterfall
      MediaProcess.hash
      MediaProcess.exif
      MediaProcess.preview
      MediaProcess.thumb
      @updateRecord
    ], onDone

module.exports = new ProcessService()
