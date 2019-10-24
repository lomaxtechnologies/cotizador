import axios from 'axios'
export default {
   install (Vue, options) {
      // Get authentication token from rails
      let meta = document.querySelector('meta[name="csrf-token"]');
      let token = '';
      if (meta) {
         token = meta.getAttribute('content')
      }
      let http = axios.create({
         headers: { 'X-CSRF-Token': token }
      });
      http.interceptors.response.use(response => {
         if (window.debug) {
            window.debug(response.data, "api method: " + response.request.responseURL)
         }
         if(response.data.successful){
            return {
               successful: response.data.successful,
               data: response.data.data
            }
         }
         return {
            successful: response.data.successful,
            error: response.data.error
         }
      }, error => {
         let message = ""
         if (error.response.data.error.message) {
            message = error.response.data.error.message
         }
         return {
            success: false,
            error: {
               error: error.response.statusText,
               message: message
            }
         }
      });
      Vue.prototype.http = http;
   }
}