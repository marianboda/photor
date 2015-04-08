'use strict'

Utils = require '../utils/Utils'
# I = require 'immutable'
config = require '../config'
exec = require('child_process').exec

getPrevPath = (photo) -> "#{config.PREVIEW_PATH}/#{photo.hash[0...16]}.jpg"
getThumbPath = (photo) -> "#{config.THUMB_PATH}/#{photo.hash[0...16]}.jpg"


class MediaProcessService
  init: () ->

  hash: (record, cb) ->
    # change to immutable
    return record unless record.path?
    Utils.md5File(record.path).then (data) ->
      record.hash = data
      console.log 'md5', record.hash
      cb null, record

  photoPreview: (record, cb) ->
    return cb 'error: no hash' unless record.hash
    previewPath = getPrevPath record

    if Utils.getExt(record.path) is 'cr2'
      cmd = "exiftool -b -PreviewImage \"#{record.path}\" > #{previewPath}"
      exec cmd, (e, so, se) ->
        orient = record.exif.Orientation ? 1
        return cb(null, record) if orient is 1

        exec "gm mogrify #{getOrientCommand orient} #{previewPath}", -> cb null, record
    else
      cmd = "cp \"#{record.path}\" #{previewPath}"
      exec cmd, (e, so, se) ->
        # console.error 'e', e, 'so', so, 'se', se if se
        cb(null, record)

  exif: (record, cb) ->
    Utils.exif record.path, (err, result) ->
      record.exif = result
      cb(null, record)


module.exports = new MediaProcessService()
