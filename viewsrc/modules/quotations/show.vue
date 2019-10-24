<script type="text/javascript">
  import globalView from './components/global_view.vue'

   export default {
     components:{
       'global-view': globalView
     }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <global-view :quotation_id=parseInt(this.$route.params.id)>
      </global-view>
    </div>
  </div>
</template>