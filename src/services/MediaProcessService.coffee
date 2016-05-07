'use strict'

exec = require('child_process').exec
_ = require 'lodash'
# I = require 'immutable'
mkdirp = require 'mkdirp'
path = require 'path'

Utils = require '../utils/Utils'
config = require '../config'

getPrevPath = (photo) ->
  "#{config.PREVIEW_PATH}/#{photo.hash[0..1]}/#{photo.hash[0..19]}.jpg"
getThumbPath = (photo) ->
  "#{config.THUMB_PATH}/#{photo.hash[0..1]}/#{photo.hash[0..19]}.jpg"

class MediaProcessService
  init: () ->

  hash: (record, cb) ->
    # change to immutable
    return record unless record.path?
    Utils.md5File(record.path).then (data) ->
      record.hash = data
      console.log 'md5', record.hash
      cb null, record

  preview: (record, cb) =>
    if Utils.isVideo(record.path)
      @videoPreview(record,cb)
    else
      @photoPreview(record,cb)

  photoPreview: (record, cb) ->
    return cb 'error: no hash' unless record.hash
    previewPath = getPrevPath record
    mkdirp path.dirname(previewPath)

    if Utils.getExt(record.path) is 'cr2'
      cmd = "exiftool -b -PreviewImage \"#{record.path}\" > #{previewPath} || rm -f #{previewPath}"
      exec cmd, (e, so, se) ->
        orient = record.exif.Orientation ? 1
        return cb(null, record) if orient is 1

        exec "gm mogrify #{Utils.getOrientCommand orient} #{previewPath} || rm -f #{previewPath}", ->
          cb null, record
    else
      cmd = "cp \"#{record.path}\" #{previewPath}"
      exec cmd, (e, so, se) ->
        # console.error 'e', e, 'so', so, 'se', se if se
        cb(null, record)

  thumb: (record, cb) ->
    previewPath = getPrevPath record
    mkdirp path.dirname(previewPath)
    thumbPath = getThumbPath record
    mkdirp path.dirname(thumbPath)

    previewSize = config.PREVIEW_SIZE
    thumbSize = config.THUMB_SIZE
    exec "gm mogrify -resize #{previewSize}x#{previewSize}\\> \"#{previewPath}\" || rm -f #{previewPath}", (e,so,se) ->
      if (se? and se isnt '' and se isnt 0) or (e? and e isnt '' and e isnt 0)
        console.error "mogrify (s)error #{e} #{se} #{so} #{record.path}"

        _.assign(record, {status: -1})
      exec "gm convert -resize #{thumbSize}x#{thumbSize}\\> \"#{previewPath}\" \"#{thumbPath}\"", (e,so,se) ->
        if (e? and e isnt 0 and e isnt '') or (se? and se isnt '' and se isnt 0)
          console.error "convert (s)error #{e} #{se} #{so}"
          _.assign(record, {status: -1})
        cb null, record

  videoPreview: (record, cb) ->
    previewPath = getPrevPath record
    mkdirp path.dirname(previewPath)
    thumbPath = getThumbPath record
    mkdirp path.dirname(thumbPath)
    previewSize = config.PREVIEW_SIZE
    thumbSize = config.THUMB_SIZE
    cmd = "ffmpeg -an -y -i \"#{record.path}\" -vframes 1 -filter:v scale=\"320:-1\" \"#{previewPath}\""
    console.info cmd
    exec cmd, (e,so,se) ->
      console.log so
      if (e? and e isnt '' and e isnt 0)
        _.assign(record, {status: -1})
        console.error e
        return cb(e)
      cb(null, record)

  exif: (record, cb) ->
    Utils.exif record.path, (err, result) ->
      record.exif = result
      cb(null, record)

module.exports = new MediaProcessService()
