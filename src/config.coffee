home = process.env.HOME

module.exports =
  PREVIEW_PATH: "#{home}/Documents/photorData/preview"
  THUMB_PATH: "#{home}/Documents/photorData/thumb"
  DB_PATH: "#{home}/Documents/photorData"
  ACCEPTED_FORMATS: [
    'jpg'
    'jpe'
    'jpeg'
    'png'
    'tif'
    'tiff'
    'cr2'
    'mov'
    'mp4'
    'avi'
    '3gp'
  ]
  PREVIEW_SIZE: 800
  THUMB_SIZE: 200
