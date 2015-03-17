Path = require 'path'

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

module.exports = Utils
