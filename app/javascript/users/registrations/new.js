/*
   Checks if both passwords are equal. The first password is on the value of 'element'.
   The second password is on the value of an input. 'element' should have an attribute
   'confirmation' that has the id of the that input
*/
window.confirm_password = function(element){
   const PASSWORDS_DO_NOT_MATCH_ERROR = 'Las contraseñas no coinciden.';
   var password_element = $(element);
   var password_confirmation_element = $(`#${password_element.attr('confirmation')}`);
   password = password_element.val();
   password_confirmation = password_confirmation_element.val();
   var ok_flag = true;
   if(password && password_confirmation){
      if(password_confirmation != password){
         password_element[0].setCustomValidity(PASSWORDS_DO_NOT_MATCH_ERROR);
         password_confirmation_element[0].setCustomValidity(PASSWORDS_DO_NOT_MATCH_ERROR);
         ok_flag = false;
      }
   }
   if(ok_flag){
      password_element[0].setCustomValidity('');
      password_confirmation_element[0].setCustomValidity('');
   }
}

