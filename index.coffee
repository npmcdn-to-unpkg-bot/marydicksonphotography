pe = require 'pretty-error'
pe = new pe
metalsmith = require 'metalsmith'
layouts = require 'metalsmith-layouts'
less = require 'metalsmith-less'
LessAutoPrefixPlugin = require 'less-plugin-autoprefix'
coffee = require 'metalsmith-coffee'
changed = require 'metalsmith-changed'
markdown = require 'metalsmith-markdown'
serve = require 'metalsmith-serve'
resize = require './plugins/resize'
tree = require './plugins/tree'
watch = require 'metalsmith-watch'
prompt = require 'prompt'

prompt.get
  properties:
    mode:
      description: 'What are we doing?'
      default: 'build'
      pattern: /dev|build/
, (err, result) ->

  build = (ms) ->
    ms.use markdown
        tables: yes
      .use coffee()
      .use less
        render:
          plugins:[
            new LessAutoPrefixPlugin
              browsers: ["last 2 versions"]
          ]
      .use tree()
      .use resize()
      .use layouts
        engine: 'jade'

  ms = metalsmith __dirname
    .destination 'output'

  ms = switch result.mode
    when 'dev'
      ms = ms.use watch
        paths:
          "${ source }/**/*": yes
          "layouts/**/*": "**/*.md"
      ms = build ms
      ms = ms.use serve()
    else build ms

  ms.build (err, files) ->
    unless err
      console.log 'metalsmith complete.'
    else console.log pe.render err
