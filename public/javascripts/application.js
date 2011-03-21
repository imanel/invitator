// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $('nav ul li a:last').addClass('last');
  
	$("#new_invitation_link").overlay({
    effect: 'apple',
		onBeforeLoad: function() {
			var wrap = this.getOverlay().find(".contentWrap");
			wrap.load(this.getTrigger().attr("href") + '.js');
		}
  });
});