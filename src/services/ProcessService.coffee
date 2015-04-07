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

    onDone = (err) ->
      console.log 'waterfall done', err
      cb()

    async.waterfall [
      (cb) -> cb(null, task)
      MediaProcess.hash
      (task, cb) -> cb(null, console.log 'task f 1')
      (task, cb) -> console.log 'task f +2'; cb(null, {path: '~/temp/shit'})
    ], onDone

module.exports = new ProcessService()
