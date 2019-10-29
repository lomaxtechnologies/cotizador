<script type="text/javascript">

  import globalView from './components/global_view.vue'
  import quotationAttachments from "./components/attachments.vue"
  import componentCommentForm from '../comments/form-simple.vue'
  import componentCommentList from '../comments/list.vue'

   export default {
    data() {
      return {
        STATE_CREATED: 'created',
        STATE_ACTIVE: 'active',
        STATE_EXPIRED: 'expired',
        STATE_APPROVED: 'accepted',
        translations: I18n.t('quotations.show'),
        quotation_id: this.$route.params.id,
        quotation_state: 'active'
      }
    },
    mounted(){
      this.getQuotationState();
    },
    computed:{
      stateCreated(){
        return this.quotation_state == this.STATE_CREATED;
      },
      stateActive(){
        return this.quotation_state == this.STATE_ACTIVE;
      },
      stateApproved(){
        return this.quotation_state == this.STATE_APPROVED;
      },
      stateExpired(){
        return this.quotation_state == this.STATE_EXPIRED;
      }
    },
    methods:{
      getQuotationState: function(){
        this.http
        .get(`api/quotations/${this.quotation_id}/state`)
        .then((response)=>{
          if(response.successful){
            this.quotation_state = response.data;
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },
      generateExcel: function(){
        window.open(`/quotations/${this.$route.params.id}/excel`,"_self");
      },
      approveQuotation: function(){
        this.http
        .put(`/api/quotations/${this.quotation_id}/approve`)
        .then((response)=>{
          if(response.successful){
            this.quotation_state = this.STATE_APPROVED;
            this.alert(this.translations.notifications.quotation_approved,'success');
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },
      expireQuotation: function(){
        this.http
        .put(`/api/quotations/${this.quotation_id}/expire`)
        .then((response)=>{
          if(response.successful){
            this.quotation_state = this.STATE_EXPIRED;
            this.alert(this.translations.notifications.quotation_expired,'success');
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
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
          <b-button v-if="stateActive" variant="success" v-on:click="approveQuotation">
            <i class="fas fa-check-circle"></i>
            {{translations.buttons.approve}}
          </b-button>
          <b-button v-if="stateActive" variant="danger" v-on:click="expireQuotation">
            <i class="fas fa-trash"></i>
            {{translations.buttons.expire}}
          </b-button>
          <b-button v-if="!stateCreated" variant="primary" class="text-white" v-on:click="generateExcel">
            <i class="fas fa-file"></i>
            {{this.translations.generate_Excel}}
          </b-button>
          <b-button v-if="stateApproved||stateExpired" variant="warning" class="text-white">
            <i class="fas fa-redo"></i>
            {{translations.buttons.regenerate}}
          </b-button>
          <b-button v-if="stateApproved||stateExpired" variant="info" class="text-white">
            <i class="fas fa-clone"></i>
            {{translations.buttons.clone}}
          </b-button>
        </div>
        <div class="col-4 text-right">
          <b-link href="#/" class="mr-3">
            <i class="fas fa-undo"></i>
            {{translations.anchors.return}}
          </b-link>
        </div>
      </div>
      <global-view 
        :quotation_id=parseInt(this.$route.params.id)
        class="mt-2"
        :quotation_state="quotation_state"
      >
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