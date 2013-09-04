$(document).on 'click', '[data-action="stash"]', (evt) ->
  evt.preventDefault()
  target = $(this).data('target')
  console.log(target, $(target).parents('form'))
  console.log($(this).data('value'))
  $(target).val($(this).data('value'))
  $(target).parents('form').submit()
  