var translations = I18n.t('products.index.delete_modal');
window.show_confirmation_modal = (element)=>{
   element = $(element);
   confirmation_modal.set_title(translations.title);
   confirmation_modal.set_body(translations.body);
   confirmation_modal.set_yes_text(translations.yes_text);
   confirmation_modal.set_no_text(translations.no_text);
   var yes_id = confirmation_modal.yes_button_id;
   confirmation_modal.set_attr(yes_id,'href',element.attr('action'));
   confirmation_modal.set_attr(yes_id,'data-method','delete');
   confirmation_modal.add_class(yes_id,'btn-danger');
   $(`#${confirmation_modal.name}`).modal();
}

const NEW_price_MODAL = 'new-price-modal';
window.show_new_price_modal = (element)=>{
   $(`#${NEW_price_MODAL}`).modal();
}