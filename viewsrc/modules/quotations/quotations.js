// Loading framework and libraries
import Vue from 'vue';
import VueRouter from 'vue-router';
import BootstrapVue from 'bootstrap-vue';
import http from '../../plugins/http.js';
import date from '../../plugins/date.js';
import currency from '../../plugins/currency.js'
import percentage from '../../plugins/percentage.js';
import bus from '../../plugins/bus.js';

// Loading app vue components
import quotationsAlert from '../../components/alert.vue';
import quotationsNew from './new.vue';
import quotationsIndex from './index.vue';
import quotationsShow from './show.vue';
import quotationsEdit from './edit.vue';

Vue.use(VueRouter);
Vue.use(BootstrapVue);
Vue.use(bus);
Vue.use(http);
Vue.use(date);
Vue.use(currency);
Vue.use(percentage);

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
      },
      {
         path: '/:id/edit', name: 'edit', component: quotationsEdit
      }
   ]
 });

// Vue app
let app = new Vue({
   components:{
      'alerts' : quotationsAlert
   },
   router: appRouter
});
app.$mount('#quotations_app');
