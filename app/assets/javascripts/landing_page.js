//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require fancybox/jquery.fancybox
//= require jquery_cycle2
//= require jquery_cycle2_center.min

//= require theme-script
//= require social-share-button

$(window).load( function() {
  $('#myslideshow1').smoothSlides({
    effectModifier: 1
  });
});

$(document).on("click", "#openModalBtn", function (e) {
  var _self = $(this);
  var name= _self.data('name');
  var text= _self.data('text');
  $("h4.modal-title").replaceWith("<h4 class='modal-title'>" + name + "</h4>");
  $("p.modal-info").replaceWith("<p class='modal-info'>" + text + "</p>");
  $("img.modal-image").attr( 'src', _self.data('image'));
});

function validate() {
  var sender_email = document.getElementById('invite_sender_email');
  var receiver_email = document.getElementById('invite_receiver_email');
  var subject = document.getElementById('invite_subject');
  var body = document.getElementById('invite_body');
  var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  
  if( sender_email.value == "" && receiver_email.value == "" && subject.value == "" && body.value == "")
  {
    $("#all_stuff").text("All fields are required");
    return false;
  }

  if( sender_email.value == "" )
  {
    $("#sender_email").text("This field is required");
    return false;
  }
  
  if (!filter.test(sender_email.value)) {
    $("#sender_email").text("invalid email format");
    return false;
  }

  if( receiver_email.value == "" )
  {
    $("#sender_email").text("");
    $("#receiver_email").text("This field is required");
    return false;
  }

  if (!filter.test(receiver_email.value)) {
    $("#sender_email").text("");
    $("#receiver_email").text("invalid email format");
    return false;
  }

  if( subject.value == "" )
  {
    $("#sender_email").text("");
    $("#receiver_email").text("");
    $("#subject").text("This field is required");
    return false;
  }

  if( body.value == "" )
  {
    $("#sender_email").text("");
    $("#receiver_email").text("");
    $("#subject").text("");
    $("#body").text("This field is required");
    return false;
  }
  return( true );
}
