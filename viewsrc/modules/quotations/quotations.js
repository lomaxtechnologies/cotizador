// Loading framework and libraries
import Vue from 'vue';
import VueRouter from 'vue-router';
import BootstrapVue from 'bootstrap-vue';
import http from '../../components/http.js';
import date from '../../components/date.js';

// Loading app vue components
import quotationsNew from './new.vue';
import quotationsList from './list.vue';

Vue.use(VueRouter);
Vue.use(BootstrapVue);
Vue.use(http);
Vue.use(date);

var appRouter = new VueRouter({
   routes: [
      {
         path: '/', redirect: '/list'
      },
      {
         path: '/list', name: 'list', component: quotationsList
      },
      {
         path: '/new', name: 'new', component: quotationsNew
      }
   ]
 });

// Vue app
let app = new Vue({router: appRouter});
app.$mount('#quotations_app');
