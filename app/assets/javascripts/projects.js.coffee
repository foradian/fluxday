# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(document).on "page:change", ->
#  alert "page has loaded!"

$(document).on "page:change", ->
  $(document).foundation();
  $('select').not('.select_add').select2({'width':'100%'});
#  $('.select_add').multiSelect({});
  $('.time-field').timepicker({ 'step': 15 });
  $('.date-input').datetimepicker();
  $('.date-only-input').datetimepicker({timepicker:false,format:'Y-m-d'});
  $('textarea').autosize();
#  $('.dates-input').fdatetimepicker({
#    weekStart: 1,
#    todayHighlight: true,
#    autoclose: true
#    })
  $('.month-calendar-field').fdatepicker({'show','weekStart':0}).on "changeDate", (ev) ->
    $.get("/calendar/day.js?date="+ev.date.getFullYear()+'-'+("0" + (ev.date.getMonth() + 1)).slice(-2)+'-'+("0" + ev.date.getDate()).slice(-2));
#  $(".sortable-table").tablesorter();

$(document).foundation tab:
  callback: (tab) ->