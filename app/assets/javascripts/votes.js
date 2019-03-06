$(document).on('turbolinks:load', function(){
  $('.rate .voting').on('ajax:success', function(e){
    var data = e.detail[0];
    var voteClass = '.' + data.klass + '-' + data.id
    $(voteClass + ' .rating').html('rating: ' + data.rating);
    $(voteClass + ' .voting').addClass('hidden');
    $(voteClass + ' .revote-link').removeClass('hidden');
   })

  $('.revote').on('ajax:success', function(e){
    var data = e.detail[0];
    var voteClass = '.' + data.klass + '-' + data.id
    $(voteClass + ' .rating').html('rating: ' + data.rating);
    $(voteClass + ' .revote-link').addClass('hidden');
    $(voteClass + ' .voting').removeClass('hidden');
   })
});
