export default {
   install (Vue, options) {
      let today = function(){
         var date = new Date();
         return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
      }
      Vue.prototype.today = today;
   }
}