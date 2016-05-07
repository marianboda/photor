'use strict'

async = require 'async'
Q = require 'q'
MediaProcess = require './MediaProcessService'
DB = require './NeDbService'
DBS = require './SQLiteService'

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

  pause: ->
    console.log "Pause"
    @_queue.pause()

  resume: ->
    console.log "Resume"
    @_queue.resume()

  updateRecord: (record, cb) ->
    r = record
    if (r.status > -1)
      r.status = 1
    DBS.updateFile r, (res) ->
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
