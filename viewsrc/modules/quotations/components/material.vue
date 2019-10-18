<script type="text/javascript">

  export default{
    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_id:{
        type: Number,
        default: NaN
      }
    },
    data(){
      return{
        quotations_products:{
          amount: 1,
          percents: [15.0,15.0]
        },
        quotation_type:'t_comparative',
        material_id: null,
        prices: [],
        brands: [],
        materials: [],
        products:[],
        selected_materials:[],
        header_table: [
          {key: 'amount', label:'Cantidad'},
          {key: 'code', label:'Código'},
          {key: 'material', label:'Material'},
          {key: 'price_1', label:'Precio'},
          {key: 'percent', label:'Holgura %'},
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
          this.setPrices();
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        })
      },
      setPrices: function(){
        this.prices = this.products.map(function(product){return product.price});
        if(this.quotation_type==='t_comparative' && this.prices.length===1){
          this.prices[1]=this.prices[0];
        }
      },
      getQuotationType: function(){
        this.http
        .get('/api/quotations/type_by_quotation',{params: {id: this.quotation_id}})
        .then((response) =>{
          this.quotation_type = response.data[0].quotation_type;
          switch(this.quotation_type){          
            case 't_comparative': 
              this.brands=['Supranet','Siemon']; 
              this.header_table.pop();
              this.header_table.push(
                {key: 'price_product_2', label:'Precio'},
                {key: 'percent_product_2', label:'Holgura %'},
                {key: 'total_price_product_2', label:'Total sin Holgura'},
                {key: 'total_price_with_percent_product_2', label:'Total con Holgura'},
                {actions: ''}
              );
              break;
            case 't_siemon_only': 
              this.brands=['Siemon']; 
              break;
            case 't_supranet_only': 
              this.brands=['Supranet']; 
              break;
            case 't_simple':
              this.brands=[null];
              this.header_table.splice(3,0,{key: 'brand', label:'Marca'});
              break;
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        })
      },
      addProducts: function(){
        var add_product = this.selected_materials.filter(selected => selected.code === this.products[0].code);
        if (add_product.length === 0){
          var material_name = this.materials.filter( material => material.id===this.material_id);
          var total_price = (this.prices[0] * this.quotations_products.amount).toFixed(2);
          var total_price_with_percent = (total_price * ((parseFloat(this.quotations_products.percents[0])/100)+1)).toFixed(2);
          if(this.quotation_type !== 't_comparative'){
            if(this.quotation_type === 't_simple'){
              this.selected_materials.push({
                id: this.material_id,
                product_id: `${this.products[0].product_id}`, 
                amount: `${this.quotations_products.amount}`,
                code: `${this.products[0].code}`,
                material: `${material_name[0].name}`,
                brand: `${this.products[0].brand}`,
                price_1: `${this.prices[0]}`,
                percent: `${this.quotations_products.percents[0]}`,
                total_price_1: `${total_price}`,
                total_price_with_percent_1: `${total_price_with_percent}`
              });
            }else{
              this.selected_materials.push({
                id: this.material_id,
                product_id: `${this.products[0].product_id}`, 
                amount: `${this.quotations_products.amount}`,
                code: `${this.products[0].code}`,
                material: `${material_name[0].name}`,
                price_1: `${this.prices[0]}`,
                percent: `${this.quotations_products.percents[0]}`,
                total_price_1: `${total_price}`,
                total_price_with_percent_1: `${total_price_with_percent}`
              });
            }
            this.quotations_products.percents=[15.0];
          }else{
            let total_price_product_2 = (this.prices[1] * this.quotations_products.amount).toFixed(2);
            let total_price_with_percent_product_2 = (total_price_product_2 * ((this.quotations_products.percents[1]/100)+1)).toFixed(2);          
            let product_id = this.products[0].product_id; 
            let product_id_2 = null;
            if (this.products.length>1){
              product_id_2 = this.products[1].product_id;
            }
            this.selected_materials.push({
              id: this.material_id, 
              product_id: product_id,
              product_id_2: product_id_2,
              amount: `${this.quotations_products.amount}`,
              code: `${this.products[0].code}`,
              material: `${material_name[0].name}`,
              price_1: `${this.prices[0]}`,
              percent: `${this.quotations_products.percents[0]}`,
              total_price_1: `${total_price}`,
              total_price_with_percent_1: `${total_price_with_percent}`,
              price_product_2: `${this.prices[1]}`,
              percent_product_2: `${this.quotations_products.percents[1]}`,
              total_price_product_2: `${total_price_product_2}`,
              total_price_with_percent_product_2: `${total_price_with_percent_product_2}`
            });
            this.quotations_products.percents=[15.0,15.0];
          }
        }
      },
      editService: function(index) {
        let product_data = this.selected_materials[index]
        this.selected_materials.splice(index, 1);
        if(this.quotation_type !== 't_comparative'){
          this.quotations_products.percents[0]  = product_data.percent;
          this.quotations_products.amount  = product_data.amount;
          this.prices[0]  = product_data.price_1;
          this.material_id  = product_data.id;
        }
      },
      deleteService: function(index) {
        this.selected_materials.splice(index, 1);
      },
      formatData: function(){
        var data = {
          quotation:{
            quotation_products_attributes: this.selected_materials
          }
        };
        if(this.quotation_type ==='t_comparative'){
          var product_attributes =[]
          this.selected_materials.forEach((material)=>{
            product_attributes.push({
              amount: material.amount, 
              percent: material.percent,
              product_id: material.product_id
            });
            if (material.product_id_2 !== null){
              product_attributes.push({
                amount: material.amount, 
                percent: material.percent,
                product_id: material.product_id_2
              });
            }
          });
          data ={
            quotation:{
              quotation_products_attributes: product_attributes
            }
          };
        }
        return data
      },
      submit: function(){
        this.$emit('update:section_valid', false);
        this.http
        .put(`api/quotations/${this.quotation_id}`, this.formatData())
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
      this.getMaterials();
    },
    watch: {
      material_id: function(){
        this.getProducts();
      },
      quotation_id: function(){
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
          <label class="mb-0 text-primary font-weight-bold">Material</label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select
              v-model="material_id"
              :options="materials"
              value-field="id"
              text-field="name"
            ></b-form-select>
          </div>
        </div>
        <div class="col-1" right="true">
          <br />
          <b-button variant="primary" v-on:click="addProducts">Agregar</b-button>
        </div>
      </b-form-row>
      <b-form-row>
        <div class="col-1" v-if="quotation_type!='t_simple'">
          <label class="text-primary font-weight-bold">{{brands[0]}}</label>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">Cantidad</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
              <b-form-input v-model="quotations_products.amount"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">Precio</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-money-bill-wave"></i>
              </div>
              <b-form-input disabled v-model="prices[0]"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">Holgura</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
              <b-form-input v-model="quotations_products.percents[0]"></b-form-input>
            </div>
          </div>
        </div>
      </b-form-row>

      <b-form-row v-if="quotation_type=='t_comparative'">
        <div class="col-1">
          <label class="text-primary font-weight-bold">{{brands[1]}}</label>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">Cantidad</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
              <b-form-input v-model="quotations_products.amount"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">Precio</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-money-bill-wave"></i>
              </div>
              <b-form-input disabled v-model="prices[1]"></b-form-input>
            </div>
          </div>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">Holgura</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
              <b-form-input v-model="quotations_products.percents[1]"></b-form-input>
            </div>
          </div>
        </div>
        <!----------Double---------------->
      </b-form-row>
    </b-form>
    <b-table 
      thead-tr-class="bg-primary text-white" 
      class="table table-sm table-striped" 
      :items="selected_materials" 
      :fields="header_table">
      <template v-if="this.quotation_type==='t_comparative'" v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="2" colspan="3" class="bg-dark text-white"></b-th>
          <b-th colspan="4" class="bg-dark">Expresión (GTQ)</b-th>
          <b-th colspan="4" class="bg-dark">Expresión (GTQ)</b-th>
          <b-th colspan="1" class="bg-dark text-white"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="4" class="text-center">{{brands[0]}}</b-th>
          <b-th colspan="4" class="text-center">{{brands[1]}}</b-th>
          <b-th colspan="1" class="text-white"></b-th>
        </b-tr>
      </template>
      <template v-slot:cell(name)="data">{{ data.item.name }}</template>
      <template v-slot:cell(actions)="data">
        <b-button class="btn btn-success text-white mr-1" v-on:click="editService(data.index)">
          <i class="fas fa-edit fa-xs text-white"></i>
        </b-button>
        <b-button class="btn btn-danger" type="submit" v-on:click="deleteService(data.index)">
          <i class="fas fa-trash-alt fa-xs"></i>
        </b-button>
      </template>
    </b-table>
    <div class="col-2 offset-10">
      <button 
        class="btn btn-primary btn-block" 
        type="submit"
        v-on:click="submit">
        Siguiente
      </button>
    </div>
  </div>
</template>