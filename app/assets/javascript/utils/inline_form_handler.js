const ATTR_FORM_TARGET = 'form_target';
const ATTR_TITLE_TARGET = 'title_target';
window.show_hide_edit_form = (element)=>{
   element = $(element);
   var form_target = $(`#${element.attr(ATTR_FORM_TARGET)}`);
   var title_target = $(`#${element.attr(ATTR_TITLE_TARGET)}`);
   if(form_target.hasClass('d-none')){
      element.addClass('btn-outline-success');
      element.removeClass('btn-success');
      form_target.removeClass('d-none');
      title_target.addClass('d-none');
   }else{
      element.removeClass('btn-outline-success');
      element.addClass('btn-success');
      form_target.addClass('d-none');
      title_target.removeClass('d-none');
   }
}