$(document).ready(function(){
  $('input[type=radio][name=page_token]').change(function() {
    window.location.href = "http://localhost:3000/page_filter?page_id="+this.value;
  });
  $.datetimepicker.setDateFormatter({
      parseDate: function (date, format) {
          var d = moment(date, format);
          return d.isValid() ? d.toDate() : false;
      },
      formatDate: function (date, format) {
          return moment(date).format(format);
      },
  });  
  $('#datetimepicker').datetimepicker({
        format:'DD/MM/YYYY h:mm a',
      minDate: Date()
  });

});

