<script type="text/javascript">
  import quotationHeader from './components/header.vue'
  import quotationMaterials from './components/material.vue'
  import quotationConditions from './components/conditions.vue'

  export default {
    components:{
      'quotation-header' : quotationHeader,
      'quotation-materials' : quotationMaterials,
      'quotation-conditions': quotationConditions
    },
    data(){
      return {
        translations: I18n.t('quotations.new'),
        tab_index: 0,
        show_alert:false,
        quotation:{
          id: NaN,
        },
        validity:{
          header:false,
          materials:false,
          services:false,
          conditions:false,
          global_view:false
        }
      }
    },
    watch:{
      'validity.header': function(){
        if(this.validity.header){
          this.tab_index++;
        }
      },
      'validity.conditions': function(){
        if(this.validity.conditions){
          this.tab_index++;
        }
      }
    }
  }
</script>

<template>
  <div class="row">
    <b-alert :show=show_alert dismissible class="fixed-top mx-3">Default Alert</b-alert>
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <b-form>
        <h2 class="text-primary">
          <b>{{translations.title}}</b>
        </h2>
        <div>
          <b-card no-body>
            <b-tabs card v-model=tab_index>

              <!--------------------------------- Header Tab ----------------------------------> 
              <b-tab active>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':validity.header}">
                    {{translations.header.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <quotation-header
                    :section_valid.sync=validity.header
                    :quotation_id.sync=quotation.id
                  >
                  </quotation-header>
                </b-card-text>
              </b-tab>
              <!--------------------------------- Header Tab ---------------------------------->

              <!-------------------------------- Materials Tab ---------------------------------> 
              <b-tab>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':validity.materials}">
                    {{translations.materials.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <!--HEADER COMPONENT GOES HERE-->
                  <quotation-materials
                    :quotation_id.sync=quotation.id
                  >
                  </quotation-materials>
                </b-card-text>
              </b-tab>
              <!-------------------------------- Materials Tab ---------------------------------> 

              <!--------------------------------- Services Tab ----------------------------------> 
              <b-tab>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':validity.services}">
                    {{translations.services.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <!--HEADER COMPONENT GOES HERE-->
                </b-card-text>
              </b-tab>
              <!--------------------------------- Services Tab ----------------------------------> 

              <!--------------------------------- Conditions Tab ---------------------------------> 
              <b-tab>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':validity.conditions}">
                    {{translations.conditions.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <quotation-conditions
                    :section_valid.sync=validity.conditions
                    :quotation_id=quotation.id
                  >
                  </quotation-conditions>
                </b-card-text>
              </b-tab>
              <!--------------------------------- Conditions Tab ---------------------------------> 

              <!----------------------------------- Global Tab ------------------------------------> 
              <b-tab>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':validity.global}">
                    {{translations.global_view.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <!--HEADER COMPONENT GOES HERE-->
                </b-card-text>
              </b-tab>
              <!----------------------------------- Global Tab ------------------------------------> 
            </b-tabs>
          </b-card>
        </div>
      </b-form>
    </div>
  </div>
</template>