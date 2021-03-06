<script type="text/javascript">
import componentAutocomplete from '../components/autocomplete.vue';
export default {
  components:{
      'component-autocomplete': componentAutocomplete
  },

  props: ["quotation_type","quotation_id","section_valid"],
  data() {
    return {
      translations: I18n.t('quotations.new_edit.materials'),
      material: {},
      source_api: '/api/products/simple',
      quotation_products: {
        product_id: 0,
        amount: 1,
        percent: 15.0,
        price: 0.0 
      },
      selected_materials: [],
      table_headers: [],
      clear_autocomplete: false
    } 
  },
  methods: {
    getQuotationProducts: function(){
      if(this.quotation_id){
        this.http
        .get(`/api/quotations/${this.quotation_id}/products`)
        .then((response)=>{
          if(response.successful){
            this.selected_materials = response.data;
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      }
    },
    setSource: function(){
      if (this.quotation_type === 't_simple'){
        this.source_api = '/api/products/simple'
      }else{
        this.source_api = '/api/products/per_brand/'+this.quotation_type
      }
    },
    setTableHeaders: function(){
      switch(this.quotation_type){
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
    materialSelected(material){
      this.material = material
      this.quotation_products.product_id = material.id
      this.quotation_products.price = material.product_price
    },
    materialUnselected(){
      this.quotation_products.product_id = null
      this.quotation_products.price=null
    },
    addMaterial(){
      if(this.quotation_products.product_id != null){
        this.clear_autocomplete = true;
        let percentage = this.percentage.format(this.quotation_products.percent)
        let price_percent = (this.quotation_products.price * percentage).toFixed(2)
        let total = this.quotation_products.amount * this.quotation_products.price
        let total_percent = this.quotation_products.amount * price_percent
        
        this.selected_materials.push({
          product_id: this.quotation_products.product_id,
          amount: this.quotation_products.amount,
          code: this.material.code,
          material: this.material.value,
          brand: this.material.brand,
          percent: this.quotation_products.percent,
          price: this.currency.format(this.quotation_products.price),
          total: this.currency.format(total),
          price_percent: this.currency.format(price_percent),
          total_percent: this.currency.format(total_percent)
        });
        this.quotation_products.product_id = null
        this.quotation_products.price = 0
        this.quotation_products.percent = 15
        this.quotation_products.amount = 1
      }else{
        this.alert(this.translations.errors.product_not_selected, 'danger')
      }
      
    },
    formatData: function(){
      var data =  {
          quotation: {
            quotation_products_attributes: this.selected_materials
          }
        };
      return data;
    },
    submit(){
      this.$emit("update:section_valid", false);
      this.http
        .put(`/api/quotations/${this.quotation_id}/update`, this.formatData())
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
    },
    deleteProduct: function(index){
      this.selected_materials.splice(index,1);
    }
  },
  watch: {
    quotation_type: function(){
      this.setTableHeaders();
      this.getQuotationProducts();
      this.setSource();
    }
  }
}
</script>

<template>
  <b-form>
    <b-form-row>
      <div class="col-12">
        <label class="mb-0 text-primary font-weight-bold">{{translations.titles.material}}</label>
        <div class="input-group mb-3" >
          <component-autocomplete
            :clear.sync="clear_autocomplete"
            :placeholder="translations.autocomplete.title"
            :source="source_api"
            @autocomplete:selected="materialSelected"
            @autocomplete:unselected="materialUnselected"
          />
        </div>
      </div>
    </b-form-row>
    <b-form-row>
      <div class="col-1" v-if="quotation_type==='t_supranet'">
        <label class="text-primary font-weight-bold">Supranet</label>
      </div>
      <div class="col-1" v-else-if="quotation_type==='t_simple'">
        <label class="text-primary font-weight-bold">Simple</label>
      </div>
      <div class="col-2">
        <label class="mb-0 text-primary font-weight-bold">{{translations.titles.amount}}</label>
        <div class="input-group mb-2">
          <div class="input-group-prepend">
            <div class="input-group-text bg-white text-primary">
              <i class="fas fa-sort-amount-up"></i>
            </div>
          </div>
          <b-form-input v-model="quotation_products.amount" type="number" min="0" step="1"></b-form-input>
        </div>
      </div>
      <div class="col-2">
        <label class="mb-0 text-primary font-weight-bold">{{translations.titles.price}}</label>
        <div class="input-group mb-2">
          <div class="input-group-prepend">
            <div class="input-group-text bg-white text-primary">
              <i class="fas fa-money-bill-wave"></i>
            </div>
          </div>
          <b-form-input disabled v-model="quotation_products.price"></b-form-input>
        </div>
      </div>
      <div class="col-2">
        <label class="mb-0 text-primary font-weight-bold">{{translations.titles.percent}}</label>
        <div class="input-group mb-2">
          <div class="input-group-prepend">
            <div class="input-group-text bg-white text-primary">
              <i class="fas fa-percentage"></i>
            </div>
          </div>
          <b-form-input v-model="quotation_products.percent" type="number" min="0" step="0.01"></b-form-input>
        </div>
      </div>
      <div class="col-2">
      <br />
        <b-button variant="primary" block @click="addMaterial()">{{translations.buttons.add_material}}</b-button>
      </div>
    </b-form-row>
    <b-table
      thead-tr-class="bg-lomax text-white"
      class="table table-sm table-striped"
      :items="selected_materials"
      :fields="table_headers"
    >
      <template v-if="this.quotation_type==='t_simple'" v-slot:thead-top="data">
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
      <template v-slot:cell(amount)="data">{{ parseInt(data.item.amount) }}</template>
      <template v-slot:cell(name)="data">{{ data.item.name }}</template>
      <template v-slot:cell(actions)="data">
        <b-button class="btn btn-danger" type="button" v-on:click="deleteProduct(data.index)">
          <i class="fas fa-trash-alt fa-xs"></i>
        </b-button>
      </template>
    </b-table>
    <div class="row">
      <div class="col-2 offset-10">
        <button class="btn btn-primary btn-block" type="button" v-on:click="submit">{{translations.buttons.next}}</button>
      </div>
    </div>
  </b-form>
  
</template>
