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
        translations: {
          header: I18n.t('quotations.new.header'),
          quotation_types: I18n.t('quotations.quotation_types')
        },
        quotation:{
          client_id: null,
          client_nit: '',
          quotation_date: this.date.today(),
          quotation_type: null
        },
        clients: [],
        quotation_types: {},
        errors:{
          client:false
        }
      }
    },
    mounted(){
      this.getClients();
      this.getQuotationTypes();
    },
    computed:{
      validateClient: function(){
        this.errors.client = isNaN(parseFloat(this.quotation.client_id));
        return this.errors.client;
      }
    },
    methods:{

      getClients: function(){
        this.http
        .get('api/clients')
        .then((response)=>{
          this.clients = response.data;
          if(this.clients.length > 0){
            this.quotation.client_id = this.clients[0].id;
            this.quotation.client_nit = this.clients[0].nit;
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },

      getQuotationTypes: function(){
        this.http
        .get('api/quotations/types')
        .then((response)=>{
          this.quotation_types = response.data;
          for(var key in this.quotation_types){
            this.quotation_types[key] = this.translations.quotation_types[key];
          }
          if(this.quotation_types){
            this.quotation.quotation_type = Object.keys(this.quotation_types)[0];
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },

      validateForm: function(){
        var section_valid = true;
        for(var key in this.errors){
          section_valid = section_valid && ! this.errors[key];
        }
        return section_valid;
      },

      submitForm: function(){
        if(this.quotation_code){
          this.validateAndUpdate();
        }else{
          this.validateAndCreate();
        }
      },

      validateAndCreate: function(){
        this.$emit('update:section_valid', false);
        if(this.validateForm()){
          var data = {quotation: this.quotation};
          this.http
          .post('api/quotations/header', data)
          .then((response)=>{
            if(response.successful){
              this.$emit('update:quotation_code', String(response.data.code));
              this.$emit('update:quotation_id', response.data.id);
              this.$emit('update:section_valid', true);
            }else{
              console.log(JSON.stringify(response.error));
            }
          }).catch((err)=>{
            console.log(JSON.stringify(err));
          });
        }
      },

      validateAndUpdate: function(){
        this.$emit('update:section_valid', false);
        if(this.validateForm()){
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
    },
    watch:{
      'quotation.client_id': function(){
        var selected_client = this.clients.filter((client)=>{
          return client.id == this.quotation.client_id;
        });
        this.quotation.client_nit = selected_client[0].nit;
      }
    }
  }
</script>

<template>
  <div>
    <b-form v-on:submit=submitForm>
      <b-form-row>
        <!------------------------------- quotation.code -------------------------------------->
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.header.titles.code}} </label>
          <div class="input-group mb-3" v-b-tooltip.hover title="Tooltip directive content">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-barcode"></i>
              </div>
            </div>
            <b-input 
              type="text"
              :disabled=true
              v-model=quotation_code
            ></b-input>
          </div>
        </div>
        <!------------------------------- quotation.code -------------------------------------->

        <!----------------------------- quotation.client -------------------------------------->
        <div class="col-4">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.header.titles.client}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select 
              v-model=quotation.client_id
              :options=clients
              value-field="id"
              text-field="name"
            >
            </b-form-select>
          </div>
        </div>
        <!----------------------------- quotation.client -------------------------------------->

        <!----------------------------- quotation.client_nit ---------------------------------->
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.header.titles.nit}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-hashtag"></i>
              </div>
            </div>
            <b-input type="text" :disabled=true v-model=quotation.client_nit></b-input>

          </div>
        </div>
        <!----------------------------- quotation.client_nit ---------------------------------->

        <!------------------------------- quotation.date -------------------------------------->
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.header.titles.date}} </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-calendar"></i>
              </div>
            </div>
            <b-input type="date" :disabled=true v-model=quotation.quotation_date></b-input>
          </div>
        </div>
        <!------------------------------- quotation.date -------------------------------------->

        <!----------------------------- quotation.quotation_type ------------------------------>
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.header.titles.quotation_type}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
            </div>
            <b-form-select
              :disabled=section_valid
              v-model=quotation.quotation_type 
              :options=quotation_types
            ></b-form-select>
          </div>
        </div>
        <!----------------------------- quotation.quotation_type ------------------------------>

        <!--------------------------------- quotation.submit ---------------------------------->
        <div class="col-2 offset-7">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <button 
            class="btn btn-primary btn-block"
            type="submit"
          >
            {{translations.header.next}}
          </button>
        </div>
        <!--------------------------------- quotation.submit ---------------------------------->

      </b-form-row>
    </b-form>
  </div>
</template>
