Path = require 'path'
Q = require 'q'
exec = require('child_process').exec

class Utils
  @getExt: (path) ->
    Path.extname(path)[1..].toLowerCase()

  @getOrientCommand: (num) -> [
      ''
      ''
      '-flop'
      '-rotate 180'
      '-flip'
      '-flip -rotate 90'
      '-rotate 90'
      '-flop -rotate 90'
      '-rotate 270'
    ][num]

  @md5File: (path) ->
    crypto = require 'crypto'

    fd = fs.createReadStream path
    hash = crypto.createHash 'md5'
    hash.setEncoding 'hex'
    defer = Q.defer()

    fd.on 'end', ->
      hash.end()
      hashString = hash.read()
      # console.log hashString
      defer.resolve hashString

    fd.pipe(hash)
    defer.promise

  @exif: (path, callback) ->
    exec "exiftool -n -j \"#{path}\"", (e,so,se) ->
      result = if se > 0 then {} else JSON.parse(so)[0]
      callback null, result

  @isVideo: (path, callback) -> @getExt(path) in ['mp4', 'avi', 'mov', '3gp']

module.exports = Utils
