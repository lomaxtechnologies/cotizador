<script type="text/javascript">

  import componentAutocomplete from '../components/autocomplete.vue';
  
  export default {
    components:{
      'component-autocomplete': componentAutocomplete
    },

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
        display_section: false,
        translations: I18n.t('quotations.new_edit.header'),
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
      this.getQuotationTypes();
      this.getHeader();
      this.setListener();
    },

    methods:{
      setListener(){
        this.bus.$on("autocomplete:selected",(client)=>{
          if(client){
            this.quotation.client_id = client.id;
            this.$set(this.quotation, 'client_nit', client.nit);
          }
        });

        this.bus.$on("autocomplete:unselected",(client)=>{
          this.quotation.client_id = null;
          this.$set(this.quotation, 'client_nit', '');
        });
      },

      getHeader(){
        if(this.quotation_id){
          this.http
          .get(`/api/quotations/${this.quotation_id}/header`)
          .then((response)=>{
            this.display_section = true
            if(response.successful){
              this.quotation = response.data;
            }else{
              this.handleError(response.error);
            }
          }).catch((err)=>{
            console.log("Error", err.stack, err.name, err.message);
          });
        }else{
          this.display_section = true
        }
      },

      getQuotationTypes(){
        this.http
        .get('/api/quotations/types')
        .then((response)=>{
          if(response.successful){
            this.quotation_types = response.data;
            if(!this.quotation_id && this.quotation_types.length > 0){
              this.quotation.quotation_type = this.quotation_types[0].value;
            }
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },

      submitForm(event){
        event.preventDefault();
        if(this.quotation_id){
          this.updateHeader();
        }else{
          this.createHeader();
        }
      },

      createHeader(){
        this.$emit('update:section_valid', false);
        if(this.quotation.client_id){
          this.http
          .post('/quotations', {quotation: this.quotation})
          .then((response)=>{
            if(response.successful){
              this.alert(this.translations.notifications.header_updated,'success');
              this.$emit('update:quotation_id', response.data.id);
              this.$emit('update:section_valid', true);
            }else{
              this.handleError(response.error);
            }
          }).catch((err)=>{
            console.log("Error", err.stack, err.name, err.message);
          });
        }else{
          this.alert(this.translations.errors.client)
        }
      },

      updateHeader(){
        this.$emit('update:section_valid', false);
        this.http
        .put(`/quotations/${this.quotation_id}`, {quotation: this.quotation})
        .then((response)=>{
          if(response.successful){
            this.alert(this.translations.notifications.header_updated,'success');
            this.$emit('update:section_valid', true);
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      }
    }
  }
</script>

<template>
  <section v-if="display_section">
    <b-form v-on:submit=submitForm>
      <b-form-row>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles.code}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-barcode"></i>
              </div>
            </div>
            <b-input 
              v-model="quotation_id"
              type="text"
              :readonly="true"
            ></b-input>
          </div>
        </div>
        <div class="col-4">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles.client}}
          </label>
          <div class="input-group mb-3">
            <component-autocomplete
              :prefix="'header'"
              :placeholder="translations.autocomplete.title"
              :source="`/api/clients`"
              :value="{id: quotation.client_id, value: quotation.client_name}"
            />
          </div>
        </div>
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles.nit}}
          </label>
          <div class="input-group mb-3">
            <b-input type="text" v-model="quotation.client_nit" :readonly="true"></b-input>
          </div>
        </div>
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles.date}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-calendar"></i>
              </div>
            </div>
            <b-input type="date" v-model=quotation.quotation_date :readonly="true" ></b-input>
          </div>
        </div>
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles.quotation_type}}
          </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
            </div>
            <b-form-select
              v-model="quotation.quotation_type"
              :disabled="quotation_id!=null"
              :required="true"
              :options="quotation_types"
            ></b-form-select>
          </div>
        </div>
        <div class="col-2 offset-7">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <button 
            class="btn btn-primary btn-block"
            type="submit"
          >
            {{translations.next}}
          </button>
        </div>
      </b-form-row>
    </b-form>
  </section>
</template>
