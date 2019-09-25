window.confirm_password = function(element){
   const PASSWORDS_DO_NOT_MATCH_ERROR = 'Las contraseñas no coinciden.';
   var password_element = $(element);
   var password_confirmation_element = $(`#${password_element.attr('confirmation')}`);
   password = password_element.val();
   password_confirmation = password_confirmation_element.val();

   if(password && password_confirmation){
      if(password_confirmation != password){
         password_element[0].setCustomValidity(PASSWORDS_DO_NOT_MATCH_ERROR);
         password_confirmation_element[0].setCustomValidity(PASSWORDS_DO_NOT_MATCH_ERROR);
      }else{
         password_element[0].setCustomValidity('');
         password_confirmation_element[0].setCustomValidity('');
      }
   }
}

