<script type="text/javascript">
import quotationForm from "./form.vue";

export default {
  components: {
    "quotation-form": quotationForm
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
            <b>{{translations.new_title}}</b>
          </h2>
        </div>
        <div class="col-4 text-right">
          <b-link href="#/" class="mr-3">
            <i class="fas fa-undo"></i>
            {{translations.anchors.return}}
          </b-link>
        </div>
      </div>
      <quotation-form>
      </quotation-form>
    </div>
  </div>
</template>