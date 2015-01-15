React = require 'react'
fs = require 'fs'
Flux = require 'flux'
Reflux = require 'reflux'
I = require 'immutable'
Q = require 'q'
file = require 'file'
Router = require 'react-router'


config = require './config'
# TreeNode = require './components/TreeNode'
# Tree = require './components/Tree'
ProcessService = require './services/ProcessService'
dirStore = require './stores/DirStore'
PageStore = require './stores/PageStore'
Actions = require './actions'

Dispatcher = new Flux.Dispatcher()
Route = Router.Route
R = React.DOM
console.log PageStore
# PageStore.init()


App = React.createClass
  displayName: 'App'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo PageStore, -> @forceUpdate()
  render: ->
    console.log 'rendering App: ', location.hash
    R.div {},
      R.div {className: 'main_nav'},
        R.a {href: '#/'+slug, key: slug, className: if slug is location.hash[2..] then 'active' else ''}, p.name for slug, p of PageStore.pages
      R.div {className: 'main_content'},
        React.createElement Router.RouteHandler, React.__spread({},  this.props)

PageStore.listen (status) ->
  routes =
    React.createElement Route, {name: 'app', path: '/', handler: App},
      React.createElement(Route, {name: p.slug, path: '/'+p.slug, handler: p.page, key: p.slug}) for key, p of PageStore.pages
  Router.run routes, (Handler, state) ->
    React.render React.createElement(Handler, {params: state.params}), document.body



window.onload = ->
