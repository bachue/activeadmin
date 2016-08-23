$(document).on 'ready page:load turbolinks:load', ->
  # Clear Filters button
  $('.clear_filters_btn').click ->
    params = window.location.search.slice(1).split('&')
    regex = /^(q\[|q%5B|q%5b|page|commit|saved_filter)/
    window.location.search = (param for param in params when not param.match(regex)).join('&')

  # Filter form: don't send any inputs that are empty
  $('.filter_form').submit ->
    $(@).find(':input').filter(-> @value is '').prop 'disabled', true

  # Filter form: for filters that let you choose the query method from
  # a dropdown, apply that choice to the filter input field.
  $('.filter_form_field.select_and_search select').change ->
    $(@).siblings('input').prop name: "q[#{@value}]"

  # Save Filters button
  $('.save_filters_btn').click ->
    ActiveAdmin.modal_dialog 'Save Filters And Apply', name: 'text', (inputs) =>
      form = $(@).parents('form')
      name_field = $('<input type="hidden" name="name" />').val(inputs.name)
      form.append(name_field)
      data = form.serialize()
      $.ajax
        url: $(@).data('url')
        method: 'POST'
        data: data
        success: (data) ->
          location.href = data.url
        complete: () ->
          name_field.remove()
    false

  $('.sidebar_section ul.saved_filters li a.delete').click ->
    $.ajax
      url: $(@).data('url')
      method: 'POST'
      data: { name: $(@).data('name') }
      success: =>
        $(@).parents('li').slideUp(300, -> $(@).remove())
    false
