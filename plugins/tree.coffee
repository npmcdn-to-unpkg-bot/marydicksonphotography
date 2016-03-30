path = require 'path'

module.exports = (options) ->
  ###
  builds up a tree/folder and attaches it to each file.
  ###
  (files, metalsmith, done) ->
    tree = {}
    Object.keys files
      .forEach (file) ->
        name = path.basename file
        data = files[file]
        data.path = file
        data.tree = tree
        data.folder =
          path.dirname file
            .split path.sep
            .filter (x) -> x.length
            .reduce (y, x) ->
              y[x] ?= { '..': y }
              y[x][name] = data
              y[x]
            , tree
    done()
