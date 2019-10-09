import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'

Vue.use(TurbolinksAdapter)

var app = new Vue({
   el: '#quotation_header',
   data:{
      quotation_type: 0,
      number: 0,
      client: 0,
      date: '',
      percentage_supranet: 0,
      percentage_siemon: 0,
      percentage_service: 0
   }
   ,methods:{
   },
   mounted:function(){
   }
});