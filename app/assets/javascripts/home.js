$(document).ready(function(){
  $('input[type=radio][name=page_token]').change(function() {
    window.location.href = "http://localhost:3000/page_filter?page_id="+this.value;
  });  

});

