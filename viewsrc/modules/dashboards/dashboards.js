// Loading framework and libraries
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import http from '../../plugins/http.js';
import date from '../../plugins/date.js';
import currency from '../../plugins/currency.js'

// Loading app vue components
import dashboardsIndex from './index.vue';

Vue.use(BootstrapVue);
Vue.use(http);
Vue.use(date);
Vue.use(currency);

// Vue app
   let app = new Vue({
      components: 
         {dashboards_index: dashboardsIndex}
   });
app.$mount('#dashboards_app');
