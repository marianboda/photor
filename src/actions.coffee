Reflux = require 'reflux'

module.exports =
  scan: Reflux.createAction()
  process: Reflux.createAction()
  selectDirectory: Reflux.createAction()
  addDirectoryToLibrary: Reflux.createAction()
  removeDirectoryFromLibrary: Reflux.createAction()
  addIgnorePath: Reflux.createAction()
  removeIgnorePath: Reflux.createAction()
