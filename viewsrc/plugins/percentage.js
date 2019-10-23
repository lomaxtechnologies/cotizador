export default {
   install (Vue, options) {
      let format_percent = function(percent){
         percent = (percent/100)+1;
         return percent;
      };
      
      Vue.prototype.percentage = {
         format: format_percent
      };
   }
}