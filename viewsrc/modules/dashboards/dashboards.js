// Loading framework and libraries
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import http from '../../components/http.js';
import date from '../../components/date.js';
import currency from '../../components/currency.js'

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
