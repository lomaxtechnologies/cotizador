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
        translations: {
          header: I18n.t('quotations.new.header')
        },
        quotation:{
          client_id: null,
          client_nit: '',
          quotation_date: this.date.today(),
          quotation_type: null
        },
        clients: [],
        quotation_types: []
      }
    },

    mounted(){
      this.getClients();
      this.getQuotationTypes();
    },

    computed:{
      quotationCode: function(){
        if(isNaN(this.quotation_id)){
          return null;
        }
        return this.quotation_id+100;
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
          if(response.successful){
            this.quotation_types = response.data;
            if(this.quotation_types.length > 0){
              this.quotation.quotation_type = this.quotation_types[0].value;
            }
          }else{
            console.log(JSON.stringify(response));
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },

      submitForm: function(){
        if(this.quotation_id){
          this.updateHeader();
        }else{
          this.createHeader();
        }
      },

      createHeader: function(){
        this.$emit('update:section_valid', false);
        this.http
        .post('/quotations', {quotation: this.quotation})
        .then((response)=>{
          if(response.successful){
            this.$emit('update:quotation_id', response.data.id);
            this.$emit('update:section_valid', true);
          }else{
            console.log(JSON.stringify(response));
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },

      updateHeader: function(){
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
    },

    watch:{
      //updates the client's nit when the user changes 
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
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.header.titles.code}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-barcode"></i>
              </div>
            </div>
            <b-input 
              v-model=quotationCode
              type="text"
              :disabled=true
            ></b-input>
          </div>
        </div>
        <div class="col-4">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.header.titles.client}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select 
              v-model=quotation.client_id
              value-field="id"
              text-field="name"
              :required=true
              :options=clients
            >
            </b-form-select>
          </div>
        </div>
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.header.titles.nit}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-hashtag"></i>
              </div>
            </div>
            <b-input type="text" v-model=quotation.client_nit :disabled=true></b-input>

          </div>
        </div>
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.header.titles.date}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-calendar"></i>
              </div>
            </div>
            <b-input type="date" v-model=quotation.quotation_date :disabled=true ></b-input>
          </div>
        </div>
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
              v-model=quotation.quotation_type 
              :disabled=section_valid
              :required=true
              :options=quotation_types
            ></b-form-select>
          </div>
        </div>
        <div class="col-2 offset-7">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <button 
            class="btn btn-primary btn-block"
            type="submit"
          >
            {{translations.header.next}}
          </button>
        </div>
      </b-form-row>
    </b-form>
  </div>
</template>
