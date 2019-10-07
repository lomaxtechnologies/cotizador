const CONFIRM_DELETE_SERVICE_TITLE = '¿Realmente deseas eliminar este servicio?';
const CONFIRM_DELETE_SERVICE_BODY = `
   Una vez eliminado no podrás recuperarlo y deberás crear uno nuevo. 
   Todas las cotizaciones asociadas a este servicio seguirá existiendo.
`;
const CONFIRM_DELETE_SERVICE_YES_TEXT = 'Sí, elimínalo';
const CONFIRM_DELETE_SERVICE_NO_TEXT = 'Cancelar';

window.show_confirmation_modal = (element)=>{
   element = $(element);
   confirmation_modal.set_title(CONFIRM_DELETE_SERVICE_TITLE);
   confirmation_modal.set_body(CONFIRM_DELETE_SERVICE_BODY);
   confirmation_modal.set_yes_text(CONFIRM_DELETE_SERVICE_YES_TEXT);
   confirmation_modal.set_no_text(CONFIRM_DELETE_SERVICE_NO_TEXT);
   var yes_id = confirmation_modal.yes_button_id;
   confirmation_modal.set_attr(yes_id,'href',element.attr('action'));
   confirmation_modal.set_attr(yes_id,'data-method','delete');
   $(`#${confirmation_modal.name}`).modal();
}