React = require 'react'
TreeNode = require './app/tree'
treeDataRaw = require './app/treedata'
fs = require 'fs'
Flux = require 'flux'
Dispatcher = new Flux.Dispatcher()
Router = require 'react-router'
Route = Router.Route
I = require 'immutable'

treeData = I.Map treeDataRaw
treeDataStore =
  data: treeData
  token: null

DefPage = React.createClass
  displayName: 'DefPage'
  render: ->
    React.DOM.h3 {}, 'DEFAULT'

SubPage = React.createClass
  displayName: 'SubPage'
  render: ->
    console.log 'subpage props', @props
    React.DOM.div {},
      React.DOM.h3 {}, 'SUBPAGE: ' + @props.params.id
      React.createElement TreeNode,
        collapsed: false
        items: treeDataStore.data.get('items')
        name: treeDataStore.data.get('name')

App = React.createClass
  displayName: 'App'
  render: ->
    React.DOM.div {},
      React.DOM.h1 {}, 'React Head1'
      React.DOM.a {href: '#/'}, 'Ins'
      React.DOM.span {}, ' '
      React.DOM.a {href: '#/sub/33'}, 'Inside2'
      React.createElement Router.RouteHandler, React.__spread({},  this.props)

routes =
  React.createElement Route, {name: 'app', path: '/', handler: App},
    React.createElement Route, {name: 'inside', path: 'inside', handler: SubPage}
    React.createElement Route, {name: 'sub', path: 'sub', handler: SubPage},
      React.createElement Route, {name: 'detail', path: ':id', handler: SubPage}
    React.createElement Router.DefaultRoute, {handler:DefPage}

window.onload = ->
  fs.readdir '/users/marianboda/temp/', (err, files) ->
    console.log 'read some shit', err, files
  Router.run routes, (Handler, state) ->
    console.log 'state', state
    React.render React.createElement(Handler, {params: state.params}), document.getElementById('content')
  console.log 'some shit happened'
  # tree = React.render React.createElement(TreeNode, treeDataStore.data),
  #   document.getElementById('content')
