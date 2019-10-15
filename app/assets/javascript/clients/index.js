window.show_confirmation_modal = (element)=>{
   element = $(element);
   confirmation_modal.set_title(I18n.t('clients.index.delete_modal.title'));
   confirmation_modal.set_body(I18n.t('clients.index.delete_modal.body'));
   confirmation_modal.set_yes_text(I18n.t('clients.index.delete_modal.yes_text'));
   confirmation_modal.set_no_text(I18n.t('clients.index.delete_modal.no_text'));
   var yes_id = confirmation_modal.yes_button_id;
   confirmation_modal.set_attr(yes_id,'href',element.attr('action'));
   confirmation_modal.set_attr(yes_id,'data-method','delete');
   confirmation_modal.add_class(yes_id,'btn-danger');
   confirmation_modal.add_class(yes_id,'btn-danger');
   $(`#${confirmation_modal.name}`).modal();
}