export default {
   install (Vue, options) {
      let formatter = new Intl.NumberFormat(I18n.t('js_currency_locale'), {
         minimumFractionDigits: 2,
         maximumFractionDigits: 2
      });
      Vue.prototype.currency = formatter;
   }
}
