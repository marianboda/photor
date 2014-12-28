home = process.env.HOME
st = require './stores/DirStore'

module.exports =
  PREVIEW_PATH: "#{home}/Documents/Photor/preview"
  THUMB_PATH: "#{home}/Documents/Photor/thumb"
  DB_PATH: "#{home}/Documents/Photor/db"
