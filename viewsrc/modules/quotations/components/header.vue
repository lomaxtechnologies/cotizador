<script type="text/javascript">

  import axios from 'axios'

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
        default: {}
      }
    },
    data(){
      return {
        translations:{
          next:I18n.t('quotations.new.header.next'),
          select:{
            client_default: I18n.t('quotations.new.header.select_client')
          },
          titles:{
            client: I18n.t('clients.title_singular'),
            nit: I18n.t('activerecord.attributes.client.nit'),
            date: I18n.t('date'),
            service_percentage: I18n.t('quotations.new.header.service_percentage'),
            quotation_type: I18n.t('quotations.new.header.quotation_type'),
            brand_supranet: I18n.t('quotations.new.header.brands.use_supranet'),
            brand_siemon: I18n.t('quotations.new.header.brands.use_siemon')
          },
          errors:{
            invalid_client: I18n.t('quotations.new.header.errors.client'),
            invalid_date: I18n.t('quotations.new.header.errors.date')
          }
        },
        errors:{
          client:false,
          quotation_date:false,
          type:false,
        },
        quotation:{
          client: null,
          client_nit: '',
          quotation_date: this.today(),
          type: 1,
          use_siemon: true,
          use_supranet: true
        },
        select_options:{
          clients: [],
          quotation_types: [
            {value: 0, text: I18n.t('quotations.new.header.quotation_types.simple')},
            {value: 1, text: I18n.t('quotations.new.header.quotation_types.composed')}
          ]
        },
        quotation_type_blocked: false,
        metadata:{
          nits: {}
        }
      }
    },
    mounted(){
      this.http
      .get('/clients/api/get-all')
      .then((response)=>{
        var data = response.data;
        var clients = this.select_options.clients;
        data.forEach((element)=>{
          clients.push({value: element.id, text: `${element.name}`});
          this.metadata.nits[element.id] = element.nit;
        });
        if(clients.length > 0){
          this.quotation.client = data[0].id;
          this.quotation.client_nit = data[0].nit;
        }
      });
    },
    computed:{
      validateDate: function(){
        this.errors.quotation_date = isNaN(Date.parse(this.quotation.quotation_date));
        if(this.errors.quotation_date){
          this.$emit('update:section_valid', false);
          return false;
        }
        return true;
      },
      validateClient: function(){
        this.errors.client = isNaN(parseFloat(this.quotation.client));
        if(this.errors.client){
          this.$emit('update:section_valid', false);
          return false;
        }
        return true;
      },
      validateQuotationType: function(){
        this.errors.type = this.quotation.type !== 1 && this.quotation.type !== 0;
        if(this.errors.type){
          this.$emit('update:section_valid', false);
          return false;
        }
        return true;
      }
    },
    methods:{
      setClientNit: function(){
        this.quotation.client_nit = this.metadata.nits[this.quotation.client];
      },
      validateSection: function(){
        var section_valid = true;
        for(var key in this.errors){
          section_valid = section_valid && ! this.errors[key];
        }
        this.blockAndEmitChanges(section_valid);
      },
      blockAndEmitChanges(section_valid){
        this.$emit('update:section_valid', section_valid);
        this.$emit('update:current_section_visibility', !section_valid);
        this.$emit('update:next_section_visibility', section_valid);
        this.$emit('update:parent_data',this.quotation);
        if(section_valid){
          this.quotation_type_blocked = true;
        }
      }
    }
  }
</script>

<template>
  <div>
    <b-form>
      <b-form-row>
        <!----------------------------- quotation.client -------------------------------------->
        <div class="col-5">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.client}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select 
              v-model=quotation.client
              :options=select_options.clients
              :state=validateClient
              force-show="true"
              v-on:change=setClientNit
            >
            </b-form-select>
            <b-form-invalid-feedback :state=validateClient>
              {{translations.errors.invalid_client}}
            </b-form-invalid-feedback>

          </div>
        </div>
        <!----------------------------- quotation.client -------------------------------------->

        <!----------------------------- quotation.client_nit ---------------------------------->
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.nit}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-hashtag"></i>
              </div>
            </div>
            <b-input type="text" :disabled=true v-model=quotation.client_nit></b-input>

          </div>
        </div>
        <!----------------------------- quotation.client_nit -----------d----------------------->

        <!------------------------------- quotation.date -------------------------------------->
        <div class="col-3 offset-1">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.date}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-calendar"></i>
              </div>
            </div>
            <b-input type="date" :disabled=true v-model=quotation.quotation_date :state=validateDate force-show=true></b-input>
            <b-form-invalid-feedback :state=validateDate>
              {{translations.errors.invalid_date}}
            </b-form-invalid-feedback>
          </div>
        </div>
        <!------------------------------- quotation.date -------------------------------------->

        <!----------------------------- quotation.quotation_type -------------------------------->
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.quotation_type}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
            </div>
            <b-form-select 
              :disabled=quotation_type_blocked 
              v-model=quotation.type 
              :options=select_options.quotation_types 
              :state=validateQuotationType 
              force-show=true
            ></b-form-select>
          </div>
        </div>
        <!----------------------------- quotation.quotation_type -------------------------------->

        <!------------------------------- quotation.use_supranet --------------------------------->
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <div v-if="this.quotation.type == 1">
            <div class="custom-control custom-checkbox custom-control-inline">
              <input :disabled=quotation_type_blocked  class="custom-control-input" type="checkbox" id="use_supranet" v-model=quotation.use_supranet>
              <label
                for="use_supranet"
                class="custom-control-label mb-0 text-primary font-weight-bold"
              >
                {{translations.titles.brand_supranet}}
              </label>
            </div>
          </div>
        </div>
        <!------------------------------- quotation.use_supranet --------------------------------->

        <!--------------------------------- quotation.use_siemon ---------------------------------->
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <div v-if="this.quotation.type == 1">
            <div class="custom-control custom-checkbox custom-control-inline">
              <input :disabled=quotation_type_blocked  id="use_siemon" class="custom-control-input" type="checkbox" v-model=quotation.use_siemon>
              <label for="use_siemon" class="custom-control-label mb-0 text-primary font-weight-bold">{{translations.titles.brand_siemon}}</label>
            </div>
          </div>
        </div>
        <!--------------------------------- quotation.use_siemon ---------------------------------->

        <!--------------------------------- quotation.submit ---------------------------------->
        <div class="col-2 offset-3">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <button class="btn btn-primary btn-block"  type="submit" v-on:click="validateSection">
            {{translations.next}}
          </button>
        </div>
        <!--------------------------------- quotation.submit ---------------------------------->
      </b-form-row>
    </b-form>
  </div>
</template>
