<script type="text/javascript">

  export default{
    props:{
      quotation_code:{
        type: String
      }
    },
    data(){
      return{
        quotations_products:{
          amount: [0.0,0.0],
          percent: [15.0,15.0],
          product_id: null,
        },
        currency: "Q",
        quotation_type:'t_simple',
        material_id: null,
        quantity: 1,
        price: [null,null],
        brand: [null],
        materials: [],
        products:[],
        selected_materials:[],
        header_table: [
          {key: 'quantity', label:'Cantidad'},
          {key: 'code', label:'Código'},
          {key: 'material', label:'Material'},
          {key: 'price_1', label:'Precio'},
          {key: 'percent_1', label:'Holgura %'},
          {key: 'total_price_1', label:'Total sin Holgura'},
          {key: 'total_price_with_percent_1', label:'Total con Holgura'},
          {actions: ''}
        ]
      }
    },
    methods:{
      getMaterials: function(){
        this.http
        .get('/api/materials')
        .then((response)=>{
          this.materials = response.data;
          this.materials = this.materials.map(function(material){return {id: material.id, name: `${material.name} ${material.description}`}});
          if (this.materials.length > 0){
            this.material_id = this.materials[0].id;
            this.getProducts();
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },
      getProducts: function(){
        this.http
        .get('/api/products_by_material', {params: {material_id: this.material_id}})
        .then((response)=>{
          this.products = response.data;
          this.price = this.products.map(function(product){return product.price});
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        })
      },
      getQuotationType: function(){
        this.http
        .get('/api/quotations/type_by_quotation',{params: {code: this.quotation_code}})
        .then((response) =>{
          this.quotation_type = response.data[0].quotation_type;
          switch(this.quotation_type){          
            case 't_comparative': 
              this.brand=['Supranet','Siemon']; 
              this.header_table.pop();
              this.header_table.push(
                {key: 'price_2', label:'Precio'},
                {key: 'percent_2', label:'Holgura %'},
                {key: 'total_price_2', label:'Total sin Holgura'},
                {key: 'total_price_with_percent_2', label:'Total con Holgura'},
                {actions: ''}
              );
              break;
            case 't_siemon_only': 
              this.brand=['Siemon']; 
              break;
            case 't_supranet_only': 
              this.brand=['Supranet']; 
              break;
            case 't_simple':
              this.brand=[null];
              this.header_table.splice(3,0,{key: 'brand', label:'Marca'});
              break;
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        })
      },
      deleteService: function(index) {
        this.selected_materials.splice(index, 1);
      },
      editService: function(index) {
        let product_data = this.selected_materials[index]
        this.selected_materials.splice(index, 1);
        if(this.quotation_type !== 't_comparative'){
          this.quotations_products.percent[0]  = product_data.percent_1;
          this.quantity  = product_data.quantity;
          this.price[0]  = product_data.price_1;
          this.material_id  = product_data.id;
        }
      },
      addProducts: function(){
        var add_product = this.selected_materials.filter(selected => selected.code === this.products[0].code);
        if (add_product.length === 0){
          var material_name = this.materials.filter( material => material.id===this.material_id);
          var total_price = this.price[0] * this.quantity;
          var total_price_with_percent = total_price * ((parseFloat(this.quotations_products.percent[0])/100)+1);
          if(this.quotation_type !== 't_comparative'){
            this.selected_materials.push({
              id: this.material_id,
              quantity: `${this.quantity}`,
              code: `${this.products[0].code}`,
              material: `${material_name[0].name}`,
              price_1: `${this.price[0]}`,
              percent_1: `${this.quotations_products.percent[0]}`,
              total_price_1: `${total_price}`,
              total_price_with_percent_1: `${total_price_with_percent}`
            });
            this.quotations_products.percent=[15.0];
          }else{
            let total_price_2 = this.price[1] * this.quantity;
            console.log(this.quotations_products.percent[1]);
            let total_price_with_percent_2 = total_price * ((this.quotations_products.percent[1]/100)+1);          
            this.selected_materials.push({
              id: this.material_id,
              quantity: `${this.quantity}`,
              code: `${this.products[0].code}`,
              material: `${material_name[0].name}`,
              price_1: `${this.price[0]}`,
              percent_1: `${this.quotations_products.percent[0]}`,
              total_price_1: `${total_price}`,
              total_price_with_percent_1: `${total_price_with_percent}`,
              price_2: `${this.price[1]}`,
              percent_2: `${this.quotations_products.percent[1]}`,
              total_price_2: `${total_price}`,
              total_price_with_percent_2: `${total_price_with_percent_2}`
            });
            this.quotations_products.percent=[15.0,15.0];
          }
        }
      }
    },
    mounted(){
      this.getMaterials();
    },
    watch: {
      material_id: function(){
        this.getProducts();
      },
      quotation_code: function(){
        this.getQuotationType();
      } 
    }
  }
</script>

<template>
  <div>
    <b-form>
      <b-form-row>
        <div class="col-6">
          <label class="mb-0 text-primary font-weight-bold"> Material </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select v-model="material_id" :options=materials value-field="id" text-field="name"></b-form-select>
          </div>
        </div>
        <div class="col-1" right="true">
          <br>
          <b-button variant="primary" v-on:click="addProducts">Agregar</b-button>
        </div>
        <div class="col-1">
          <br>
          <b-form-input v-model="currency"></b-form-input>
        </div>
        <!----------Materials------------->
        <!----------Double---------------->
      </b-form-row>
      <b-form-row>
        <div class="col-1" v-if="quotation_type!='t_simple'">
          <label class="text-primary font-weight-bold">{{brand[0]}}</label>    
        </div>
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Cantidad</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
              <b-form-input v-model="quantity"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Precio</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-money-bill-wave"></i>
              </div>
              <b-form-input disabled v-model="price[0]"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Holgura</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
              <b-form-input v-model="quotations_products.percent[0]"></b-form-input>
            </div>
          </div>
        </div>
      </b-form-row>
      
      <b-form-row  v-if="quotation_type=='t_comparative'">
        <div class="col-1">
          <label class="text-primary font-weight-bold">{{brand[1]}}</label>    
        </div>
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Cantidad</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
              <b-form-input v-model="quantity"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Precio</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-money-bill-wave"></i>
              </div>
              <b-form-input disabled v-model="price[0]"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Holgura</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
              <b-form-input v-model="quotations_products.percent[1]"></b-form-input>
            </div>
          </div>
        </div>
        <!----------Double---------------->
      </b-form-row>
    </b-form>
    <b-card>
      <b-table
        :items="selected_materials"
        :fields="header_table"
        striped 
        hover
        bordered
      >
        <template v-if="this.quotation_type==='t_comparative'" v-slot:thead-top="data">
          <b-tr>
            <b-th colspan="3"></b-th>
            <b-th colspan="4" class="text-center">{{brand[0]}}</b-th>
            <b-th colspan="4" class="text-center">{{brand[1]}}</b-th>
          </b-tr>
        </template>
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
    </b-card>
  </div>
</template>