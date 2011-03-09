document.observe("dom:loaded", function() {
  $$('.permission_manage').each(function(pm) {
    pm.observe('click', function(event) {  
      use_permission_clicked(event.element())
    });
    use_permission_clicked(pm)
  });

  function use_permission_clicked(obj) {
    var controller = obj.id.split('_')[1]
    var disabled_val = obj.checked ? 'disabled' : false;
    $('permission_' + controller + '_read').disabled = disabled_val;
    $('permission_' + controller + '_create').disabled = disabled_val;
    $('permission_' + controller + '_update').disabled = disabled_val;
    $('permission_' + controller + '_destroy').disabled = disabled_val;
  }
});

