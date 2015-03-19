Path = require 'path'
$q = require 'q'

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

  @md5File: (photo) ->
    crypto = require 'crypto'

    fd = fs.createReadStream photo.path
    hash = crypto.createHash 'md5'
    hash.setEncoding 'hex'
    defer = $q.defer()

    fd.on 'end', ->
      hash.end()
      hashString = hash.read()
      # console.log hashString
      defer.resolve hashString

    fd.pipe(hash)
    defer.promise

module.exports = Utils
