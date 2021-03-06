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
    
    data() {
      return {
        translations: I18n.t('quotations.new_edit.services'),
        clear_autocomplete: false,
        form_fields: {
          service_id: 0,
          price: 0,
          amount: 1,
          percent: 0
        },
        services: [],
        quotation_services: [],
        deleted_quotation_services: [],
        table_headers: []
      }
    },

    mounted() {
      this.setTableHeaders();
      this.getQuotationServices();
    },
    
    methods: {
      //When the quotation is in 'created' state, this method gets the services that have
      //been already saved and shows them
      getQuotationServices(){
        if(this.quotation_id){
          this.http
          .get(`/api/quotations/${this.quotation_id}/services`)
          .then((response)=>{
            if(response.successful){
              this.quotation_services = response.data;
            }else{
              this.handleError(response.error);
            }
          }).catch((err)=>{
            console.log("Error", err.stack, err.name, err.message);
          });
        }
      },

      serviceSelected(service){
        this.form_fields.service_id = service.id
        this.form_fields.price = service.price
        this.form_fields.service_name = service.value
      },

      serviceUnselected(){
        this.form_fields.service_id = null
        this.form_fields.price = null
      },

      setTableHeaders() {
        ['amount','service','percent','price','total','total_with_percent','actions'].forEach((element)=>{
          this.table_headers.push({
            key:element,
            label:this.translations.headers[element],
            sortable:true
          });
        });
        //Setting max width for service column
        this.table_headers[1]['tdClass'] = 'w-50';
      },

      addService(event) {
        event.preventDefault();
        var form_data = this.form_fields;
        if(form_data.price){
          var total = form_data.amount * form_data.price



          //Using ES6 to merge form_data and some extra fields into table_data
          var table_data = { ...form_data, ...{
            total: total,
            total_with_percent: form_data.amount * (form_data.price * (1+form_data.percent/100)).toFixed(2),
            service: this.form_fields.service_name
          }};
          //Remove the ID field if it exists
          delete this.form_fields.id;
          this.quotation_services.push(table_data);
          this.alert(this.translations.notifications.remember_save,'info');
          this.clear_autocomplete = true;
        }else{
          this.alert(this.translations.errors.service_not_selected, 'danger');
        }
      },

      updateServices(event) {
        event.preventDefault();
        this.$emit('update:section_valid', false);
        var data = {
          quotation:{
            quotation_services_attributes: this.quotation_services.concat(this.deleted_quotation_services)
          }
        };
        this.deleted_quotation_services = [];
        this.http
        .put(`/quotations/${this.quotation_id}`, data)
        .then((response)=>{
          if(response.successful){
            //We assign an ID received from the server to every service element,
            //so the next time, it will update instead of insert
            var ids = response.data.quotation_services;
            var x = this.quotation_services.map((element,index)=>{
              element.id = ids[index];
              return element;
            });
            this.alert(this.translations.notifications.services_updated,'success');
            this.$emit('update:section_valid', true);
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },
      
      deleteService: function(table_row_data) {
        var quotation_service = this.quotation_services.splice(table_row_data.index, 1)[0];
        //If there is and ID, we have to delete it at the database
        if(quotation_service.id){
          this.deleted_quotation_services.push({id: quotation_service.id, _destroy: true})
        }
      }
    }
  }
</script>

<template>
  <div>
    <b-form @submit=addService>
      <b-form-row>
        <div class="col-12">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.service}} </label>
          <div class="input-group mb-3">
            <component-autocomplete
              :clear.sync="clear_autocomplete"
              :placeholder="translations.autocomplete.title"
              :source="`/api/services`"
              @autocomplete:selected="serviceSelected"
              @autocomplete:unselected="serviceUnselected"
            />
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.price}} </label>
          <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-money-bill"></i>
                </div>
              </div>
            <b-form-input v-model="form_fields.price" :readonly="true"></b-form-input>
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.amount}} </label>
          <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-sort-amount-up-alt"></i>
                </div>
              </div>
            <b-form-input type="number" v-model="form_fields.amount"></b-form-input>
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> {{translations.titles.percent}} </label>
          <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-percentage"></i>
                </div>
              </div>
            <b-form-input type="number" step="0.01" v-model=form_fields.percent></b-form-input>
          </div>
        </div>
        <div class="col-2 offset-4">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
            <button class="btn btn-primary btn-block" type="submit">
              {{translations.buttons.add_service}}
            </button>
        </div>
      </b-form-row>
    </b-form>
    <b-form v-on:submit=updateServices id="services-form">
      <b-form-row>
        <b-table thead-tr-class="bg-lomax text-white text-center" class="table table-sm table-striped" 
          striped
          bordered
          :items=quotation_services 
          :fields=table_headers
        >
          <template v-slot:cell(service)="data">
            <div class="text-break">
              {{data.value}}
            </div>
          </template>
          <template v-slot:cell(amount)="data">
            <div class="text-right">
              {{parseInt(data.value)}}
            </div>
          </template>
          <template v-slot:cell()="data">
            <div class="text-right">
              {{currency.format(data.value)}}
            </div>
          </template>
          <template v-slot:cell(actions)="data">
            <div class="text-right">
              <b-button class="btn btn-danger" v-on:click=deleteService(data)>
                <i class="fas fa-trash-alt fa-xs"></i>
              </b-button>
            </div>
          </template>
        </b-table>
        <div class="col-2 offset-10">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <b-button variant="primary" block type="submit" form="services-form">
            {{translations.buttons.next}}
          </b-button>
        </div>
      </b-form-row>
    </b-form>
  </div>
</template>
