"use strict"
fs = require 'fs'
gm = require 'gm'
$q = require 'q'
mkdirp = require 'mkdirp'
async = require 'async'
exec = require('child_process').exec
_ = require 'lodash'
DbService = require './NeDbService'
config = require '../config'
Utils = require '../utils/Utils'

fs.exists config.PREVIEW_PATH, (exists) ->
  mkdirp config.PREVIEW_PATH, (e, dir) ->
    console.error 'error creating dir: ' + dir, e if e
fs.exists config.THUMB_PATH, (exists) ->
  mkdirp config.THUMB_PATH, (e, dir) ->
    console.error 'error creating dir: ' + dir, e if e

getPrevPath = (photo) -> "#{config.PREVIEW_PATH}/#{photo.hash[0...16]}.jpg"
getThumbPath = (photo) -> "#{config.THUMB_PATH}/#{photo.hash[0...16]}.jpg"

class ProcessService
  CONCURENCY: 8
  _queue: null

  constructor: ->
    @_queue =
      async.queue (task, callback) =>
        @_process(task).then ->
          # console.log 'task done: '+task.path
          callback()
        , (err) -> callback err
        , (notify) -> console.info notify
      ,@CONCURENCY

  queue: (photo) ->
    defer = $q.defer()
    @_queue.push photo, (err) ->
      defer.reject(err) if err?
      defer.resolve(photo)
    defer.promise

  killQueue: ->
    @_queue.kill()

  processPhoto: (photo, callback) ->
    async.series [
      (callback) => @exif(photo).then (data) ->
        photo.exif = data
        callback null, data

      (callback) => @preview(photo).then (data) ->
        callback null, data
      , (err) ->
        console.error 'rejected preview somehow ',err
        photo.preview = false
        callback null, photo

      (callback) => @thumb(photo).then (data) ->
        callback null, data
      , (err) ->
        photo.thumb = false
        console.error err
        callback null, photo

    ], (err) ->
      if err?
        console.error 'queue error', err
        callback err
      callback null

  processVideo: (file, callback) ->
    async.series [
      (callback) => @videoThumb file, callback

      (callback) => @thumb(file).then (data) ->
        callback null, data
      , (err) ->
        file.thumb = false
        console.error err
        callback null, photo

    ], (err) ->
      callback(err)

  videoThumb: (photo, callback) ->
    previewPath = getPrevPath photo
    thumbPath = getThumbPath photo
    previewSize = config.PREVIEW_SIZE
    thumbSize = config.THUMB_SIZE
    cmd = "ffmpeg -an -i #{photo.path} -vframes 1 -s 320x240 #{previewPath}"
    console.info cmd
    exec cmd, (e,so,se) ->
      console.log 'we gettin somewhere'
      if (e? and e isnt '' and e isnt 0)
        _.assign(photo, {status: 'unrecognized'})
        console.error e
        return callback(e)
      callback(null, photo)

  _process: (photo) ->
    # console.log '%cPROCESSING FILE: %c'+ photo.path, 'color: gray', 'color: green'
    defer = $q.defer()
    async.series [
      # (callback) => @dbFind(photo).then (data) ->
      #   callback(null, data)
      # ,(err) -> console.log 'chyba'; defer.reject("#{photo.path} already in DB"); callback "#{photo.path} in DB";
      (callback) => @md5(photo).then (data) ->
        photo.hash = data
        defer.notify 'md5 done'
        console.log 'md5 done'
        callback null, data

      (callback) =>
        if Utils.getExt(photo.path) in ['mp4', 'avi', 'mov', '3gp']
          @processVideo photo, callback
        else
          @processPhoto photo, callback
        console.log 'ph/vid this one done'

      (callback) => @save(photo).then (data) ->
        defer.notify 'save done'
        console.log 'here???? '
        callback null, data
    ], (err) ->
      if err?
        console.error 'queue error', err
        defer.reject err

      defer.resolve('all done: '+photo.path)

    defer.promise

  dbFind: (photo) ->
    defer = $q.defer()
    photo = if _.isString(photo) then photo else photo.path
    DbService.getPhoto(photo.path).then (data) ->
      if data is null
        defer.resolve(null)
      else
        console.log 'exists in DB'
        defer.reject 'error, already in DB'
    defer.promise

  md5: (photo) -> Utils.md5File(photo)

  exif: (photo, callback) ->
    exec "exiftool -n -j \"#{photo.path}\"", (e,so,se) ->
      result = if se > 0 then {} else JSON.parse(so)[0]
      callback null, result

  preview: (photo) ->
    defer = $q.defer()
    if not photo.hash
      defer.reject()
      return defer.promise

    previewPath = getPrevPath photo

    if Utils.getExt(photo.path) is 'cr2'
      cmd = "exiftool -b -PreviewImage \"#{photo.path}\" > #{previewPath}"
      exec cmd, (e, so, se) ->
        orient = photo.exif.Orientation ? 1
        if orient is 1
          defer.resolve ''
          return
        exec "gm mogrify #{getOrientCommand orient} #{previewPath}", ->
          # previewResizeQueue.push task
          defer.resolve ''
    else
      cmd = "cp \"#{photo.path}\" #{previewPath}"
      exec cmd, (e, so, se) ->
        # console.error 'e', e, 'so', so, 'se', se if se
        defer.resolve ''

    defer.promise

  thumb: (photo) ->
    defer = $q.defer()
    previewPath = getPrevPath photo
    thumbPath = getThumbPath photo
    previewSize = config.PREVIEW_SIZE
    thumbSize = config.THUMB_SIZE
    exec "gm mogrify -resize #{previewSize}x#{previewSize}\\> \"#{previewPath}\"", (e,so,se) ->
      if (se? and se isnt '' and se isnt 0) or (e? and e isnt '' and e isnt 0)
        console.error "mogrify (s)error #{e} #{se} #{so} #{photo.path}"
        # return defer.reject 'mogrify error'
        return defer.resolve _.assign(photo, {status: 'unrecognized'})
      exec "gm convert -resize #{thumbSize}x#{thumbSize}\\> \"#{previewPath}\" \"#{thumbPath}\"", (e,so,se) ->
        if (e? and e isnt 0 and e isnt '') or (se? and se isnt '' and se isnt 0)
          console.error "convert (s)error #{e} #{se} #{so}"
          # return defer.reject 'convert error'
          return defer.resolve _.assign(photo, {status: 'unrecognized'})
        defer.resolve(photo)
    defer.promise

  save: (photo) ->
    # console.log 'saving '+photo.path
    DbService.updatePhoto(photo)

module.exports = new ProcessService()
