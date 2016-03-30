
$ ->
  # init foundation
  $(document).foundation()

  # init galleries
  $('.gallery').each initGallery

  # init sticky
  $('.top-bar, .title-bar').each initSticky

  # init contact form
  $('.contact-form').each initContactForm

initContactForm = ->
  onFormSubmit = (event) ->
    unless event.isDefaultPrevented()
      event.preventDefault()
      form.addClass 'submit'
      data = {}
      data[x.name] = x.value for x in form.find 'input, textarea' when x.name
      ajax = $.ajax url,
        data: JSON.stringify data
        method:'POST'
      ajax.success onAjaxSuccess
      ajax.error onAjaxError
  onAjaxSuccess = ->
    form.removeClass 'submit'
    form.addClass 'success'
    form[0].reset()
  onAjaxError = (error) ->
    form.removeClass 'submit'
    form.addClass 'error'
    console?.log error
  onButtonClick = ->
    form.removeClass 'error success'
  url = 'https://nk3twh47gh.execute-api.us-east-1.amazonaws.com/prod/contact'
  form = $ @
  form.on 'submit', onFormSubmit
  form.on 'click', '[type=button]', onButtonClick

initSticky = ->
  onWindowScroll = ->
    top = win.scrollTop()
    sticky = top > 0
    elem.toggleClass 'sticky', sticky
  elem = $ @
  win = $ window
  win.on 'scroll', onWindowScroll

initGallery = ->
  updateLayout = ->
    gallery.masonry 'layout'
  gallery = $ @
    .masonry()
    .imagesLoaded()
    .progress updateLayout
