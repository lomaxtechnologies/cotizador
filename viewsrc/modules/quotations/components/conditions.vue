<script type="text/javascript">
  export default {

    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_id:{
        type:Number,
        default: null
      }
    },

    data(){
      return {
        translations: I18n.t('quotations.new_edit.conditions'),
        quotation:{
          payment_condition:'',
          credits:'',
          warranty:''
        }
      }
    },

    mounted(){
      this.getConditions();
    },

    methods:{
      getConditions(){
        if(this.quotation_id){
          this.http
          .get(`/api/quotations/${this.quotation_id}/conditions`)
          .then((response)=>{
            if(response.successful){
              this.quotation = response.data;
            }else{
              this.handleError(response.error);
            }
          }).catch((err)=>{
            console.log("Error", err.stack, err.name, err.message);
          })
        }
      },
      
      updateConditions(event){
        event.preventDefault();
        this.$emit('update:section_valid', false);
        this.http
        .put(`/quotations/${this.quotation_id}`, {quotation: this.quotation})
        .then((response)=>{
          if(response.successful){
            this.$emit('update:section_valid', true);
            this.alert(this.translations.notifications.conditions_updated,'success');
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      }
    }
  }
</script>

<template>
  <div>
    <b-form @submit=updateConditions>
      <b-form-row>
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles.payment_condition}}
          </label>
          <b-textarea v-model=quotation.payment_condition></b-textarea>
        </div>
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.warranty}} </label>
          <b-textarea v-model=quotation.warranty></b-textarea>
        </div>
        <div class="col-2 offset-10 mb-3">
          <b-button variant="primary" block type="submit">
            {{translations.next}}
          </b-button>
        </div>
      </b-form-row>
    </b-form>
  </div>
</template>
