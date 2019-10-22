export default {
   install (Vue, options) {
      var date_options = { year: 'numeric', month: 'numeric', day: 'numeric' };
      //date will be returned in standard format YYYY-MM-DD
      let today = function(){
         var date = new Date();
         return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
      }
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