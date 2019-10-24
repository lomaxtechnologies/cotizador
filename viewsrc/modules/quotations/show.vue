<script type="text/javascript">
  import globalView from './components/global_view.vue'

   export default {
     data(){
       return {
          translation:{
            show: I18n.t('quotations.show')
          }
       }
     },
     methods:{
       generateExcel: function(){
         console.log(this.$route.params.id);
       }
     },
     components:{
       'global-view': globalView
     }
  }
</script>

<template>
  <div class="row" >
    <div class="col-lg-12 offset-xl-1 col-xl-10 text-right">
      <b-button variant="primary" @update="dataExcel" v-on:click="generateExcel">
        {{this.translation.show.generate_Excel}}
      </b-button>
    </div>
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <global-view 
        :quotation_id=parseInt(this.$route.params.id)
        >
      </global-view>
    </div>
  </div>
</template>