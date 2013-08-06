# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('.legal_entity').hide()
	type = $('#user_type')
	$('#individual').click ->
		$(".individual").hide()
		$(".legal_entity").show()
	$('#legal_entity').click ->
		$(".individual").show()
		$(".legal_entity").hide()
	$('input[cda-data-type="date"]').datepicker({ dateFormat: "yy-mm-dd" });
	errors: { status: "error", errors: { name: ["required"], email: ["duplicated"], city_id: ["invalid"], phone: ["invalid_format"] } }