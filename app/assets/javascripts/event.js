$(function(){
  $("#add_event_date").click(function() {
    $("#event_date_area").append("<br/>")
    debugger
    $("#event_date_area").append($("input[name='event_form[event_dates_text]']")[0]);
  });
});
