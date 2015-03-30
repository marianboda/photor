'use strict'

async = require 'async'
Q = require 'q'

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
    async.waterfall [
      (cb) -> cb(null, task)
      (task, cb) -> cb(null, console.log 'task f 1')
      (task, cb) -> cb(null, console.log 'task f 2')
    ], done

    done = (task, err) ->
      console.log 'waterfall done', err
      cb()

module.exports = new ProcessService()
