React = require 'react'
TreeNode = require './app/tree'
treeData = require './app/treeData'
fs = require 'fs'
Flux = require 'flux'
Dispatcher = new Flux.Dispatcher()
I = require 'immutable'


window.onload = ->
  fs.readdir '/users/marianboda/temp/', (err, files) ->
    console.log 'read some shit', err, files

  console.log 'some shit happened'
  tree = React.render React.createElement(TreeNode, treeData),
    document.getElementById('content')
