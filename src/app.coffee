React = require 'react'
TreeNode = require './tree'
fs = require 'fs'
Flux = require 'flux'
Dispatcher = new Flux.Dispatcher()
Router = require 'react-router'
Route = Router.Route
I = require 'immutable'
Q = require 'q'
file = require 'file'

ProcessService = require './services/ProcessService'
DefPage = require './pages/Home'
ScanPage = require './pages/Scan'
dirStore = require './stores/DirStore'

App = React.createClass
  displayName: 'App'
  render: ->
    console.log 'rendering App: ', location.hash
    React.DOM.div {},
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
  Router.run routes, (Handler, state) ->
    React.render React.createElement(Handler, {params: state.params}), document.body
