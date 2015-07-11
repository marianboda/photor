React = require 'react'
fs = require 'fs'
Flux = require 'flux'
Reflux = require 'reflux'
I = require 'immutable'
Q = require 'q'
file = require 'file'
Router = require 'react-router'

config = require './config'
ProcessService = require './services/ProcessService'
dirStore = require './stores/DirStore'
PageStore = require './stores/PageStore'
Actions = require './actions'

Dispatcher = new Flux.Dispatcher()
Route = Router.Route
R = React.DOM

App = React.createClass
  displayName: 'App'
  mixins: [Reflux.ListenerMixin]
  componentDidMount: ->
    @listenTo PageStore, -> @forceUpdate()
  render: ->
    console.log 'rendering App: ', location.hash
    R.div {className: 'app-container'},
      R.div {className: 'main-nav'},
        for slug, p of PageStore.pages
          R.a {href: '#/'+slug, key: slug, className: if slug is location.hash[2..] then 'active' else ''}, p.name
      React.createElement Router.RouteHandler, React.__spread({},  this.props)

PageStore.listen (status) ->
  routes =
    React.createElement Route, {name: 'app', path: '/', handler: App},
      for key, p of PageStore.pages
        React.createElement(Route, {name: p.slug, path: '/'+p.slug, handler: p.page, key: p.slug})
  Router.run routes, (Handler, state) ->
    React.render React.createElement(Handler, {params: state.params}), document.body
