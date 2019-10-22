export default {
   install (Vue, options) {

      //date will be returned in standard format YYYY-MM-DD
      let today = function(){
         var date = new Date();
         return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
      }

      //date should be given in standard format YYYY-MM-DD
      let toLocalFormat = function(date){
         var parsed_date = I18n.t('formats.local_date');
         date = date.split('-');
         return parsed_date
         .replace('%Y',date[0])
         .replace('%m',date[1])
         .replace('%d',date[2]);
      }
      
      Vue.prototype.date = {
         today,
         toLocalFormat
      };
   }
}