<script type="text/javascript">
export default {
  props: {
    section_valid: {
      type: Boolean,
      default: false
    },
    quotation_id: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      translations: I18n.t('quotations.new.materials'),
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
              label: this.translations.headers[element]
            });
          });
        break;
        case 't_simple':
          ['amount','code','material','brand','percent','price','total','price_percent','total_percent'].forEach((element)=>{
            this.table_headers.push({
              key:element,
              label:this.translations.headers[element]
            });
          });   
        break;
        default: 
          ['amount','code','material','percent','price','total','price_percent','total_percent'].forEach((element)=>{
            this.table_headers.push({
              key:element,
              label:this.translations.headers[element]
            });
          });    
        break;
      }
      this.table_headers.push({actions: ''});
    },
    comparativeMaterials: function(){
      this.http
      .get("/api/comparative")
      .then(response => {
        if(response.successful){
          this.materials = response.data;
          this.materials = this.materials.map(function(material) {
            return {
              id: material.id,
              name: `${material.name} ${material.description}`
            };
          });
          if (this.materials.length > 0) {
            this.material_id = this.materials[0].id;
          }
        }else{
          this.handleError(response.error);
        }
      })
      .catch(err => {
        console.log("Error", err.stack, err.name, err.message);
      });
    },
    simpleMaterials: function(){
      this.http
      .get("/api/simple")
      .then(response =>{
        if(response.successful){
          this.materials = response.data;
          this.materials = this.materials.map(function(material){
            return{
              id: material.product_id,
              name: `${material.brand} - ${material.name} ${material.description}`,
              material_id: material.material_id,
              product_id: material.product_id,
              brand: material.brand,
              code: material.code,
              price: material.price,
              measure_unit: material.measure_unit
            }
          });
          if (this.materials.length > 0) {
            this.material_id = this.materials[0].id;
            this.prices[0] = this.materials[0].price;
          }
        }else{
          this.handleError(response.error);
        }
      })
      .catch(err => {
        console.log("Error", err.stack, err.name, err.message);
      });
    },
    onlyBrandMaterials: function(){
      this.http
      .get("/api/simple")
      .then(response =>{
        if(response.successful){
          this.materials = response.data;
          this.materials = this.materials.filter(material => material.brand !== this.brands[1]);
          this.materials = this.materials.map(function(material){
            return{
              id: material.material_id,
              name: `${material.name} ${material.description}`,
              product_id: material.product_id,
              brand: material.brand,
              code: material.code,
              price: material.price,
              measure_unit: material.measure_unit
            }
          });
          if (this.materials.length > 0) {
            this.material_id = this.materials[0].id;
          }
        }else{
          this.handleError(response.error);
        }
      })
      .catch(err => {
        console.log("Error", err.stack, err.name, err.message);
      });
    },
    getMaterials: function() {
      if (this.quotation_type === 't_comparative'){
        this.comparativeMaterials();
      }else if(this.quotation_type === 't_simple'){
        this.simpleMaterials();
      }else{
        this.onlyBrandMaterials();
      }
    },
    getProducts: function() {
      this.http
        .get("/api/products_by_material", {
          params: {
            material_id: this.material_id
          }
        })
        .then(response => {
          if(response.successful){
            this.products = response.data;
            if(this.quotation_type!=='t_comparative'){
              this.products = this.products.filter(product => product.brand === this.brands[0]);
            }
            this.setPrices();
          }else{
            this.handleError(response.error);
          }
        })
        .catch(err => {
        console.log("Error", err.stack, err.name, err.message);
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
          if(response.successful){
            this.quotation_type = response.data[0].quotation_type;
            switch (this.quotation_type) {
              case "t_comparative":
                this.brands = ["Supranet", "Siemon"];
                break;
              case "t_siemon_only":
                this.brands = ["Siemon","Supranet"];
                break;
              case "t_supranet_only":
                this.brands = ["Supranet","Siemon"];
                break;
              case "t_simple":
                this.brands = [null];
                break;
            }
            this.getMaterials();
          }else{
            this.handleError(response.error);
          }
        })
        .catch(err => {
          console.log("Error", err.stack, err.name, err.message);
        });
    },
    addComparativeProduct: function(){
      var price_supranet = this.prices[0];
      var price_siemon = this.prices[1];
      var total_supranet = this.quotation_products.amount * price_supranet;
      var total_siemon = this.quotation_products.amount * price_siemon;
      var total_percent_supranet = (total_supranet * this.percentage.format(this.quotation_products.percents[0]));
      var total_percent_siemon = (total_siemon * this.percentage.format(this.quotation_products.percents[1]));
      // Obtaind id for Second product
      var siemon_id = null;
      if (this.products.length>1){
        siemon_id = this.products[1].product_id;
      }
      // Material name
      var material = this.materials.filter(material => material.id === this.material_id);

      this.selected_materials.push({
        material_id: this.material_id,
        amount: `${this.quotation_products.amount}`,
        material: `${material[0].name}`,
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
    },
    addSimpleProduct: function(){
      var material = this.materials.filter(material => material.id === this.material_id);
      var price = material[0].price;
      var total = price * this.quotation_products.amount;
      var total_percent = total * this.percentage.format(this.quotation_products.percents[0]);
      this.selected_materials.push({
        material_id: this.material_id,
        amount: this.quotation_products.amount,
        code: `${material[0].code}`,
        material: `${material[0].name}`,
        brand: `${material[0].brand}`,
        product_id: material[0].product_id,
        percent: this.quotation_products.percents[0],
        price: price,
        total: this.currency.format(total),
        price_percent: price,
        total_percent: this.currency.format(total_percent),
      });
    },
    addProducts: function() {
      var add_product = this.selected_materials.filter(selected => selected.material_id === this.material_id)
      if (add_product.length===0){
        switch(this.quotation_type){
          case 't_comparative':
            this.addComparativeProduct();
            break;
          case 't_simple':
            this.addSimpleProduct();
            break;
          default: 
            this.addSimpleProduct();
            break;
        }
      }
    },
    editService: function(index) {
      let product_data = this.selected_materials[index];
      this.selected_materials.splice(index, 1);
      if(this.quotation_type === 't_comparative'){
        this.quotation_products.percents[0] = product_data.percent_supranet;
        this.quotation_products.percents[1] = product_data.percent_siemon;
        this.quotation_products.amount = product_data.amount;
        this.prices[0] = product_data.price_supranet;
        this.prices[1] = product_data.price_siemon;
        this.material_id = product_data.material_id;
      }else{
        this.quotation_products.percents[0] = product_data.percent;
        this.quotation_products.amount = product_data.amount;
        this.prices[0] = product_data.price;
        this.material_id = product_data.material_id;
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
          if (material.siemon_id !== null) {
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
            this.alert(this.translations.notifications.materials_updated,'success');
          } else {
            this.handleError(response.error);
          }
        })
        .catch(err => {
          console.log("Error", err.stack, err.name, err.message);
        });
    }
  },
  watch: {
    material_id: function() {
      if(this.quotation_type === 't_comparative'){
        this.getProducts();
        this.percents =[15.0,15.0];
        this.amount = 1;
      }else{
        var material = this.materials.filter(material => material.id === this.material_id);
        this.prices[0] = material[0].price;
        this.percents =[15.0,15.0];
        this.amount = 1;
      }
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
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.material}}</label>
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
          <b-button variant="primary" v-on:click="addProducts">{{translations.buttons.add_material}}</b-button>
        </div>
      </b-form-row>
      <b-form-row>
        <div class="col-1" v-if="quotation_type!=='t_simple'">
          <label class="text-primary font-weight-bold">{{brands[0]}}</label>
        </div>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.amount}}</label>
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
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.price}}</label>
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
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.percent}}</label>
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
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.amount}}</label>
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
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.price}}</label>
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
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.percent}}</label>
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
          <b-th colspan="5" class="bg-dark">{{translations.custom_headers.expression}}</b-th>
          <b-th colspan="5" class="bg-dark">{{translations.custom_headers.expression}}</b-th>
          <b-th colspan="1" class="bg-dark text-white"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="5" class="text-center">{{brands[0]}}</b-th>
          <b-th colspan="5" class="text-center">{{brands[1]}}</b-th>
          <b-th colspan="1" class="text-white"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="1" class="text-white"></b-th>
          <b-th colspan="2" class="text-center">{{translations.custom_headers.without_percentage}}</b-th>
          <b-th colspan="2" class="text-center">{{translations.custom_headers.with_percentage}}</b-th>
          <b-th colspan="1" class="text-white"></b-th>
          <b-th colspan="2" class="text-center">{{translations.custom_headers.without_percentage}}</b-th>
          <b-th colspan="2" class="text-center">{{translations.custom_headers.with_percentage}}</b-th>
           <b-th colspan="1" class="text-white"></b-th>
        </b-tr>
      </template>
      <template v-else-if="this.quotation_type==='t_simple'" v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="2" colspan="5" class="bg-dark text-white"></b-th>
          <b-th colspan="4" class="bg-dark">{{translations.custom_headers.expression}}</b-th>
          <b-th colspan="1" class="bg-dark"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="2" class="text-center">{{translations.custom_headers.without_percentage}}</b-th>
          <b-th colspan="2" class="text-center">{{translations.custom_headers.with_percentage}}</b-th>
          <b-th></b-th>
        </b-tr>
      </template>
       <template v-else v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="2" colspan="4" class="bg-dark text-white"></b-th>
          <b-th colspan="4" class="bg-dark">{{translations.custom_headers.expression}}</b-th>
          <b-th  class="bg-dark"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="2" class="text-center">{{translations.custom_headers.without_percentage}}</b-th>
          <b-th colspan="2" class="text-center">{{translations.custom_headers.with_percentage}}</b-th>
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
      <button class="btn btn-primary btn-block" type="submit" v-on:click="submit">{{translations.buttons.next}}</button>
    </div>
  </div>
</template>