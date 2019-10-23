export default {
   install (Vue, options) {
      Vue.prototype.bus = new Vue();

      let alert = function(message,type){
         Vue.prototype.bus.$emit('show-vue-alert', message, type);
      }
      Vue.prototype.alert = alert;

      //An error object with the same structure as the one 
      //returned from response_with_error in the backend
      Vue.prototype.handleError = (error)=>{
         let message = `${error.message}:` || '';
         let details = error.details || [];
         details.forEach((detail)=>{
            message += ` ${detail}`;
         });
         alert(message,'danger');
      }
   }
}