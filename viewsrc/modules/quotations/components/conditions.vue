<script type="text/javascript">
  export default {
    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      next_section_visibility: {
        type: Boolean,
        default: false
      },
      current_section_visibility: {
        type: Boolean,
        default: true
      },
      parent_data:{
        type: Object,
        default: ()=>{}
      }
    },
    data(){
      return {
        translations:{
          review_and_save: I18n.t('quotations.new.header.review_and_save')
        },
        quotation:{
          payment_conditions:'',
          credits:'',
          warranty:''
        }
      }
    },
    computed:{
      //checks if this is the only section visible. Since this is the last real section,
      //if the next section is visible, the global view is on
      checkForGlobalViewOn: function(){
        return this.next_section_visibility;
      },
    },
    methods:{
      blockAndEmitChanges(){
        this.$emit('update:section_valid', true);
        this.$emit('update:current_section_visibility', false);
        this.$emit('update:next_section_visibility', true);
        this.$emit('update:parent_data',this.quotation);
      }
    }
  }
</script>

<template>
  <div>
    <b-form>
      <b-form-row>
        <!----------------------------- quotation.conditions -------------------------------------->
        <div class="col-12 mb-3">
          <label class="mb-0 text-primary font-weight-bold"> Términos y Condiciones </label>
          <b-textarea v-model=quotation.payment_conditions></b-textarea>
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
          <button class="btn btn-primary btn-block" :hidden=checkForGlobalViewOn type="submit" v-on:click="blockAndEmitChanges">
            {{translations.review_and_save}}
          </button>
        </div>
        <!--------------------------------- quotation.submit ---------------------------------->
      </b-form-row>
    </b-form>
  </div>
</template>
