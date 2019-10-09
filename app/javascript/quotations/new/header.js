import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
require('jquery')

Vue.use(TurbolinksAdapter)

var app = new Vue({
   el: '#quotation_header',
   data:{
      quotation_type: 1,
      valid_header: false,
      supranet_enabled: true,
      siemon_enabled: true
   }
   ,methods:{
      validate_header: function(){
         $('#nav-link-header').removeClass('text-muted').addClass('text-success');
         this.valid_header = true;
      },
      invalidate_header: function(){
         if(this.valid_header){
            $('#nav-link-header').removeClass('text-success').addClass('text-muted');
            this.valid_header = false;
         }
      }
   }
});