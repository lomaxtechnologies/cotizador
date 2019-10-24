<script type="text/javascript">

  import globalView from './components/global_view.vue'
  import componentCommentForm from '../comments/form-simple.vue'
  import componentCommentList from '../comments/list.vue'

  export default {
    components:{
      'global-view': globalView,
      'component-comment-form': componentCommentForm,
      'component-comment-list': componentCommentList
    }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <global-view :quotation_id=parseInt(this.$route.params.id)>
      </global-view>
      <component-comment-form class="mb-4" />
      <component-comment-list />
    </div>
  </div>
</template>