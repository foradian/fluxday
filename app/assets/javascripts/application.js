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
//= require foundation
//= require turbolinks
//= require jquery.turbolinks
//= require bootstrap-notify
//= require select2
//= require cocoon
//= require_tree .

$(function(){ $(document).foundation(); });


function infiniteScroll() {
    if ($('.scroll-loop').size() > 0) {
        return $('.scroll2watch').on('scroll', function (e) {
            var load_more_url;
            load_more_url = $(e.target).find('a.next_page').attr('href');
            if (load_more_url && $(e.target).find('.paginator').height() - $(e.target).closest('.scroll2watch').scrollTop() - 60 < $(e.target).closest('.scroll2watch').height()) {
                $(e.target).find('.pagination').html('loading...');
                $.getScript(load_more_url);
            }
            return;
        });
    }
}