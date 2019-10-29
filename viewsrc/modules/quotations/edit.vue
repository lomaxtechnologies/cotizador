<script type="text/javascript">
import quotationForm from "./form.vue";
import componentCommentForm from '../comments/form-simple.vue'
import componentCommentList from '../comments/list.vue'

export default {
  components: {
    "quotation-form": quotationForm,
    'component-comment-form': componentCommentForm,
    'component-comment-list': componentCommentList
  },

  data() {
    return {
      translations: I18n.t('quotations.new_edit')
    };
  }
}
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <div class="row">
        <div class="col-8">
          <h2 class="text-primary">
            <b>{{translations.edit_title}}</b>
          </h2>
        </div>
        <div class="col-4 text-right">
          <b-link href="#/" class="mr-3">
            <i class="fas fa-undo"></i>
            {{translations.anchors.return}}
          </b-link>
        </div>
      </div>
      <quotation-form :is_edit="true">
      </quotation-form>
    </div>
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <component-comment-form :quotation_id="parseInt(this.$route.params.id)" class="mb-4" />
      <component-comment-list :quotation_id="parseInt(this.$route.params.id)" />
    </div>
  </div>
</template>