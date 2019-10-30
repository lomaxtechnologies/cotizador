export default {
   install (Vue, options) {

      //date will be returned in standard format YYYY-MM-DD
      let today = function(){
         var date = new Date();
         return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
      }

      let date_options = {
         year: 'numeric',
         month: 'numeric',
         day: 'numeric',
         timeZone: 'UTC'
      };

      let datetime_options = {
         ...date_options, ...{
            hour: 'numeric',
            minute: 'numeric',
            second: 'numeric'
         }
      }

      //date should be given in standard format YYYY-MM-DD
      let toLocalFormat = function(date,include_time = false){
         date = new Date(date);
         if(include_time){
            return date.toLocaleDateString(I18n.currentLocale(), datetime_options);
         }else{
            return date.toLocaleDateString(I18n.currentLocale(), date_options);
         }
      }
      
      Vue.prototype.date = {
         today,
         toLocalFormat
      };
   }
}