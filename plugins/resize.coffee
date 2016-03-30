
minimatch = require 'minimatch'
async = require 'async'
gm = require 'gm'
  .subClass imageMagick:yes

module.exports = (files, metalsmith, done) ->
  ###
  Creates a function that resizes images
  ###
  landscape = options?.landscape or [640, 480]
  portrait = options?.portrait or [480, 640]
  quality = options?.quality or 0
  rules = (options?.rules or ['*.jpg'])
    .map (x) ->
      minimatch.filter x,
        matchBase: yes

  (files, metalsmith, done) ->
    keys = Object.keys files
    tasks = rules
      .reduce (a, f) ->
        a.concat keys.filter f
      , []
      .map (file) ->
        data = files[file]
        photo = gm data.contents, file
        async.apply async.waterfall, [
          (next) -> photo.size next
          (size, next) ->
            [width, height] =
              if size.width > size.height
                landscape
              else portrait
            data.size = { width, height }
            photo
              .resize width, height, '^'
              .crop width, height
              .gravity 'center'
              .quality quality
              .toBuffer 'JPG', next
          (buffer, next) ->
            console.log "#{ file } resized."
            data.contents = buffer
            next()
        ]
    async.parallel tasks, done
