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

const NEW_PRICE_MODAL = 'new-price-modal';
window.show_new_price_modal = (element)=>{
   $('#submit-excel').attr("disabled", false);
   show_modal_body(`#${NEW_PRICE_MODAL}-body-main`);
   $(`#${NEW_PRICE_MODAL}`).modal();
}

window.show_modal_body = (name)=>{
   [
      `#${NEW_PRICE_MODAL}-body-main`,
      `#${NEW_PRICE_MODAL}-body-upload`,
      `#${NEW_PRICE_MODAL}-body-success`,
      `#${NEW_PRICE_MODAL}-body-error`
   ].forEach((selector)=>{
      if(name === selector){
         $(selector).show();
      }else{
         $(selector).hide();
      }
   });
}

window.upload_excel = ()=>{
   var formData = new FormData($('#excel_form')[0]);
   show_modal_body(`#${NEW_PRICE_MODAL}-body-upload`);
   $('#submit-excel').attr("disabled", true);
   $.post({
      url: '/api/products/upload',
      data: formData,
      processData: false,
      contentType: false
   }).done(function(result){
      $(`#${NEW_PRICE_MODAL}`).modal();
      show_modal_body(`#${NEW_PRICE_MODAL}-body-success`);
      setTimeout(()=>{
         location.reload(); 
      },100);
   }).fail(function(error){
      $(`#${NEW_PRICE_MODAL}`).modal();
      show_modal_body(`#${NEW_PRICE_MODAL}-body-error`);
   });
}