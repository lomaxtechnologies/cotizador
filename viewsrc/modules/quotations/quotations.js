// Loading framework and libraries
import Vue from 'vue';
import VueRouter from 'vue-router';
import BootstrapVue from 'bootstrap-vue';
import http from '../../components/http.js';
import date from '../../components/date.js';
import currency from '../../components/currency.js'

// Loading app vue components
import quotationsNew from './new.vue';
import quotationsIndex from './index.vue';
import quotationsShow from './show.vue';

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
         path: '/index', name: 'index', component: quotationsIndex
      },
      {
         path: '/new', name: 'new', component: quotationsNew
      },
      {
         path: '/:id/show', name: 'show', component: quotationsShow
      }
   ]
 });

// Vue app
let app = new Vue({router: appRouter});
app.$mount('#quotations_app');
