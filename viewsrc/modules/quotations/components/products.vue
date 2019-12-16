<script type="text/javascript">

import quotationSimple from "./simple.vue";
import quotationComplex from "./complex.vue";

export default {
  components:{
    "quotation-simple": quotationSimple,
    "quotation-complex":quotationComplex
  },
  props: {
    section_valid: {
      type: Boolean,
      default: false
    },
    quotation_id: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      component_valid: false,
      quotation_type: null
    };
  },
  mounted(){
    this.getQuotationType();
    this.syncFlags();
  },
  methods: {
    syncFlags(){
      this.component_valid = this.section_valid;
    },
    getQuotationType: function() {
      if(this.quotation_id){
        this.http
          .get(`/api/quotations/${this.quotation_id}/type`)
          .then(response => {
            if(response.successful){
              this.quotation_type = response.data[0].quotation_type;
            }else{
              this.handleError(response.error);
            }
          })
          .catch(err => {
            console.log("Error", err.stack, err.name, err.message);
          });
      }
    }
  },
  watch: {
    quotation_id: function() {
      this.getQuotationType();
    },
    component_valid: function(){
      if(this.section_valid != this.component_valid){
        this.$emit('update:section_valid', this.component_valid)
      }
    },
    section_valid: function(){
      if(this.section_valid != this.component_valid){
        this.component_valid = this.section_valid
      }
    }
  }
};
</script>

<template>
  <div v-if="quotation_type === 't_comparative'">
    <quotation-complex 
      :quotation_id="quotation_id"
      :section_valid.sync="component_valid"
    >
    </quotation-complex>
  </div>
  <div v-else>
    <quotation-simple
      :quotation_type="quotation_type"
      :quotation_id="quotation_id"
      :section_valid.sync="component_valid"
    ></quotation-simple>
  </div>
</template>