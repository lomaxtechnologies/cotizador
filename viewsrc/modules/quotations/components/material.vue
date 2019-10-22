<script type="text/javascript">
export default {
  props: {
    section_valid: {
      type: Boolean,
      default: false
    },
    quotation_id: {
      type: Number,
      default: NaN
    }
  },
  data() {
    return {
      translations: {
        material: I18n.t('quotations.material')
      },
      quotation_products: {
        amount: 1,
        percents: [15.0,15.0]
      },
      quotation_type: null,
      material_id: null,
      materials: [],
      products: [],
      prices: [],
      brands: [],
      selected_materials: [],
      table_headers: []
    };
  },
  methods: {
    setTableHeaders: function(){
      switch(this.quotation_type){
        case 't_comparative': 
        ['amount',
          'material',
          'percent_supranet',
          'price_supranet',
          'total_supranet',
          'price_percent_supranet',
          'total_percent_supranet',
          'percent_siemon',
          'price_siemon',
          'total_siemon',
          'price_percent_siemon',
          'total_percent_siemon'].forEach((element)=>{
            this.table_headers.push({
              key: element,
              label: this.translations.material.headers[element]
            });
          });
        break;
        case 't_simple':
          ['amount','material','brand','percent','price','total','price_percent','total_percent'].forEach((element)=>{
            this.table_headers.push({
              key:element,
              label:this.translations.material.headers[element]
            });
          });   
        break;
        default: 
          ['amount','material','percent','price','total','price_percent','total_percent'].forEach((element)=>{
            this.table_headers.push({
              key:element,
              label:this.translations.material.headers[element]
            });
          });    
        break;
      }
      this.table_headers.push({actions: ''});
    },
    getMaterials: function() {
      if (this.quotation_type === 't_comparative'){
        this.http
        .get("/api/materials")
        .then(response => {
          this.materials = response.data;
          this.materials = this.materials.map(function(material) {
            return {
              id: material.id,
              name: `${material.name} ${material.description}`
            };
          });
          if (this.materials.length > 0) {
            this.material_id = this.materials[0].id;
            this.getProducts();
          }
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
      }else{
        this.http
        .get("/api/products_by_brand",{
          params:{
            brand_name: this.brands[0]
          }
        })
        .then(response =>{
          this.materials = response.data;
          if(this.quotation_type==='t_simple'){
            this.materials = this.materials.map(function(material){
              return{
                id: material.product_id,
                name: `${material.brand} - ${material.name} ${material.description}`,
                material_id: material.material_id,
                brand: material.brand
              }
            });
          }else{
            this.materials = this.materials.map(function(material){
              return{
                id: material.material_id,
                name: `${material.name} ${material.description}`,
                brand: material.brand
              }
            });
          }
          if (this.materials.length > 0) {
            this.material_id = this.materials[0].id;
            this.getProducts();
          }
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
      }
    },
    getProducts: function(product_id) {
      this.http
        .get("/api/products_by_material", {
          params: {
            material_id: product_id
          }
        })
        .then(response => {
          this.products = response.data;
          console.log(this.products);
          if(this.quotation_type!=='t_comparative'){
            this.products = this.products.filter(
              material => material.brand === this.materials[this.material_id].brand
            )
          }
          this.setPrices();
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
    },
    setPrices: function() {
      this.prices = this.products.map(function(product) {
        return product.price;
      });
      if (this.quotation_type === "t_comparative" && this.prices.length === 1) {
        this.prices[1] = this.prices[0];
      }
    },
    getQuotationType: function() {
      this.http
        .get(`/api/quotations/${this.quotation_id}/type`)
        .then(response => {
          this.quotation_type = response.data[0].quotation_type;
          switch (this.quotation_type) {
            case "t_comparative":
              this.brands = ["Supranet", "Siemon"];
              break;
            case "t_siemon_only":
              this.brands = ["Siemon"];
              break;
            case "t_supranet_only":
              this.brands = ["Supranet"];
              break;
            case "t_simple":
              this.brands = [null];
              break;
          }
          this.getMaterials();
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
    },
    addProducts: function() {
      var add_product = this.selected_materials.filter(selected => selected.material_id === this.material_id)
      if (add_product>0){
      }else{
        switch(this.quotation_type){
          case 't_comparative':
            var price_supranet = this.prices[0];
            var price_siemon = this.prices[1];
            var total_supranet = this.quotation_products.amount * price_supranet;
            var total_siemon = this.quotation_products.amount * price_siemon;
            var total_percent_supranet = (total_supranet * this.currency.format_percent(this.quotation_products.percents[0]));
            var total_percent_siemon = (total_siemon * this.currency.format_percent(this.quotation_products.percents[1]));

            var siemon_id = null;
            if (this.products.length>1){
              siemon_id = this.products[1].product_id;
            }
            
            this.selected_materials.push({
              material_id: `${this.material_id}`,
              amount: `${this.quotation_products.amount}`,
              material: `${this.materials[this.material_id].name}`,
              supranet_id: `${this.products[0].product_id}`,
              percent_supranet: `${this.quotation_products.percents[0]}`,
              price_supranet: price_supranet,
              total_supranet: `${total_supranet.toFixed(2)}`,
              price_percent_supranet: price_supranet,
              total_percent_supranet: total_percent_supranet.toFixed(2),
              siemon_id: siemon_id,
              percent_siemon: `${this.quotation_products.percents[1]}`,
              price_siemon: price_siemon,
              total_siemon: `${total_siemon.toFixed(2)}`,
              price_percent_siemon: price_siemon,
              total_percent_siemon: total_percent_siemon.toFixed(2)
            });
            break;
          case 't_simple':
            var price = this.prices[0];
            var total = price * this.quotation_products.amount;
            var total_percent = total * this.currency.format_percent(this.quotation_products.percents[0]);
            console.log(this.products[0].brand);
            console.log(this.products);
            this.selected_materials.push({
              material_id: `${this.material_id}`,
              amount: `${this.quotation_products.amount}`,
              material: `${this.materials[this.material_id].name}`,
              brand: `${this.materials[this.material_id].brand}`,
              product_id: `${this.products[0].product_id}`,
              percent: `${this.quotation_products.percents[0]}`,
              price: price,
              total: `${total.toFixed(2)}`,
              price_percentt: price,
              total_percent: total_percent.toFixed(2),
            });
            break;
          default: 
            var price = this.prices[0];
            var total = price * this.quotation_products.amount;
            var total_percent = total * this.currency.format_percent(this.quotation_products.percents[0]);
            this.selected_materials.push({
              material_id: `${this.material_id}`,
              amount: `${this.quotation_products.amount}`,
              material: `${this.materials[this.material_id].name}`,
              product_id: `${this.products[0].product_id}`,
              percent: `${this.quotation_products.percents[0]}`,
              price: price,
              total: `${total.toFixed(2)}`,
              price_percentt: price,
              total_percent: total_percent.toFixed(2),
            });
            break;
        }
      }
    },
    editService: function(index) {
      let product_data = this.selected_materials[index];
      this.selected_materials.splice(index, 1);
      if (this.quotation_type !== "t_comparative") {
        this.quotation_products.percents[0] = product_data.percent;
        this.quotation_products.amount = product_data.amount;
        this.prices[0] = product_data.price;
        this.material_id = product_data.id;
      }else{
        this.quotation_products.percents[0] = product_data.percent_supranet;
        this.quotation_products.percents[1] = product_data.percent_siemon;
        this.quotation_products.amount = product_data.amount;
        this.prices[0] = product_data.price_supranet;
        this.prices[1] = product_data.price_siemon;
        this.material_id = product_data.id;
      }
    },
    deleteService: function(index) {
      this.selected_materials.splice(index, 1);
    },
    formatData: function() {
      var data;
      if (this.quotation_type === "t_comparative") {
        var product_attributes = [];
        this.selected_materials.forEach(material => {
          product_attributes.push({
            amount: material.amount,
            percent: material.percent_supranet,
            product_id: material.supranet_id
          });
          if (material.product_siemon_id !== null) {
            product_attributes.push({
              amount: material.amount,
              percent: material.percent_siemon,
              product_id: material.siemon_id
            });
          }
        });
        data = {
          quotation: {
            quotation_products_attributes: product_attributes
          }
        };
      }else{
        data = {
          quotation: {
            quotation_products_attributes: this.selected_materials
          }
        };
      }
      return data;
    },
    submit: function() {
      this.$emit("update:section_valid", false);
      this.http
        .put(`api/quotations/${this.quotation_id}/update`, this.formatData())
        .then(response => {
          if (response.successful) {
            this.$emit("update:section_valid", true);
          } else {
            console.log(JSON.stringify(response.error));
          }
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
    }
  },
  watch: {
    material_id: function() {
      var product_id = this.material_id;
      if (this.quotation_type === 't_simple'){
        product_id = this.materials[this.material_id].material_id;
      }
      this.getProducts(product_id);
    },
    quotation_id: function() {
      this.getQuotationType();
    },
    quotation_type: function(){
      this.setTableHeaders();
    }
  }
};
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
              <b-form-input v-model="quotation_products.amount"></b-form-input>
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
              <b-form-input v-model="quotation_products.percents[0]"></b-form-input>
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
              <b-form-input v-model="quotation_products.amount"></b-form-input>
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
              <b-form-input v-model="quotation_products.percents[1]"></b-form-input>
            </div>
          </div>
        </div>
      </b-form-row>
    </b-form>
    <b-table
      thead-tr-class="bg-primary text-white"
      class="table table-sm table-striped"
      :items="selected_materials"
      :fields="table_headers"
    >
      <template v-if="this.quotation_type==='t_comparative'" v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="3" colspan="2" class="bg-dark text-white"></b-th>
          <b-th colspan="5" class="bg-dark">Expresión (GTQ)</b-th>
          <b-th colspan="5" class="bg-dark">Expresión (GTQ)</b-th>
          <b-th colspan="1" class="bg-dark text-white"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="5" class="text-center">{{brands[0]}}</b-th>
          <b-th colspan="5" class="text-center">{{brands[1]}}</b-th>
          <b-th colspan="1" class="text-white"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="1" class="text-white"></b-th>
          <b-th colspan="2" class="text-center">Sin holgura</b-th>
          <b-th colspan="2" class="text-center">Con holgura</b-th>
          <b-th colspan="1" class="text-white"></b-th>
          <b-th colspan="2" class="text-center">Sin holgura</b-th>
          <b-th colspan="2" class="text-center">Con holgura</b-th>
           <b-th colspan="1" class="text-white"></b-th>
        </b-tr>
      </template>
      <template v-else-if="this.quotation_type==='t_simple'" v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="2" colspan="4" class="bg-dark text-white"></b-th>
          <b-th colspan="4" class="bg-dark">Expresión (GTQ)</b-th>
          <b-th></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="2" class="text-center">Sin holgura</b-th>
          <b-th colspan="2" class="text-center">Con holgura</b-th>
          <b-th></b-th>
        </b-tr>
      </template>
       <template v-else v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="2" colspan="3" class="bg-dark text-white"></b-th>
          <b-th colspan="4" class="bg-dark">Expresión (GTQ)</b-th>
          <b-th></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="2" class="text-center">Sin holgura</b-th>
          <b-th colspan="2" class="text-center">Con holgura</b-th>
          <b-th></b-th>
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
      <button class="btn btn-primary btn-block" type="submit" v-on:click="submit">Siguiente</button>
    </div>
  </div>
</template>