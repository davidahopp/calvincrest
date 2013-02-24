$(function(){


  $('.left-nav .menu li').mouseover(function(){
    $(this).addClass('active')
  })
  $('.left-nav .menu li').mouseout(function(){
    $(this).removeClass('active')
  })

  var title = $('#body_content_title').html()
  if(title == "Home"){
    $('#body_content_title').html("")
  }


})