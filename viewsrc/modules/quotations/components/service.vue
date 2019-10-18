<script type="text/javascript">

  import axios from 'axios'

  export default {
    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_id:{
        type:Number,
        default: NaN
      }
    },
    data () {
      return {
        translations: I18n.t('quotations.new.services'),
          quotation: {
            service: 0,
            price: 0,
            amount: 0,
            percent: 0,
        },
        result_without_percent: 0,
        result_percent: 0,
        services: [],
        select_list_service: [],
        items: [],
        fields: [
            {
              key: 'service', label: 'Servicio'
            },
             {
              key: 'price', label: 'Precio'
            },
             {
              key: 'amount', label: 'cantidad'
            },
             {
              key: 'percent', label: 'Holgura'
            },
            {
              key: 'result_without_percent', label: 'Resultado sin holgura'
            },
            {
              key: 'result_percent', label: 'Resultado con holgura'
            },
            {
              actions: '',
            }
        ]
      }
    },
    methods: {
      getService () {
        this.http
        .get('api/services/')
        .then(response => {
          this.services= response.data
          if(this.services.length > 0){
                this.quotation.service = this.services[0].id
                this.quotation.price = this.services[0].price

          }
          }).catch((err)=>{
          console.log(JSON.stringify(err));
          });
        },
      insertService () {
        this.result_without_percent = (this.quotation.amount * this.quotation.price)
        this.result_percent =  this.result_without_percent +((this.result_without_percent)*this.quotation.percent /100)
        var selected_service = this.services.filter((service)=>{
          return service.id == this.quotation.service;
        });
        this.quotation.service  = selected_service[0].id
        var insert_Service = this.select_list_service.filter(selected => selected.id === this.quotation.service);  
        if (insert_Service.length=== 0){
          this.select_list_service.push({
          service: selected_service[0].name,
          price: this.quotation.price,
          amount: this.quotation.amount,
          percent:this.quotation.percent,
          result_without_percent: this.result_without_percent,
          result_percent: this.result_percent, 
          actions: '',
          id: this.quotation.service
        })
           }
      },
      deleteService: function(index) {
        this.select_list_service.splice(index, 1);
      },
      editService: function(index) {
        let service_data = this.select_list_service[index]
        this.select_list_service.splice(index, 1);
        this.quotation.service  = service_data.id;
        this.quotation.price  = service_data.price;
        this.quotation.amount  = service_data.amount;
        this.quotation.percent  = service_data.percent;
      },
      validateAndUpdate(){
        this.$emit('update:section_valid', false);
        this.quotation.service_id = this.quotation.service;
        var data = {quotation:{ quotation_services_attributes:[this.quotation]}};
        this.http
        .put(`api/quotations/${this.quotation_id}`, data)
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
      mounted(){
        this.getService()
      },
      watch: {
        'quotation.service': function(){
          var selected_service = this.services.filter((service)=>{
         return service.id == this.quotation.service;
          });
            this.quotation.price  = selected_service[0].price
        }
      }
  }
</script>

<template>
  <div>
    <b-form>
      <b-form-row>
        <div class="col-4">
          <label class="mb-0 text-primary font-weight-bold"> Servicio </label>
            <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-user-alt"></i>
                </div>
              </div>
              <b-form-select 
                v-model="quotation.service" 
                :options=services
                value-field = "id"
                text-field = "name" 
                disabled-field="notEnabled">
              </b-form-select>
            </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> Precio </label>
            <div class="input-group mb-3">
                <div class="input-group-prepend">
                  <div class="input-group-text bg-white text-primary">
                    <i class="fas fa-money-bill"></i>
                  </div>
                </div>
              <b-form-input type="number" v-model="quotation.price"></b-form-input>
            </div>
        </div>

        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> Cantidad </label>
          <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-sort-amount-up-alt"></i>
                </div>
              </div>
            <b-form-input type="number" v-model="quotation.amount"></b-form-input>
          </div>
        </div>

        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> Holgura </label>
          <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-percentage"></i>
                </div>
              </div>
            <b-form-input type="number" v-model="quotation.percent"></b-form-input>
          </div>
        </div>
      
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
            <button class="btn btn-primary btn-block" v-on:click="insertService">
              Agregar
            </button>
        </div>
        </b-form-row>
      </b-form>
      <b-form v-on:submit=validateAndUpdate>
        <b-form-row>
          <b-table thead-tr-class="bg-primary text-white" class="table table-sm table-striped" 
            striped hover 
            :items="select_list_service" 
            :fields ="fields">    
              <template v-slot:cell(name)="data">
                {{ data.item.name }}
              </template>
              <template v-slot:cell(actions)="data">
                <b-button class="btn btn-success text-white mr-1" v-on:click="editService(data.index)">
                  <i class="fas fa-edit fa-xs text-white"></i>
                </b-button>
                <b-button class="btn btn-danger" type="submit" v-on:click="deleteService(data.index)">
                  <i class="fas fa-trash-alt fa-xs"></i>
                </b-button>
              </template>
          </b-table>
          <div class="col-2 offset-7">
            <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
            <button 
              class="btn btn-primary btn-block"
              type="submit"
            >
          Siguiente
     </button>
        </div>
        </b-form-row>
      </b-form>
    </div>
</template>
