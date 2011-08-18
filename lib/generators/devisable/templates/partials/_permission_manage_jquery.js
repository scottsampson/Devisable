/* 
 *  Devisable -- Permissions Edit-Add Form
 *  route: /roles/:id/edit
 */
(function() { 
 function use_permission_clicked(obj) {
  var controller = $(obj).attr('id').split('_')[1]
  var disabled_val = $(obj).is(':checked');
  $('#permission_' + controller + '_read').attr('disabled',disabled_val);
  $('#permission_' + controller + '_create').attr('disabled',disabled_val);
  $('#permission_' + controller + '_update').attr('disabled',disabled_val);
  $('#permission_' + controller + '_destroy').attr('disabled',disabled_val);
 }
 
 $('.permission_manage').each(function(ind,pm) {
  $('.permission_manage').click(function() {
   use_permission_clicked($(this));
  });    
  use_permission_clicked(pm)
 });
) 
