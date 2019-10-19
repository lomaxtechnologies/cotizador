<script type="text/javascript">
  export default {

    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_id:{
        type:Number,
        default: NaN
      }
    },

    data(){
      return {
        translations: I18n.t('quotations.new.conditions'),
        quotation:{
          payment_condition:'',
          credits:'',
          warranty:''
        }
      }
    },

    methods:{
      updateConditions(){
        this.$emit('update:section_valid', false);
        this.http
        .put(`quotations/${this.quotation_id}`, {quotation: this.quotation})
        .then((response)=>{
          if(response.successful){
            this.$emit('update:section_valid', true);
          }else{
            console.log(JSON.stringify(response.error));
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
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
          <label class="mb-0 text-primary font-weight-bold"> Términos y Condiciones </label>
          <b-textarea v-model=quotation.payment_condition></b-textarea>
        </div>
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> Créditos </label>
          <b-textarea v-model=quotation.credits></b-textarea>
        </div>
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> Garantía </label>
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
