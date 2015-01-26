home = process.env.HOME

module.exports =
  PREVIEW_PATH: "#{home}/Documents/photorData/preview"
  THUMB_PATH: "#{home}/Documents/photorData/thumb"
  DB_PATH: "#{home}/Documents/photorData"
  ACCEPTED_FORMATS: [
    'jpg'
    'jpe'
    'jpeg'
    'tif'
    'tiff'
    'cr2'
    'mov'
    'mp4'
  ]
  PREVIEW_SIZE: 2048
  THUMB_SIZE: 600
