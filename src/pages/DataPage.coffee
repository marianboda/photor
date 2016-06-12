DirStore = require '../stores/DirStore'
React = require 'react'
R = React.DOM
Reflux = require 'reflux'
Tree = require '../components/Tree'
DirNodeRenderer = require '../components/DirNodeRenderer'
Actions = require '../actions'
config = require '../config'
Element = React.createElement
Thumb = require '../components/Thumb'

Page = React.createClass
  displayName: 'DataPage'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo DirStore, -> @forceUpdate()

  treeItemClickHandler: (event) ->
    Actions.selectDirectory(event)

  fileSelectHandler: (id) ->
    console.log('file select', id)
    Actions.selectFile(id)

  fileDoubleClickHandler: (p) ->
    console.log('fileClickHandler', p)
    Actions.openFile(p)

  render: ->
    exifStr = DirStore.selectedPhoto?.exif
    exif = if exifStr? then JSON.parse(exifStr) else null
    R.div {className: 'datapage-container'},
      R.div {className: 'datapage-toolbar'},
        R.select {}, DirStore.cameras.map (i) =>
          R.option {}, i.name

      R.div {className: 'datapage-content'},
        R.div {id: 'left-panel'},
          React.createElement Tree,
            selectedItem: DirStore.selectedDir
            onClick: @treeItemClickHandler
            data: DirStore.dirTree
            persistKey: 'dirTree'
            nodeRenderer: DirNodeRenderer
        R.div {id: 'right-content'},
          R.div {style:{flex: '0 0'}}, [
            R.button {onClick: -> Actions.process(true)}, 'PROCESS'
            DirStore.selectedDir
          ]
          R.div {className: 'photo-container'},
            for item,i in DirStore.currentPhotos
              thumbSrc = if item.hash? \
                then "file://#{config.THUMB_PATH}/#{item.hash[0..1]}/#{item.hash[0..19]}.jpg"
                else undefined
              handler = ((i) => () => @fileDoubleClickHandler(i))(item.path)
              selectHandler = ((i) => () => @fileSelectHandler(i))(item.id)

              Element Thumb,
                src: thumbSrc
                name: item.name
                onDoubleClick: handler
                onClick: selectHandler
                path: item.path
                selected: item.id is DirStore.selectedId
        R.div {id: 'right-panel', style: {width: 200}},
          'NAME: ' + DirStore.selectedPhoto?.name
          R.br {}
          'LENGTH: ' + exif?.Duration?.toFixed(2) + ' s'
          R.br {}
          R.pre {}, DirStore.selectedPhoto?.copies?.map((i) => i.path).join("\n")


module.exports = Page
