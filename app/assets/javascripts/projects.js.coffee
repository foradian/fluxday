# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(document).on "page:change", ->
#  alert "page has loaded!"

$(document).on "page:change", ->
  $('select').select2({'width':'100%'});
  $('.time-field').timepicker({ 'step': 15 });
  $('.date-input').datetimepicker();
#  $('.dates-input').fdatetimepicker({
#    weekStart: 1,
#    todayHighlight: true,
#    autoclose: true
#    })
  $('.month-calendar-field').fdatepicker({'show','weekStart':0})


$(document).foundation tab:
  callback: (tab) ->