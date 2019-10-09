/*
   Sets the page size of the window. 'element' is an input that has the new number of pages
   (Usually it is the index page). It ignores the 'page' param and overwrites the 'page_size' param
   in the url
*/
window.set_page_size = (element)=>{
   element = $(element);
   if(element[0].validity.valid && element.val()){
      var page_size = parseInt(element.val()) || '';
      var new_query_params = '';
      var url_split = window.location.href.split('?');
      var params = url_split[1] || '';
      var url = url_split[0];
      params = params.split('&');
      for(var i = 0; i < params.length; i++){
         var param = params[i];
         pair_key_value = param.split('=');
         if(pair_key_value[0] == 'page_size' || pair_key_value[0] == 'page'){
            continue;
         }
         new_query_params+=`${param}&`;
      }
      new_query_params+=`page_size=${page_size}`;
      window.location.href = `${url}?${new_query_params}`;
   }
}