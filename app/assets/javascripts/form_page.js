//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require jquery_cycle2
//= require jquery_cycle2_center.min

//= require metronic/js/plugins/jquery-validation/js/jquery.validate
//= require metronic/js/plugins/jquery-validation/js/additional-methods

//= require metronic/js/app.min
//= require metronic/js/layout.min
//= require select2
//= require bootstrap-fileinput/bootstrap-fileinput
//= require social-share-button

//= require jquery-repeater/jquery.repeater.min

//= require lodash
//= require moment
//= require bootstrap-datetimepicker

function scroll_to_class(element_class, removed_height) {
	var scroll_to = $(element_class).offset().top - removed_height;
	if($(window).scrollTop() != scroll_to) {
		$('html, body').stop().animate({scrollTop: scroll_to}, 0);
	}
}

function bar_progress(progress_line_object, direction) {
	var number_of_steps = progress_line_object.data('number-of-steps');
	var now_value = progress_line_object.data('now-value');
	var new_value = 0;
	if(direction == 'right') {
		new_value = now_value + ( 100 / number_of_steps );
	}
	else if(direction == 'left') {
		new_value = now_value - ( 100 / number_of_steps );
	}
	progress_line_object.attr('style', 'width: ' + new_value + '%;').data('now-value', new_value);
}

function setup_location_autocomplete(input) {
  var autocomplete = new google.maps.places.Autocomplete(input, {types: ['address']});
  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    function get_type(type) {
      var type = _.find(place.address_components, function(component) {
        return _.includes(component.types, type);
      });
      return type && type.long_name;
    }
    $(input).siblings('.address_line1').val(get_type('street_number') + get_type('route'))
    $(input).siblings('.address_city').val(get_type('locality'))
    $(input).siblings('.address_state').val(get_type('administrative_area_level_1'))
    $(input).siblings('.address_zip').val(get_type('postal_code'))
  });
}

function PrintElem(elem)
{
  var mywindow = window.open('', 'PRINT', '');
  mywindow.document.write('<html><head><title></title>');
  mywindow.document.write('</head><body >');
  mywindow.document.write(document.getElementById(elem).innerHTML);
  mywindow.document.write('</body></html>');
  mywindow.document.close(); // necessary for IE >= 10
  mywindow.focus(); // necessary for IE >= 10*/
  mywindow.print();
  mywindow.close();
  return true;
}

