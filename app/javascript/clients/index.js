const CONFIRM_DELETE_CLIENT_TITLE = '¿Realmente deseas eliminar a este cliente?';
const CONFIRM_DELETE_CLIENT_BODY = `
   Una vez eliminado no podrás recuperarlo y deberás crear uno nuevo. 
   Todas las cotizaciones asociadas a este cliente seguirán existiendo.
`;
const CONFIRM_DELETE_CLIENT_YES_TEXT = 'Sí, elimínalo';
const CONFIRM_DELETE_CLIENT_NO_TEXT = 'Cancelar';

window.show_confirmation_modal = (element)=>{
   element = $(element);
   confirmation_modal.set_title(CONFIRM_DELETE_CLIENT_TITLE);
   confirmation_modal.set_body(CONFIRM_DELETE_CLIENT_BODY);
   confirmation_modal.set_yes_text(CONFIRM_DELETE_CLIENT_YES_TEXT);
   confirmation_modal.set_no_text(CONFIRM_DELETE_CLIENT_NO_TEXT);
   var yes_id = confirmation_modal.yes_button_id;
   confirmation_modal.set_attr(yes_id,'href',element.attr('action'));
   confirmation_modal.set_attr(yes_id,'data-method','delete');
   $(`#${confirmation_modal.name}`).modal();
}

const NEW_client_MODAL = 'new-client-modal';
window.show_new_client_modal = (element)=>{
   $(`#${NEW_client_MODAL}`).modal();
}

const ATTR_FORM_TARGET = 'form_target';
const ATTR_TITLE_TARGET = 'title_target';
window.show_hide_edit_form = (element)=>{
   element = $(element);
   var form_target = $(`#${element.attr(ATTR_FORM_TARGET)}`);
   var title_target = $(`#${element.attr(ATTR_TITLE_TARGET)}`);
   if(form_target.hasClass('d-none')){
      form_target.removeClass('d-none');
      title_target.addClass('d-none');
   }else{
      form_target.addClass('d-none');
      title_target.removeClass('d-none');
   }
}