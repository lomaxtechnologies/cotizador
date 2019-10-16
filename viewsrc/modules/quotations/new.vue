<script type="text/javascript">
  import quotationHeader from './components/header.vue'

  export default {
    components:{
      'quotation-header' : quotationHeader,
    },
    data() {
      return {
        visibility:{
          header: true,
          materials: false,
          services: false,
          conditions: false,
          all: false
        },
        validity:{
          header: false,
          materials: false,
          services: false,
          conditions: false
        },
        translations: {
          title: I18n.t('quotations.new.title'),
          header:{
            title: I18n.t('quotations.new.header.title')
          },
          materials:{
            title: I18n.t('quotations.new.materials.title')
          },
          services:{
            title: I18n.t('quotations.new.services.title')
          },
          conditions:{
            title: I18n.t('quotations.new.conditions.title')
          },
          global_view:{
            title: I18n.t('quotations.new.global_view.title')
          }
        },
        quotation:{
          header:{
            client: null,
            client_nit: '',
            quotation_date: this.today(),
            type: 1,
            use_siemon: true,
            use_supranet: true
          }
        }
      }
    },
    methods:{
      toggleSection: function(section_name,toggle_all = false){
        if(toggle_all){
          Object.keys(this.visibility).forEach(key => this.visibility[key] = true);
        }else{
          for(var section in this.visibility){
            if(section == section_name){
              this.visibility[section] = true;
            }else{
              this.visibility[section] = false;
            }
          }
        }
      },
      toggleHeader: function(){
        this.toggleSection('header');
      },
      toggleMaterials: function(){
        this.toggleSection('materials');
      },
      toggleServices: function(){
        this.toggleSection('services');
      },
      toggleConditions: function(){
        this.toggleSection('conditions');
      },
      toggleAll: function(){
        this.toggleSection(null,true);
      }
    }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <h2 class="text-primary">
        <b>{{translations.title}}</b>
      </h2>
      <b-card no-body>
        <div class="form-row no-gutters px-1">
          <div class="col-2 bg-light">
            <b-button v-on:click=toggleHeader class="btn btn-light btn-block m-1">
              <span v-bind:class="{'text-success':validity.header}">
                {{translations.header.title}} &nbsp;
                <i class="fas fa-check-circle"></i>
              </span>
            </b-button>
          </div>
          <div class="col-2 bg-light">
            <b-button :disabled=!validity.header v-on:click=toggleMaterials class="btn btn-light btn-block m-1">
              <span v-bind:class="{'text-success':validity.materials}">
                {{translations.materials.title}} &nbsp;
                <i class="fas fa-check-circle"></i>
              </span>
            </b-button>
          </div>
          <div class="col-2 bg-light">
            <b-button :disabled=!validity.header v-on:click=toggleServices class="btn btn-light btn-block m-1">
              <span v-bind:class="{'text-success':validity.services}">
                {{translations.services.title}} &nbsp;
                <i class="fas fa-check-circle"></i>
              </span>
            </b-button>
          </div>
          <div class="col-2 bg-light">
            <b-button :disabled=!validity.header v-on:click=toggleConditions class="btn btn-light btn-block m-1">
              <span v-bind:class="{'text-success':validity.conditions}">
                {{translations.conditions.title}} &nbsp;
                <i class="fas fa-check-circle"></i>
              </span>
            </b-button>
          </div>
          <div class="col-2 bg-light">
            <b-button :disabled=!validity.header v-on:click=toggleAll class="btn btn-light btn-block m-1">
              <span v-bind:class="{'text-success':validity.conditions}">
                {{translations.global_view.title}} &nbsp;
                <i class="fas fa-check-circle"></i>
              </span>
            </b-button>
          </div>
          <div class="col-2 bg-light"></div>
          <div class="col-12">
            <b-collapse :visible=visibility.header id="quotation-header" class="mt-2 mx-2">
              <quotation-header 
                :section_valid.sync=validity.header 
                :current_section_visibility.sync=visibility.header
                :next_section_visibility.sync=visibility.materials
                :parent_data.sync=quotation.header
              >
              </quotation-header>
            </b-collapse>
            <b-collapse :visible=visibility.materials id="quotation-materials" class="mt-2 mx-2">
              {{translations.materials.title}}
            </b-collapse>
            <b-collapse :visible=visibility.services id="quotation-services" class="mt-2 mx-2">
              {{translations.services.title}}
            </b-collapse>
            <b-collapse :visible=visibility.conditions id="quotation-conditions" class="mt-2 mx-2">
              {{translations.conditions.title}}
            </b-collapse>
          </div>
        </div>
      </b-card>
    </div>
  </div>
</template>