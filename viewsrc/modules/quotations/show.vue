<script type="text/javascript">

  import globalView from './components/global_view.vue'
  import quotationAttachments from "./components/attachments.vue"
  import componentCommentForm from '../comments/form-simple.vue'
  import componentCommentList from '../comments/list.vue'

   export default {
    data() {
      return {
        translations: I18n.t("quotations.show")
      }
    },
    methods:{
      generateExcel: function(){
        console.log(this.$route.params.id);
        let quotation_id = this.$route.params.id;
        this.http
        .post(`/quotations/${quotation_id}/excel`)
        .catch(err => {
        console.log(JSON.stringify(err));
        });
      }
    },
    components:{
      'global-view': globalView,
      'component-comment-form': componentCommentForm,
      'component-comment-list': componentCommentList,
      "quotation-attachments": quotationAttachments
    }
  }
</script>

<template>
  <div class="row" >
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <div class="row">
        <div class="col-8">
          <b-button variant="success">
            <i class="fas fa-check-circle"></i>
            {{translations.buttons.approve}}
          </b-button>
          <b-button variant="danger">
            <i class="fas fa-trash"></i>
            {{translations.buttons.expire}}
          </b-button>
          <b-button variant="warning" class="text-white">
            <i class="fas fa-redo"></i>
            {{translations.buttons.regenerate}}
          </b-button>
          <b-button variant="info" class="text-white">
            <i class="fas fa-clone"></i>
            {{translations.buttons.clone}}
          </b-button>
          <b-button variant="primary" class="text-white" v-on:click="generateExcel">
            <i class="fas fa-file"></i>
            {{this.translations.generate_Excel}}
          </b-button>
        </div>
        <div class="col-4 text-right">
          <b-link href="#/" class="mr-3">
            <i class="fas fa-undo"></i>
            {{translations.anchors.return}}
          </b-link>
        </div>
      </div>
      <global-view :quotation_id=parseInt(this.$route.params.id) class="mt-2">
      </global-view>
      <b-tabs>
        <b-tab :title="translations.tabs.comments">
          <component-comment-form :quotation_id="parseInt(this.$route.params.id)" class="mb-4" />
          <component-comment-list :quotation_id="parseInt(this.$route.params.id)" />
        </b-tab>
        <b-tab :title="translations.tabs.attachments">
          <quotation-attachments :quotation_id="parseInt(this.$route.params.id)" />
        </b-tab>
      </b-tabs>
    </div>
  </div>
</template>