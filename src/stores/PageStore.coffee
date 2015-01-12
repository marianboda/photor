Reflux = require 'reflux'
fs = require 'fs'

store =
  pages: {}
  defaultPage: null
  init: ->
    fs.readdir './src/pages', (err, files) =>
      for f in files
        match = f.match /^([A-Za-z]+)Page\.coffee/
        continue unless match?
        name = match[1]
        page =
          name: name
          file: f
          page: require '../pages/'+name+'Page'
          slug: (name.charAt(0).toLowerCase() +
            name.slice(1)).replace(/([A-Z])/g, '-$1').toLowerCase()

        @pages[page.slug] = page
      @defaultPage = @pages['home']
      @trigger({})

      # console.log 'pages ', @pages

module.exports = Reflux.createStore store
