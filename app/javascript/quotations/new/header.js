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
   },
   
   methods:{
      parse_data: function(data){
         data = data.split('&');
         var new_data = {};
         for(var i = 0; i < data.length; i++){
            var pair = data[i].split('=');
            var key = pair[0];
            new_data[decodeURIComponent(pair[0])] = pair[1];
         }
         return new_data;
      },

      validate_header: function(){
         $('#nav-link-header').removeClass('text-muted').addClass('text-success');
         var data = $("#quotation_header_form").serialize();
         data = this.parse_data(data);
         console.log(JSON.stringify(data));
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