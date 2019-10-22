export default {
   install (Vue, options) {
      let formatter = new Intl.NumberFormat(I18n.t('js_currency_locale'), {
         minimumFractionDigits: 2,
         maximumFractionDigits: 2
      });
      let format_percent = function(percent){
         percent = (percent/100)+1;
         return percent
      };
      Vue.prototype.currency = {
         formatter, 
         format_percent
      };
   }
}
