@ImageChooser = {
  init: ->
    $(document).keydown (evt) ->
      switch evt.which
        # when 32
          # spacebar
        when 37
          # left arrow
          ImageChooser.prev()
        when 39
          # right arrow
          ImageChooser.next()
    
  currentRequest: null
  
  preview: (url, el) ->
    return if ImageChooser.currentRequest
      # ImageChooser.currentRequest.abort()

    $('#image-viewer').spin();      
    ImageChooser.currentRequest = $.ajax({ url: url, dataType: 'script' })
    ImageChooser.currentRequest.complete -> 
      $('abbr.timeago').timeago()
      if el? and ImageChooser.highlight(el) == false
        ImageChooser.update(url + '/chooser').complete =>
          ImageChooser.highlight(el)
      ImageChooser.currentRequest = null
        
    ImageChooser.currentRequest
  
  next: ->
    el = $('[data-action="switch-image"]').last()
    $(el).click() unless $(el).hasClass('disabled')

  prev: ->
    el = $('[data-action="switch-image"]').first()
    $(el).click() unless $(el).hasClass('disabled')
  
  update: (url) ->
    $.ajax({ url: url, dataType: 'script' })
    
  highlight: (el) ->
    if $(el).length != 0
      $('.entries-chooser .active').removeClass('active')
      $(el).addClass('active')
      top = $(el).offset().top
      parentTop = $('.entries-chooser').offset().top
      scrolled = $('.entries-chooser').scrollTop() - 40
      $('.entries-chooser').animate({ scrollTop: (top - parentTop + scrolled) }, 100)
    else
      false
}

$(document).on 'click', '[data-action="resize"]', (evt) ->
  ImageChooser.preview($(this).data('url'))
  $(this).parent().find('.active').removeClass('active')
  $(this).addClass('active')
  
$(document).on 'click', '[data-action="load-image"]', (evt) ->
  evt.preventDefault()
  
  ImageChooser.preview($(this).attr('href'), this)
  # ImageChooser.highlight(this)
  
$(document).on 'click', '[data-action="switch-image"]', (evt) ->
  if $('.entries-chooser') 
    evt.preventDefault()
    ImageChooser.preview($(this).attr('href'), $(this).data('highlight'))
    # ImageChooser.highlight($(this).data('highlight'))
    