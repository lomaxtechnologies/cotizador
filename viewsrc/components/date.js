export default {
   install (Vue, options) {
      var date_options = { year: 'numeric', month: 'numeric', day: 'numeric' };
      let today = function(){
         var date = new Date();
         return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
      }
      //date must be on standard format
      let toLocalFormat = function(date){
         date = new Date(date);
         return date.toLocaleDateString(I18n.currentLocale(),date_options);
      }
      Vue.prototype.date = {
         today,
         toLocalFormat
      };
   }
}