jQuery(document).ready(function() {
  /*
      Form
  */
  $('.f1 fieldset:first').fadeIn('slow');

  $('.f1 input[type="text"], .f1 input[type="password"], .f1 textarea').on('focus', function() {
  	$(this).removeClass('input-error');
  });

  $('form.f1').validate({
    errorElement: "span",
    errorClass: "help-block help-block-error",
    errorPlacement: function(e, r) {
      if (r.is(":checkbox")) {
        e.insertAfter(r.closest(".md-checkbox-list, .md-checkbox-inline, .checkbox-list, .checkbox-inline"))
      } else if (r.is(":radio")) {
        e.insertAfter(r.closest(".md-radio-list, .md-radio-inline, .radio-list,.radio-inline"))
      } else if (r.is(":file")) {
        e.insertBefore(r.closest(".btn"))
      } else {
        e.insertAfter(r)
      }
    },
    highlight: function(e) {
      $(e).closest(".form-group").addClass("has-error")
    },
    unhighlight: function(e) {
      $(e).closest(".form-group").removeClass("has-error")
    },
    success: function(e) {
      e.closest(".form-group").removeClass("has-error")
    }
  });

  // next step
  $('.f1 .btn-next').on('click', function(e) {
    var user_address_line1 = document.getElementById('user_address_line1');
    var user_address_line2 = document.getElementById('user_address_line2');
    var user_address_city = document.getElementById('user_address_city');
    var user_address_state = document.getElementById('user_address_state');
    var user_address_zip = document.getElementById('user_address_zip');

    var alliance_address_line1 = document.getElementById('user_alliance_attributes_address_line1');
    var alliance_address_line2 = document.getElementById('user_alliance_attributes_address_line2');
    var alliance_address_city = document.getElementById('user_alliance_attributes_address_city');
    var alliance_address_state = document.getElementById('user_alliance_attributes_address_state');
    var alliance_address_zip = document.getElementById('user_alliance_attributes_address_zip');


    var business_address_line1 = document.getElementById('user_business_attributes_address_line1');
      
    var business_address_line2 = document.getElementById('user_business_attributes_address_line2');
    var business_address_city = document.getElementById('user_business_attributes_address_city');
    var business_address_state = document.getElementById('user_business_attributes_address_state');
    var business_address_zip = document.getElementById('user_business_attributes_address_zip');



    var church_address_line1 = document.getElementById('user_church_attributes_address_line1');
    var church_address_line2 = document.getElementById('user_church_attributes_address_line2');
    var church_address_city = document.getElementById('user_church_attributes_address_city');
    var church_address_state = document.getElementById('user_church_attributes_address_state');
    var church_address_zip = document.getElementById('user_church_attributes_address_zip');


    if(e.target.id == "individual_form") {
      if( user_address_line1.value == "" && user_address_city.value == "" && user_address_state.value == "" && user_address_zip.value == "") {
          $("#address_line1").text("This field is required");
          // $("#address_line2").text("This field is required");
          $("#city").text("This field is required");
          $("#state").text("This field is required");
          $("#zipcode").text("This field is required");
          return false;
        }
      if( user_address_line1.value == "" ) {
        $("#address_line1").text("This field is required");
        return false;
      }
      // if( user_address_line2.value == "" ) {
      //   $("#address_line1").text("");
      //   $("#address_line2").text("This field is required");
      //   return false;
      // }

      if( user_address_city.value == "" ) {
        $("#address_line1").text("");
        // $("#address_line2").text("");
        $("#city").text("This field is required");
        return false;
      }
      if( user_address_state.value == "" ) {
        $("#address_line1").text("");
        // $("#address_line2").text("");
        $("#city").text("");
        $("#state").text("This field is required");
        return false;
      }
      if( user_address_zip.value == "" ) {
        $("#address_line1").text("");
        // $("#address_line2").text("");
        $("#city").text("");
        $("#state").text("");
        $("#zipcode").text("This field is required");
        return false;
      }
      if(isNaN(user_address_zip.value)) {
        $("#address_line1").text("");
        // $("#address_line2").text("");
        $("#city").text("");
        $("#state").text("");
        $("#zipcode").text("Please use integer");
        return false;
      }
    }

    if(e.target.id == "alliance_form") {
      if( alliance_address_line1.value == ""  && alliance_address_city.value == "" && alliance_address_state.value == "" && alliance_address_zip.value == "") {
          // $("#alliance_address_line1").text("This field is required");
          // $("#alliance_address_line2").text("This field is required");
          // $("#alliance_city").text("This field is required");
          // $("#alliance_state").text("This field is required");
          // $("#alliance_zipcode").text("This field is required");
          $('.alliance-error1').addClass('has-error');
          $('.alliance-error3').addClass('has-error');
          $('.alliance-error4').addClass('has-error');
          $('.alliance-error5').addClass('has-error');

          return false;
        }
      if( alliance_address_line1.value == "" ) {
        // $("#alliance_address_line1").text("This field is required");
        $('.alliance-error').addClass('has-error');
        return false;
      }
      // if( alliance_address_line2.value == "" ) {
      //   // $("#alliance_address_line1").text("");
      //   // $("#alliance_address_line2").text("This field is required");
      //   $('.alliance-error1').removeClass('has-error');
      //   $('.alliance-error2').addClass('has-error');
      //   return false;
      // }

      if( alliance_address_city.value == "" ) {
        // $("#alliance_address_line1").text("");
        // $("#alliance_address_line2").text("");
        // $("#alliance_city").text("This field is required");
        $('.alliance-error1').removeClass('has-error');
        // $('.alliance-error2').removeClass('has-error');
        $('.alliance-error3').addClass('has-error');
        return false;
      }
      if( alliance_address_state.value == "" ) {
        // $("#alliance_address_line1").text("");
        // $("#alliance_address_line2").text("");
        // $("#alliance_city").text("");
        // $("#alliance_state").text("This field is required");
        $('.alliance-error1').removeClass('has-error');
        // $('.alliance-error2').removeClass('has-error');
        $('.alliance-error3').removeClass('has-error');
        $('.alliance-error4').addClass('has-error');
        return false;
      }
      if( alliance_address_zip.value == "" ) {
        // $("#alliance_address_line1").text("");
        // $("#alliance_address_line2").text("");
        // $("#alliance_city").text("");
        // $("#alliance_state").text("");
        // $("#alliance_zipcode").text("This field is required");
        $('.alliance-error1').removeClass('has-error');
        // $('.alliance-error2').removeClass('has-error');
        $('.alliance-error3').removeClass('has-error');
        $('.alliance-error4').removeClass('has-error');
        $('.alliance-error5').addClass('has-error');
        return false;
      }
      if(isNaN(alliance_address_zip.value)) {
        // $("#alliance_address_line1").text("");
        // $("#alliance_address_line2").text("");
        // $("#alliance_city").text("");
        // $("#alliance_state").text("");
        $('.alliance-error1').removeClass('has-error');
        // $('.alliance-error2').removeClass('has-error');
        $('.alliance-error3').removeClass('has-error');
        $('.alliance-error4').removeClass('has-error');
        $("#alliance_zipcode").text("Please use integer");
        return false;
      }
    }


    if(e.target.id == "business_form") {
      if( business_address_line1.value == "" && business_address_city.value == "" && business_address_state.value == "" && business_address_zip.value == "") {
          // $("#business_address_line1").text("This field is required");
          // $("#business_address_line2").text("This field is required");
          // $("#business_city").text("This field is required");
          // $("#business_state").text("This field is required");
          // $("#business_zipcode").text("This field is required");
          $('.business-error1').addClass('has-error');
          // $('.business-error2').addClass('has-error');
          $('.business-error3').addClass('has-error');
          $('.business-error4').addClass('has-error');
          $('.business-error5').addClass('has-error');
          return false;
        }
      if( business_address_line1.value == "" ) {
        // $("#business_address_line1").text("This field is required");
          $('.business-error1').addClass('has-error');
        return false;
      }
      // if( business_address_line2.value == "" ) {
      //   // $("#business_address_line1").text("");
      //   // $("#business_address_line2").text("This field is required");
      //   $('.business-error1').removeClass('has-error');
      //   // $('.business-error2').addClass('has-error');
      //   return false;
      // }

      if( business_address_city.value == "" ) {
        // $("#business_address_line1").text("");
        // $("#business_address_line2").text("");
        // $("#business_city").text("This field is required");
        $('.business-error1').removeClass('has-error');
        // $('.business-error2').removeClass('has-error');
        $('.business-error3').addClass('has-error');
        return false;
      }
      if( business_address_state.value == "" ) {
        // $("#business_address_line1").text("");
        // $("#business_address_line2").text("");
        // $("#business_city").text("");
        // $("#business_state").text("This field is required");
        $('.business-error1').removeClass('has-error');
        // $('.business-error2').removeClass('has-error');
        $('.business-error3').removeClass('has-error');
        $('.business-error4').addClass('has-error');
        return false;
      }
      if( business_address_zip.value == "" ) {
        // $("#business_address_line1").text("");
        // $("#business_address_line2").text("");
        // $("#business_city").text("");
        // $("#business_state").text("");
        // $("#business_zipcode").text("This field is required");
        $('.business-error1').removeClass('has-error');
        // $('.business-error2').removeClass('has-error');
        $('.business-error3').removeClass('has-error');
        $('.business-error4').removeClass('has-error');
        $('.business-error5').addClass('has-error');
        return false;
      }
      if(isNaN(business_address_zip.value)) {
        // $("#business_address_line1").text("");
        // $("#business_address_line2").text("");
        // $("#business_city").text("");
        // $("#business_state").text("");
        $('.business-error1').removeClass('has-error');
        // $('.business-error2').removeClass('has-error');
        $('.business-error3').removeClass('has-error');
        $('.business-error4').removeClass('has-error');
        $("#business_zipcode").text("Please use integer");
        return false;
      }
    }

    if(e.target.id == "church_form") {
      
      if( church_address_line1.value == "" && church_address_city.value == "" && church_address_state.value == "" && church_address_zip.value == "") {
          // $("#church_address_line1").text("This field is required");
          // $("#church_address_line2").text("This field is required");
          // $("#church_city").text("This field is required");
          // $("#church_state").text("This field is required");
          // $("#church_zipcode").text("This field is required");
          $('.church-error1').addClass('has-error');
          // $('.church-error2').addClass('has-error');
          $('.church-error3').addClass('has-error');
          $('.church-error4').addClass('has-error');
          $('.church-error5').addClass('has-error');
          return false;
        }
      if( church_address_line1.value == "" ) {
        // $("#church_address_line2").text("");
        // $("#church_state").text("");
        // $("#church_city").text("");
        // $("#church_zipcode").text("");
        // $("#church_address_line1").text("This field is required");
          $('.church-error1').addClass('has-error');
        return false;
      }
      // if( church_address_line2.value == "" ) {
      //   // $("#church_address_line1").text("");
      //   // $("#church_state").text("");
      //   // $("#church_city").text("");
      //   // $("#church_zipcode").text("");
      //   // $("#church_address_line2").text("This field is required");
      //     $('.church-error1').removeClass('has-error');
      //     $('.church-error2').addClass('has-error');

      //   return false;

      // }

      if( church_address_city.value == "" ) {
        // $("#church_address_line1").text("");
        // $("#church_address_line2").text("");
        // $("#church_state").text("");
        // $("#church_zipcode").text("");
        // $("#church_city").text("This field is required");
          $('.church-error1').removeClass('has-error');
          // $('.church-error2').removeClass('has-error');
          $('.church-error3').addClass('has-error');

        return false;
      }
      if( church_address_state.value == "" ) {
        // $("#church_address_line1").text("");
        // $("#church_address_line2").text("");
        // $("#church_city").text("");
        // $("#church_zipcode").text("");
        // $("#church_state").text("This field is required");
          $('.church-error1').removeClass('has-error');
          // $('.church-error2').removeClass('has-error');
          $('.church-error3').removeClass('has-error');
          $('.church-error4').addClass('has-error');

        return false;
      }
      if( church_address_zip.value == "" ) {
        // $("#church_address_line1").text("");
        // $("#church_address_line2").text("");
        // $("#church_city").text("");
        // $("#church_state").text("");
        // $("#church_zipcode").text("This field is required");
          $('.church-error1').removeClass('has-error');
          // $('.church-error2').removeClass('has-error');
          $('.church-error3').removeClass('has-error');
          $('.church-error4').removeClass('has-error');
          $('.church-error5').addClass('has-error');
        return false;
      }
      if(isNaN(church_address_zip.value)) {
          $('.church-error1').removeClass('has-error');
          // $('.church-error2').removeClass('has-error');
          $('.church-error3').removeClass('has-error');
          $('.church-error4').removeClass('has-error');
          $('.church-error5').removeClass('has-error');
        $("#church_zipcode").text("Please use integer");
        return false;
      }
    }



  	var parent_fieldset = $(this).parents('fieldset');

  	var next_step = true;
    $(parent_fieldset).find('input, select, textarea').each(function(i, el) {
      var valid = $(el).valid();
      next_step = next_step && valid;
    });

  	// navigation steps / progress steps
  	var current_active_step = $(this).parents('.f1').find('.f1-step.active');
  	var progress_line = $(this).parents('.f1').find('.f1-progress-line');
    
  	if( next_step ) {
      var now_value = progress_line.data('now-value');
  		parent_fieldset.fadeOut(400, function() {
  			// change icons
        if (now_value == 61)
          current_active_step.nextAll().last().addClass('active');
        else {
          current_active_step.removeClass('active').addClass('activated').next().addClass('active');
        }
        current_active_step.find('i').removeClass().addClass('fa fa-check');
  			// progress bar
  			bar_progress(progress_line, 'right');
  			// show next step
    		$(this).next().fadeIn();
    		// scroll window to beginning of the form
  			scroll_to_class( $('.f1'), 20 );
    	});
  	}

    $("#address_line1").text("");
    // $("#address_line2").text("");
    $("#city").text("");
    $("#state").text("");
    $("#zipcode").text("");

    $("#alliance_address_line1").text("");
    // $("#alliance_address_line2").text("");
    $("#alliance_city").text("");
    $("#alliance_state").text("");
    $("#alliance_zipcode").text("");

    $("#business_address_line1").text("");
    // $("#business_address_line2").text("");
    $("#business_city").text("");
    $("#business_state").text("");
    $("#business_zipcode").text("");

    $("#church_address_line1").text("");
    // $("#church_address_line2").text("");
    $("#church_city").text("");
    $("#church_state").text("");
    $("#church_zipcode").text("");


  });

  // previous step
  $('.f1 .btn-previous').on('click', function() {
  	// navigation steps / progress steps
  	var current_active_step = $(this).parents('.f1').find('.f1-step.active');
  	var progress_line = $(this).parents('.f1').find('.f1-progress-line');

  	$(this).parents('fieldset').fadeOut(400, function() {
  		// change icons
  		current_active_step.removeClass('active').prev().removeClass('activated').addClass('active');
  		// progress bar
  		bar_progress(progress_line, 'left');
  		// show previous step
  		$(this).prev().fadeIn();
  		// scroll window to beginning of the form
		scroll_to_class( $('.f1'), 20 );
  	});
  });

  // form repeater
  $('.mt-repeater').each(function(){
    $(this).repeater({
      show: function () {
        $(this).slideDown();
        var input = $(this).find('.autocomplete-address')[0];
        if (input) {
          setup_location_autocomplete(input);
        }
        $(this).find(".select2").select2({
          theme: "bootstrap"
        });
      },

      hide: function (deleteElement) {
          $(this).slideUp(deleteElement);
      },

      ready: function (setIndexes) {
      }
    });
  });

	$( ".select2" ).select2({
			theme: "bootstrap"
	});

	$( ".select-region" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

	$( ".select-area-of-interest" ).select2({
    theme: "bootstrap",
		placeholder: "Start Typing..."
	});

	$( ".select-church" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

	$( ".select-employer" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

	$( ".select-alliance" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

	$( ".select-alliance-region" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

  $( ".address_state" ).select2({
    theme: "bootstrap",
    allowClear: true,
    placeholder: "Start Typing..."
  });

  
	$( ".select-alliance-category" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

	$( ".select-business-region" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});
	$( ".select-business-category" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});

	$( ".select-church-region" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});
	$( ".select-church-category" ).select2({
		theme: "bootstrap",
		allowClear: true,
		placeholder: "Start Typing..."
	});
	$( ".select-ad-region" ).select2({
		theme: "bootstrap"
	});

	//--------- Google Places Autocomplete for Address Entry -------------
	$('.autocomplete-address').each(function(i, input) {
		setup_location_autocomplete(input);
	});

	//----------------------- Create/New Step Form -----------------------------

	// $("#step-form-single-day-button").click(function(){
	//     $("#step-form-multi-day-panel").toggle();
	// 		$("#step-form-single-day-i").toggleClass("fa-square-o");
	// 		$("#step-form-single-day-i").toggleClass("fa-check-square-o");
	// });
	//
	// $("#step-form-multi-day-button").click(function(){
	//     $("#step-form-single-day-panel").toggle();
	// 		$("#step-form-multi-day-i").toggleClass("fa-square-o");
	// 		$("#step-form-multi-day-i").toggleClass("fa-check-square-o");
	// });
});

