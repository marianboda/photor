Reflux = require 'reflux'
I = require 'immutable'
Actions = require '../actions'
DB = require '../services/NeDbService'
fs = require 'fs'
async = require 'async'
Path = require 'path'
config = require '../config'
_ = require 'lodash'

fileStore =
  unprocessedFiles: 0
  processedFiles: 0

  init: ->
    loadFiles

  loadFiles: ->
    @DB.getPhotos().then (data) =>
      console.log 'Photos in db: ', data.length
      @photos = data
      @trigger()


module.exports = Reflux.createStore fileStore
