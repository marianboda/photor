$ = require 'jquery-browserify'
fs = require 'fs'

path = '/Volumes/HardDrive/Music/PostRock/'
fs.readdir(path, (err, list)->
  $('#con').html($('#con').html() + list.join '<br>')
)
