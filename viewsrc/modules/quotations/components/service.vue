<script type="text/javascript">

  import axios from 'axios'

  export default {
    data () {
      return {
        translations: I18n.t('quotations.new.services'),
          quotation: {
            service: 0,
            price: 0,
            amount: 0,
            persent: 0,
        },
        result_without_persent: 0,
        result_persent: 0,
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
              key: 'persent', label: 'Holugra'
            },
            {
              key: 'result_without_persent', label: 'Resultado sin holgura'
            },
            {
              key: 'result_persent', label: 'Resultado con holgura'
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
        this.result_without_persent = (this.quotation.amount * this.quotation.price)
        this.result_persent =  this.result_without_persent +((this.result_without_persent)*this.quotation.persent /100)
        var selected_service = this.services.filter((service)=>{
         return service.id == this.quotation.service;
          });
          this.quotation.service  = selected_service[0].id
          this.select_list_service.push({
          service: selected_service[0].name,
          price: this.quotation.price,
          amount: this.quotation.amount,
          persent:this.quotation.persent,
          result_without_persent: this.result_without_persent,
          result_persent: this.result_persent, 
          actions: '',
          id: this.quotation.service
          
        })
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
        this.quotation.persent  = service_data.persent;
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
            <b-input type="number" v-model="quotation.price"></b-input>
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
            <b-form-input type="number" v-model="quotation.persent"></b-form-input>
          </div>
        </div>
      
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <button class="btn btn-primary btn-block" type="submit" v-on:click="insertService">
            Agregar
          </button>
        </div>
      <b-table striped hover :items="select_list_service" :fields ="fields">    
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
      </b-form-row>
    </b-form>
  </div>
</template>
