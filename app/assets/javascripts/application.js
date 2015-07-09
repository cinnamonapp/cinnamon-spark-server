// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require jquery.autocomplete.js
//= require circle-progress
//= require_tree .


$(document).ready(function () {

  $('[data-method]').click(function(e){
    e.preventDefault();
    e.stopPropagation();

    var record_path = $(this).attr('href');

    var container = $(this).parents("tr");

    console.log(container);

    if(confirm("Are you sure?")){
      console.log(record_path);
      $.ajax({
          url: record_path + ".json",
          type: 'DELETE',
          success: function(result) {
              // Do something with the result
              console.log("Successfully deleted.");
              container.fadeOut(500, function() { $(this).remove(); });
          }
      });
    }

  });
});
