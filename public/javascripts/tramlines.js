var TramlinesPhotoBrowser = {

  clear: function(target_field) {
    $('#' + target_field + '_id').val('');
    $('#' + target_field + '_preview').html('');
    $('#' + target_field + '_clear').hide();
    return false;
  },

  open: function(target_field) {
    var url = "/ckeditor/images?target_field=" + target_field;
    this.popup( url, 800, 600 );
  },
  
  /**
   * Opens Browser in a popup. The "width" and "height" parameters accept
   * numbers (pixels) or percent (of screen size) values.
   * @param {String} url The url of the external file browser.
   * @param {String} width Popup window width.
   * @param {String} height Popup window height.
   */
  popup : function( url, width, height ) {
    width = width || '80%';
    height = height || '70%';
    if ( typeof width == 'string' && width.length > 1 && width.substr( width.length - 1, 1 ) == '%' )
      width = parseInt( window.screen.width * parseInt( width, 10 ) / 100, 10 );
    if ( typeof height == 'string' && height.length > 1 && height.substr( height.length - 1, 1 ) == '%' )
      height = parseInt( window.screen.height * parseInt( height, 10 ) / 100, 10 );
    if ( width < 640 )
      width = 640;
    if ( height < 420 )
      height = 420;
    var top = parseInt( ( window.screen.height - height ) / 2, 10 ),
      left = parseInt( ( window.screen.width  - width ) / 2, 10 ),
      options = 'location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes' +
        ',width='  + width +
        ',height=' + height +
        ',top='  + top +
        ',left=' + left;
    var popupWindow = window.open( '', null, options, true );
    // Blocked by a popup blocker.
    if ( !popupWindow )
      return false;
    try {
      popupWindow.moveTo( left, top );
      popupWindow.resizeTo( width, height );
      popupWindow.focus();
      popupWindow.location.href = url;
    }
    catch (e) {
      popupWindow = window.open( url, null, options, true );
    }
    return true ;
  },

  setImage: function(target_field, url, imageId) {
    $(target_field + '_id').val(imageId);
    $(target_field + '_preview').html("<img src='" + url + "' />");
    $(target_field + '_clear').show();
  }
  
};
  
$(document).ready(function() {

  // Add click event to .photo_browser_buttons
  $('.photo_browser_button').click(function() {
    TramlinesPhotoBrowser.open($(this).attr('data-target'));
  });

  // Add click event to .photo_browser_clear_links
  $('.photo_browser_clear').click(function() {
    TramlinesPhotoBrowser.clear($(this).attr('data-target'));
  });
  
});

