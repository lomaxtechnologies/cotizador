// Loading framework and libraries
import Vue from 'vue';
import VueRouter from 'vue-router';
import BootstrapVue from 'bootstrap-vue';
import http from '../../components/http.js';
import date from '../../components/date.js';
import currency from '../../components/currency.js'

// Loading app vue components
import dashboardsIndex from './index.vue';

Vue.use(VueRouter);
Vue.use(BootstrapVue);
Vue.use(http);
Vue.use(date);
Vue.use(currency);

var appRouter = new VueRouter({
   routes: [
      {
         path: '/', redirect: '/index'
      },
      {
         path: '/index', name: 'index', component: dashboardsIndex
      }
   ]
 });

// Vue app
let app = new Vue({router: appRouter});
app.$mount('#dashboards_app');
