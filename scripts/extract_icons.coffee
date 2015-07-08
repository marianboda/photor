fs = require 'fs'
Path = require 'path'
x2j = require 'xml2js'
_ = require 'lodash'
async = require 'async'
parser = x2j.Parser()


dir = '../app/assets/entypo/'
output = '../app/assets/icons.js'

# path = dir + file

getShape = (path, cb) ->
  fs.readFile path, (err, data) ->
    return cb(null, null) if err?
    parser.parseString data, (err, res) ->
      return cb(null, null) if err?
      return cb(null, null) unless res? and res.svg? and res.svg.path?
      paths = res.svg.path.map (i) -> i.$.d
      cb null, {id: Path.basename(path, '.svg'), paths: paths}


collectIcons = (dir, cb) ->
  fs.readdir dir, (err, files) ->
    return cb(err) if err?
    async.map files, (i, icb) ->
      getShape dir + i, icb
    , cb


collectIcons dir, (err, res) ->
  return err if err?
  reduced = res.reduce (a,b) ->
    return a if b is null
    # console.log 'a, b: ', a, b
    n = {}
    n[b.id] = b.paths
    _.extend a, n
  , {}
  fs.writeFile output, 'module.exports = '+JSON.stringify(reduced), (err) ->
    console.log 'done'
