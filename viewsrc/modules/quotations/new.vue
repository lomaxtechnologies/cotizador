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
        quotation:{
          id: null,
          code: ''
        },
        validity:{
          header:false,
          materials:false,
          services:false,
          conditions:false,
          global_view:false
        }
      }
    }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <b-form>
        <h2 class="text-primary">
          <b>{{translations.title}}</b>
        </h2>
        <div>
          <b-card no-body>
            <b-tabs card>

              <!--------------------------------- Header Tab ----------------------------------> 
              <b-tab >
                <template v-slot:title>
                  <span v-bind:class="{'text-success':validity.header}">
                    {{translations.header.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <quotation-header
                    :section_valid.sync=validity.header
                    :quotation_code.sync=quotation.code
                  >
                  </quotation-header>
                </b-card-text>
              </b-tab>
              <!--------------------------------- Header Tab ---------------------------------->

              <!-------------------------------- Materials Tab ---------------------------------> 
              <b-tab active="">
                <template v-slot:title>
                  <span v-bind:class="{'text-success':quotation.id!=null}">
                    {{translations.materials.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <!--HEADER COMPONENT GOES HERE-->
                  <quotation-materials
                    :quotation_code.sync=quotation.code
                  >
                  </quotation-materials>
                </b-card-text>
              </b-tab>
              <!-------------------------------- Materials Tab ---------------------------------> 

              <!--------------------------------- Services Tab ----------------------------------> 
              <b-tab>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':quotation.id!=null}">
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
                  <span v-bind:class="{'text-success':quotation.id!=null}">
                    {{translations.conditions.title}} &nbsp;
                    <i class="fas fa-check-circle"></i>
                  </span>
                </template>
                <b-card-text>
                  <!--HEADER COMPONENT GOES HERE-->
                </b-card-text>
              </b-tab>
              <!--------------------------------- Conditions Tab ---------------------------------> 

              <!----------------------------------- Global Tab ------------------------------------> 
              <b-tab>
                <template v-slot:title>
                  <span v-bind:class="{'text-success':quotation.id!=null}">
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