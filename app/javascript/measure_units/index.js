window.show_confirmation_modal = (element)=>{
   element = $(element);
   confirmation_modal.set_title(I18n.t('measure_units.index.delete_modal.title'));
   confirmation_modal.set_body(I18n.t('measure_units.index.delete_modal.body'));
   confirmation_modal.set_yes_text(I18n.t('measure_units.index.delete_modal.yes_text'));
   confirmation_modal.set_no_text(I18n.t('measure_units.index.delete_modal.no_text'));
   var yes_id = confirmation_modal.yes_button_id;
   confirmation_modal.set_attr(yes_id,'href',element.attr('action'));
   confirmation_modal.set_attr(yes_id,'data-method','delete');
   $(`#${confirmation_modal.name}`).modal();
}

const NEW_measure_unit_MODAL = 'new-measure_unit-modal';
window.show_new_measure_unit_modal = (element)=>{
   $(`#${NEW_measure_unit_MODAL}`).modal();
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