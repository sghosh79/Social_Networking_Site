$(document).on "ready page:load", ->
  $(document).on "click", ".accept", ->
    window.location.replace $(this).data("url")
