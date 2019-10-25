<script type="text/javascript">
import quotationForm from "./form.vue";

export default {
  components: {
    "quotation-form": quotationForm
  },

  data() {
    return {
      translations: I18n.t("quotations.new_edit")
    };
  }
}
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <h2 class="text-primary">
        <b>{{translations.edit_title}}</b>
      </h2>
      <quotation-form :is_edit="true">
      </quotation-form>
    </div>
  </div>
</template>