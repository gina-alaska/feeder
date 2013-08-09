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
    ImageChooser.highlight(el) if el?
    
    if $(el).hasClass('entry-page')
      ImageChooser.update(url)
    else
      ImageChooser.currentRequest = $.ajax({ url: url, dataType: 'script' })
      ImageChooser.currentRequest.complete -> 
        $('abbr.timeago').timeago()
        ImageChooser.currentRequest = null
        $('#image-viewer').spin(false);
        
    ImageChooser.currentRequest
  
  next: ->
    # el = $('[data-action="switch-image"]').last()
    # $(el).click() unless $(el).hasClass('disabled')
    el = $('.entries-chooser .active').next()
    if $(el).hasClass('header')
      el = $(el).next()
      
    $(el).find('a').click() unless $(el).hasClass('disabled')

  prev: ->
    # el = $('[data-action="switch-image"]').first()
    # $(el).click() unless $(el).hasClass('disabled')
    el = $('.entries-chooser .active').prev()
    if $(el).hasClass('header')
      el = $(el).prev()
      
    $(el).find('a').click() unless $(el).hasClass('disabled')
  
  update: (url) ->
    $.ajax({ url: url, dataType: 'script' }).complete ->
      $('#image-viewer').spin(false);
    
  highlight: (el) ->
    if $(el).length != 0
      $('.entries-chooser .active').removeClass('active')
      $(el).addClass('active')
      top = $(el).offset().top
      parentTop = $('.entries-chooser').offset().top
      scrolled = $('.entries-chooser').scrollTop() - 50
      $('.entries-chooser').animate({ scrollTop: (top - parentTop + scrolled) }, 100)
    else
      false
}

$(document).on 'click', '[data-action="next"]', (evt) ->
  evt.preventDefault()
  ImageChooser.next()

$(document).on 'click', '[data-action="prev"]', (evt) ->
  evt.preventDefault()
  ImageChooser.prev()

$(document).on 'click', '[data-action="resize"]', (evt) ->
  ImageChooser.preview($(this).data('url'))
  $(this).parent().find('.active').removeClass('active')
  $(this).addClass('active')
  
$(document).on 'click', '[data-action="load-image"]', (evt) ->
  evt.preventDefault()
  
  ImageChooser.preview($(this).attr('href'), $(this).parent())
  # ImageChooser.highlight(this)
  
$(document).on 'click', '[data-action="switch-image"]', (evt) ->
  if $('.entries-chooser') 
    evt.preventDefault()
    ImageChooser.preview($(this).attr('href'), $(this).data('highlight'))
    # ImageChooser.highlight($(this).data('highlight'))
    