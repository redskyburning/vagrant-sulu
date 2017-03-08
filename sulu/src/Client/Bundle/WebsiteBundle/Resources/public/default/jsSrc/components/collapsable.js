$(document).ready(function() {
    var collapsedClass = 'is-collapsed';

    $('.collapsable__expander').click(function(e){
        e.preventDefault();
        $('.collapsable').addClass(collapsedClass);
        $(this).parent().removeClass(collapsedClass);
    });

    $('.collapsable__collapser').click(function(e){
        e.preventDefault();
        $(this).parent().addClass(collapsedClass);
    });
});