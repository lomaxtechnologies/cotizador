export default {
   install (Vue, options) {
      Vue.prototype.bus = new Vue();
      Vue.prototype.alert = (message, type) => {
         Vue.prototype.bus.$emit('show-vue-alert', message, type);
      }
   }
}