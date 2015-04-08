'use strict'

async = require 'async'
Q = require 'q'
MediaProcess = require './MediaProcessService'

class ProcessService
  _queue: null

  constructor: ->
    qF = (task, callback) =>
      @_process(task, -> callback null)
    @_queue = async.queue qF, 2

  queue: (record) ->
    defer = Q.defer()
    @_queue.push record, (err) ->
      return defer.reject(err) if err?
      defer.resolve(record)
    defer.promise

  killQueue: -> @_queue.kill()

  _process: (task, cb) ->
    console.log 'task ', task

    initWaterfall = (cb) -> cb(null, task)
    onDone = (err) ->
      console.log 'waterfall done', err
      cb()

    async.waterfall [
      initWaterfall
      MediaProcess.hash
      MediaProcess.exif
      MediaProcess.photoPreview
      MediaProcess.thumb
    ], onDone

module.exports = new ProcessService()
