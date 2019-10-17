<script type="text/javascript">

  export default{
    props:{
      quotation_code:{
        type: String,
        default: ''
      }
    },
    data(){
      return{
        quotations_products:{
          amount_supranet: [0.0,0.0],
          percent: [15.0,15.0],
          product_id: null,
        },
        quotation_type: 0,
        material_id: null,
        material_name_description: null,
        quantity: [null,null],
        price: [null,null],
        brand: [null,null],
        materials: [],
        products:[],
        selected_materials:[] 
      }
    },
    methods:{
      getMaterials: function(){
        this.http
        .get('/api/materials')
        .then((response)=>{
          this.materials = response.data;
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
          this.brand = this.products.map(function(product){return product.brand});
          console.log(this.price);
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        })
      },
      getQuotationType: function(){
        this.http
        .get('/api/quotations/type_by_quotation',{params: {code: this.quotation_code}})
        .then((response) =>{
          this.quotation_type = response.data;
          console.log(this.quotation_type);
        })
      }
    },
    mounted(){
      this.getMaterials();
    },
    watch: {
      material_id: function(){
        this.getQuotationType();
        this.getProducts();
        var selected_material = this.materials.filter((material)=>{
          return material.id == this.material_id;
        })
        this.material_name_description = selected_material[0].name +" - "+selected_material[0].name;
      }
    }
  }
</script>

<template>
  <div>
    <b-form>
      <b-form-row>
        <div class="col-5">
          <label class="mb-0 text-primary font-weight-bold"> Material </label>
        </div>
        <div class="col-6">
          <label class="text-primary font-weight-bold">Supranet</label>    
        </div>
      </b-form-row>
      <b-form-row>
        <!------------Materials------------>
        <div class="col-5">
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select v-model="material_id" :options=materials value-field="id" text-field="name"></b-form-select>
          </div>
        </div>
        <!----------Materials------------->
        <!----------Double---------------->
        <div class="col-2" >
          <label class="mb-0 text-primary font-weight-bold">Cantidad</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
              <b-form-input v-model="quantity[0]"></b-form-input>
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
      
      <b-form-row>
        <div class="col-6 offset-md-5">
          <label class="text-primary font-weight-bold">Siemon</label>    
        </div>
      </b-form-row>
      <b-form-row>
        <div class="col-2 offset-md-5" >
          <label class="mb-0 text-primary font-weight-bold">Cantidad</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
              <b-form-input v-model="quantity[1]"></b-form-input>
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
        :selected_materials="selected_materials"
      >
      </b-table>
    </b-card>
  </div>
</template>