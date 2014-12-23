React = require 'react'
TreeNode = require './tree'
dirStore = require './stores/DirStore'
fs = require 'fs'
Flux = require 'flux'
Dispatcher = new Flux.Dispatcher()
Router = require 'react-router'
Route = Router.Route
I = require 'immutable'

DefPage = require './pages/Home'

ScanPage = require './pages/Scan'

App = React.createClass
  displayName: 'App'
  render: ->
    console.log 'rendering App: ', location.hash
    React.DOM.div {},
      React.DOM.h1 {}, 'App Head1'
      React.DOM.a {href: '#/'}, 'Ins'
      React.DOM.span {}, ' '
      React.DOM.a {href: '#/sub/33'}, 'Inside2'
      React.DOM.hr {}
      React.createElement Router.RouteHandler, React.__spread({},  this.props)

routes =
  React.createElement Route, {name: 'app', path: '/', handler: App},
    React.createElement Route, {name: 'scan', path: 'scan', handler: ScanPage}
    React.createElement Route, {name: 'sub', path: 'sub', handler: ScanPage},
      React.createElement Route, {name: 'detail', path: ':id', handler: ScanPage}
    React.createElement Router.DefaultRoute, {handler:DefPage}

window.onload = ->
  fs.readdir '/users/marianboda/temp/', (err, files) ->
    console.log 'read some shit', err, files
  Router.run routes, (Handler, state) ->
    console.log 'state', state
    React.render React.createElement(Handler, {params: state.params}), document.getElementById('content')
  console.log 'some shit happened'
