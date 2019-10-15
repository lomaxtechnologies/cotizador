// Loading framework and libraries
import Vue from "vue";
import VueRouter from "vue-router";
import BootstrapVue from "bootstrap-vue";

// Loading app vue components
import quotationsNew from './new.vue';
import quotationsList from './list.vue';

Vue.use(VueRouter);
Vue.use(BootstrapVue);

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
app.$mount("#quotations_app");

console.log('app mounted');