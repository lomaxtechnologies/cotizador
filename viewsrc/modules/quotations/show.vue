<script type="text/javascript">

  import globalView from './components/global_view.vue'
  import quotationAttachments from "./components/attachments.vue"
  import componentCommentForm from '../comments/form-simple.vue'
  import componentCommentList from '../comments/list.vue'

   export default {
    data() {
      return {
        action: '',
        STATE_CREATED: 'created',
        STATE_ACTIVE: 'active',
        STATE_EXPIRED: 'expired',
        STATE_APPROVED: 'accepted',
        STATE_CLONED: 'cloned',
        STATE_DUPLICATED: 'duplicated',
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
      confirmApproval: function(){
        this.action = this.STATE_APPROVED;
        this.$bvModal.show('confirmation_modal');
      },
      confirmExpiration: function(){
        this.action = this.STATE_EXPIRED;
        this.$bvModal.show('confirmation_modal');
      },
      confirmClone: function(){
        this.action = this.STATE_CLONED;
        this.$bvModal.show('confirmation_modal');
      },
      confirmDuplicate: function(){
        this.action = this.STATE_DUPLICATED;
        this.$bvModal.show('confirmation_modal');
      },
      hideConfirmationModal: function(){
        this.$bvModal.hide('confirmation_modal');
      },
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
      generatePDF: function(){
        window.open(`/quotations/${this.$route.params.id}/pdf`,"_self");
      },
      approveQuotation: function(){
        this.http
        .put(`/api/quotations/${this.quotation_id}/approve`)
        .then((response)=>{
          this.hideConfirmationModal();
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
          this.hideConfirmationModal();
          if(response.successful){
            this.quotation_state = this.STATE_EXPIRED;
            this.alert(this.translations.notifications.quotation_expired,'success');
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },
      cloneQuotation: function(){
        this.http
        .post(`/api/quotations/${this.quotation_id}/clone`)
        .then((response)=>{
          this.hideConfirmationModal();
          if(response.successful){
            this.alert(this.translations.notifications.quotation_cloned,'success');
            this.$router.push(`/index`);
            /*location.href = '#/100/show';
            location.reload()*/
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },
      duplicateQuotation: function(){
        this.http
        .post(`/api/quotations/${this.quotation_id}/duplicate`)
        .then((response)=>{
          this.hideConfirmationModal();
          if(response.successful){
            this.alert(this.translations.notifications.quotation_duplicated,'success');
            this.$router.push(`/index`);
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
    
      <b-modal
        id="confirmation_modal"
        :title=translations.confirmation_modal.title
      >
        <p v-if="action==STATE_APPROVED" class="text-justify">
          {{translations.confirmation_modal.approve_body}}
        </p>
        <p v-if="action==STATE_EXPIRED" class="text-justify">
          {{translations.confirmation_modal.expire_body}}
        </p>
        <p v-if="action==STATE_CLONED" class="text-justify">
          {{translations.confirmation_modal.clone_body}}
        </p>
        <p v-if="action==STATE_DUPLICATED" class="text-justify">
          {{translations.confirmation_modal.duplicate_body}}
        </p>
        <template v-slot:modal-footer>
          <div>
            <b-button
              variant="success"
              v-on:click=approveQuotation
              v-if="action==STATE_APPROVED"
            > {{translations.confirmation_modal.buttons.approve}}
            </b-button>
            <b-button
              variant="danger"
              v-on:click=expireQuotation
              v-if="action==STATE_EXPIRED"
            > {{translations.confirmation_modal.buttons.expire}}
            </b-button>
            <b-button
              variant="info"
              class="text-white"
              v-on:click=cloneQuotation
              v-if="action==STATE_CLONED"
            > {{translations.confirmation_modal.buttons.clone}}
            </b-button>
            <b-button
              variant="warning"
              class="text-white"
              v-on:click=duplicateQuotation
              v-if="action==STATE_DUPLICATED"
            > {{translations.confirmation_modal.buttons.duplicate}}
            </b-button>
            <b-button
              variant="secondary"
              v-on:click=hideConfirmationModal
            > {{translations.confirmation_modal.buttons.cancel}}
            </b-button>
          </div>
        </template>
      </b-modal>

      <div class="row">
        <div class="col-8">
          <b-button :disabled="!stateActive" variant="success" v-on:click="confirmApproval">
            <i class="fas fa-check-circle"></i>
            {{translations.buttons.approve}}
          </b-button>
          <b-button :disabled="!stateActive" variant="danger" v-on:click="confirmExpiration">
            <i class="fas fa-trash"></i>
            {{translations.buttons.expire}}
          </b-button>
          <b-button :disabled="stateCreated" variant="primary" class="text-white" v-on:click="generateExcel">
            <i class="fas fa-file-excel"></i>
            {{this.translations.generate_Excel}}
          </b-button>
          <b-button :disabled="!stateApproved&&!stateExpired" variant="warning" class="text-white" v-on:click="confirmDuplicate">
          <b-button :disabled="stateCreated" variant="dark" class="text-white" v-on:click="generatePDF">
            <i class="fas fa-download"></i>
            {{this.translations.generate_PDF}}
          </b-button>
          <b-button v-if="stateApproved||stateExpired" variant="warning" class="text-white">
            <i class="fas fa-redo"></i>
            {{translations.buttons.regenerate}}
          </b-button>
          <b-button :disabled="!stateApproved&&!stateExpired" variant="info" class="text-white" v-on:click="confirmClone">
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