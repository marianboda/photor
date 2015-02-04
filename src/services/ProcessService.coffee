"use strict"
fs = require 'fs'
gm = require 'gm'
$q = require 'q'
async = require 'async'
exec = require 'exec'
_ = require 'lodash'

config = require '../config'

thumbDir = config.THUMB_PATH
getPrevPath = (photo) -> "#{config.PREVIEW_PATH}/#{photo.md5[0...16]}.jpg"
getThumbPath = (photo) -> "#{config.THUMB_PATH}/#{photo.md5[0...16]}.jpg"
getExt = (str) -> str.split('.').pop().toLowerCase()


class ProcessService
  CONCURENCY: 4
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

  queue: (filePath) ->
    photo = path:filePath
    # console.log '%QUEUED FILE: %c'+ filePath, 'color: gray', 'color: orange'
    defer = $q.defer()
    @_queue.push photo, (err) ->
      defer.reject(err) if err?
      defer.resolve(photo)
    defer.promise

  _process: (photo) ->
    # console.log '%cPROCESSING FILE: %c'+ photo.path, 'color: gray', 'color: green'
    defer = $q.defer()
    async.series [
      # (callback) => @dbFind(photo).then (data) ->
      #   callback(null, data)
      # ,(err) -> console.log 'chyba'; defer.reject("#{photo.path} already in DB"); callback "#{photo.path} in DB";
      (callback) => @md5(photo).then (data) =>
        console.log "hash:#{data} %c#{photo.path}", 'color: orange'
        photo.md5 = data
        defer.notify 'md5 done'
        callback null, data
      (callback) => @exif(photo).then (data) ->
        photo.exif = data
        defer.notify 'exif done'
        callback null, data
      (callback) => @preview(photo).then (data) ->
        defer.notify 'preview done'
        callback null, data
      ,(err) ->
        defer.reject(err)
        console.error err
        photo.preview = false
        callback null, photo

      (callback) => @thumb(photo).then (data) ->
        console.log 'are we here or what?'
        defer.notify('thumb done')
        callback null, data
      , (err) ->
        defer.reject(err)
        photo.thumb = false
        callback null, photo

      # (callback) => @save(photo).then (data) ->
      #   defer.notify 'save done'
      #   callback null, data
    ], (err) ->
      console.error err
      defer.reject err if err?

      # console.error 'series callback', err if err?
      # console.log 'all done: '+photo.path
      defer.resolve('all done: '+photo.path)
    , (event) ->
      console.log 'some progress', event

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

  md5: (photo) ->
    crypto = require 'crypto'

    photo =

    fd = fs.createReadStream photo.path
    hash = crypto.createHash 'md5'
    hash.setEncoding 'hex'
    defer = $q.defer()

    fd.on 'end', ->
      hash.end()
      hashString = hash.read()
      console.log hashString
      defer.resolve hashString

    fd.pipe(hash);
    defer.promise

  exif: (photo) ->
    defer = $q.defer()

    exec "exiftool -n -j \"#{photo.path}\"", (e,so,se) ->
      # console.log obj
      defer.resolve JSON.parse(so)[0]
    defer.promise

  preview: (photo) ->
    console.log 'going to get a preview'
    defer = $q.defer()
    if not photo.md5
      defer.reject()
      return defer.promise

    previewPath = getPrevPath photo
    console.log previewPath
    console.log getExt(photo.path)

    if getExt(photo.path) is 'cr2'
      cmd = "exiftool -b -PreviewImage \"#{photo.path}\" > #{previewPath}"
      console.log cmd
      exec cmd, (e, so, se) ->
        console.log e,so,se
        orient = photo.exif.Orientation
        # console.log 'orient is: '+orient
        if orient is 1
          # console.log "orient is one"
          defer.resolve ''
        else
          # console.log "rotating image #{photo.md5}"
          exec "gm mogrify #{getOrientCommand orient} #{previewPath}", ->
            # previewResizeQueue.push task
            defer.resolve ''
    else
      cmd = "cp \"#{photo.path}\" #{previewPath}"
      exec cmd, (e, so, se) ->
        console.error 'e', e, 'so', so, 'se', se if se
        defer.resolve ''

    defer.promise

  thumb: (photo) ->
    defer = $q.defer()
    previewPath = getPrevPath photo
    console.log '%cTHUMBING: '+photo.path, 'color: orange'
    thumbPath = getThumbPath photo
    previewSize = config.PREVIEW_SIZE
    thumbSize = config.THUMB_SIZE
    exec "gm mogrify -resize #{previewSize}x#{previewSize}\\> \"#{previewPath}\"", (e,so,se) ->
      console.log 'here in mogrify', e, so, se
      if e? and e > 0
        console.error "nejaky error #{e}"
        return defer.reject e
      if se? and se isnt '' and se isnt 0
        console.error "nejaky serror #{se}"
        return defer.reject se
      console.log 'here in mogrify', e, so, se
      exec "gm convert -resize #{thumbSize}x#{thumbSize}\\> \"#{previewPath}\" \"#{thumbPath}\"", (e,so,se) ->
        console.log "#{e},#{so},#{se}"
        if e? and e isnt 0 and e isnt ''
          console.error "nejaky errorp #{e}"
          return defer.reject e
        if se? and se isnt '' and se isnt 0
          console.error "nejaky serror #{se}"
          return defer.reject se
        defer.resolve(photo)
    defer.promise

  save: (photo) ->
    # console.log 'saving '+photo.path
    DbService.addPhoto(photo)




module.exports = new ProcessService()
