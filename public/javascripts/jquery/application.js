// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
    $("#jq_jobfeed span a").live("click", function () {
        $.getScript(this.href);
        return false;
    });
});



