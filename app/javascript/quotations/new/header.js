import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'

Vue.use(TurbolinksAdapter)

var app = new Vue({
   el: '#quotation_header',
   data:{
      quotation_type: 1
   }
   ,methods:{
   },
   mounted:function(){
   }
});