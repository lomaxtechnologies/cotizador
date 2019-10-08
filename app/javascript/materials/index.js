window.show_confirmation_modal = (element)=>{
   element = $(element);
   confirmation_modal.set_title(I18n.t('materials.index.delete_modal.title'));
   confirmation_modal.set_body(I18n.t('materials.index.delete_modal.body'));
   confirmation_modal.set_yes_text(I18n.t('materials.index.delete_modal.yes_text'));
   confirmation_modal.set_no_text(I18n.t('materials.index.delete_modal.no_text'));
   var yes_id = confirmation_modal.yes_button_id;
   confirmation_modal.set_attr(yes_id,'href',element.attr('action'));
   confirmation_modal.set_attr(yes_id,'data-method','delete');
   confirmation_modal.add_class(yes_id,'btn-danger');
   $(`#${confirmation_modal.name}`).modal();
}

/*
   Sets the page size of the window. element is a HTML element that has the url to be redirected to
   (Usually it is the index page). It ignores the 'page' param and overwrites the 'page_size' param
*/
window.set_page_size = (element)=>{
   element = $(element);
   if(element[0].validity.valid && element.val()){
      var page_size = parseInt(element.val()) || '';
      var new_query_params = '';
      var params = window.location.href.split('?')[1] || '';
      params = params.split('&');
      for(var i = 0; i < params.length; i++){
         var param = params[i];
         pair_key_value = param.split('=');
         if(pair_key_value[0] == 'page_size' || pair_key_value[0] == 'page'){
            continue;
         }
         new_query_params+=`${param}&`;
      }
      new_query_params+=`page_size=${page_size}`;
      var url = element.attr('url');
      if(url){
         window.location.href = `${url}?${new_query_params}`;
      }
   }
}