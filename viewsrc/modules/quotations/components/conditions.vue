<script type="text/javascript">
  export default {
    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_code:{
        type: String,
        default: ''
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
      validateAndUpdate(){
        this.$emit('update:section_valid', false);
        var data = {quotation: this.quotation};
        this.http
        .put(`api/quotations/header/${this.quotation_id}`, data)
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
    <b-form @submit=validateAndUpdate>
      <b-form-row>
        <!----------------------------- quotation.conditions -------------------------------------->
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> Términos y Condiciones </label>
          <b-textarea v-model=quotation.payment_condition></b-textarea>
        </div>
        <!----------------------------- quotation.conditions -------------------------------------->

        <!-------------------------------- quotation.credits -------------------------------------->
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> Créditos </label>
          <b-textarea v-model=quotation.credits></b-textarea>
        </div>
        <!-------------------------------- quotation.credits -------------------------------------->

        <!------------------------------- quotation.warranty -------------------------------------->
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> Garantía </label>
          <b-textarea v-model=quotation.warranty></b-textarea>
        </div>
        <!-------------------------------- quotation.warranty -------------------------------------->

        <!--------------------------------- quotation.submit ---------------------------------->
        <div class="col-2 offset-10 mb-3">
          <button class="btn btn-primary btn-block" type="submit">
            {{translations.next}}
          </button>
        </div>
        <!--------------------------------- quotation.submit ---------------------------------->
      </b-form-row>
    </b-form>
  </div>
</template>
