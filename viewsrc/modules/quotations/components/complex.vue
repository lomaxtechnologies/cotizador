<script type="text/javascript">
import componentAutocomplete from '../components/autocomplete.vue';
export default {
  components:{
      'component-autocomplete': componentAutocomplete
  },
  props: ["quotation_id"],
  data() {
    return {
      translations: I18n.t('quotations.new_edit.materials'),
      material: {},
      quotation_products: {
        amount: 1,
        siemon_percent: 15,
        supranet_percent: 15,
        supranet_price: 0,
        siemon_price: 0 
      },
      supranet_material: null,
      siemon_material: null,
      selected_siemon_materials: [],
      selected_supranet_materials: [],
      selected_materials: [],
      table_headers: [],
      clear_siemon_autocomplete: false,
      clear_supranet_autocomplete: false
    } 
  },
  methods: {
    getQuotationProducts: function(){
      if(this.quotation_id){
        this.http
        .get(`/api/quotations/${this.quotation_id}/complex_products`)
        .then((response)=>{
          if(response.successful){
            this.selected_materials = response.data;
            this.selected_siemon_materials = response.data.splice(0,this.selected_materials.length/2)
            this.selected_supranet_materials = this.selected_materials.slice(0)
            let cont = 0
            this.selected_siemon_materials.forEach(material => {
              this.selected_materials[cont].material = material.material
              this.selected_materials[cont].percent_siemon = material.percent_siemon
              this.selected_materials[cont].price_percent_siemon = material.price_percent_siemon
              this.selected_materials[cont].price_siemon = material.price_siemon
              this.selected_materials[cont].total_percent_siemon = material.total_percent_siemon
              this.selected_materials[cont].total_siemon = material.total_siemon
              cont++
            })
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      }
    },
    setTableHeaders: function(){
    ['amount','material','percent_siemon','price_siemon','total_siemon','price_percent_siemon',
        'total_percent_siemon','percent_supranet','price_supranet','total_supranet','price_percent_supranet',
      'total_percent_supranet'].forEach((element)=>{
          this.table_headers.push({
            key: element,
            label: this.translations.headers[element]
          });
          });
      this.table_headers.push({actions: ''});
    },
    materialSiemonSelected(material){
      this.siemon_material = material
      this.quotation_products.siemon_price = material.product_price
    },
    materialSiemonUnselected(){
      this.siemon_material = null
      this.quotation_products.siemon_price=0
    },
    materialSupranetSelected(material){
      this.supranet_material = material
      this.quotation_products.supranet_price = material.product_price
    },
    materialSupranetUnselected(){
      this.supranet_material = null
      this.quotation_products.supranet_price=0
    },
    addMaterial(){
      
      if (this.siemon_material !== null  && this.supranet_material !== null){
        this.clear_siemon_autocomplete = true;
        this.clear_supranet_autocomplete = true;    
        
        let total_siemon = this.quotation_products.amount * this.quotation_products.siemon_price;
        let siemon_price_percent = (this.quotation_products.siemon_price * this.percentage.format(this.quotation_products.siemon_percent)).toFixed(2);
        let total_percent_siemon = this.quotation_products.amount * siemon_price_percent;
        let total_supranet = this.quotation_products.amount * this.quotation_products.supranet_price;
        let supranet_price_percent = (this.quotation_products.supranet_price * this.percentage.format(this.quotation_products.supranet_percent)).toFixed(2);

        let total_percent_supranet = this.quotation_products.amount * supranet_price_percent;
      
        this.selected_materials.push({
          amount: this.quotation_products.amount,
          material: this.siemon_material.value,
          percent_supranet: this.quotation_products.supranet_percent,
          price_supranet: this.quotation_products.supranet_price,
          total_supranet: total_supranet.toFixed(2),
          price_percent_supranet: supranet_price_percent,
          total_percent_supranet: total_percent_supranet.toFixed(2),
          percent_siemon: this.quotation_products.siemon_percent,
          price_siemon: this.quotation_products.siemon_price,
          total_siemon: total_siemon.toFixed(2),
          price_percent_siemon: siemon_price_percent,
          total_percent_siemon: total_percent_siemon.toFixed(2)
        });

        this.selected_supranet_materials.push({
          amount: this.quotation_products.amount,
          percent: this.quotation_products.supranet_percent,
          product_id: this.supranet_material.id,
        })
        this.selected_siemon_materials.push({
          amount: this.quotation_products.amount,
          percent: this.quotation_products.siemon_percent,
          product_id: this.siemon_material.id,
        })
        
        this.supranet_material = null;
        this.siemon_material = null;
        this.quotation_products.supranet_percent = 15
        this.quotation_products.siemon_percent = 15
        this.quotation_products.siemon_price = 0
        this.quotation_products.supranet_price = 0
        this.quotation_products.amount = 1
      }else if(this.siemon_material !== null){
        this.clear_siemon_autocomplete = true;
        this.clear_supranet_autocomplete = true;    
        
        let total_siemon = this.quotation_products.amount * this.quotation_products.siemon_price
        let siemon_price_percent = this.quotation_products.siemon_price * this.percentage.format(this.quotation_products.siemon_percent) 
        let total_percent_siemon = total_siemon * this.percentage.format(this.quotation_products.siemon_percent)
    
        this.selected_materials.push({
          amount: this.quotation_products.amount,
          material: this.siemon_material.value,
          percent_supranet: this.quotation_products.siemon_percent,
          price_supranet: this.quotation_products.siemon_price,
          total_supranet: `${total_siemon.toFixed(2)}`,
          price_percent_supranet: siemon_price_percent.toFixed(2),
          total_percent_supranet: total_percent_siemon.toFixed(2),
          percent_siemon: this.quotation_products.siemon_percent,
          price_siemon: this.quotation_products.siemon_price,
          total_siemon: `${total_siemon.toFixed(2)}`,
          price_percent_siemon: siemon_price_percent.toFixed(2),
          total_percent_siemon: total_percent_siemon.toFixed(2)
        });

        this.selected_supranet_materials.push({
          amount: this.quotation_products.amount,
          percent: this.quotation_products.siemon_percent,
          product_id: this.siemon_material.id,
        })
        this.selected_siemon_materials.push({
          amount: this.quotation_products.amount,
          percent: this.quotation_products.siemon_percent,
          product_id: this.siemon_material.id,
        })
        this.supranet_material = null;
        this.siemon_material = null;
        this.quotation_products.supranet_percent = 15
        this.quotation_products.siemon_percent = 15
        this.quotation_products.siemon_price = 0
        this.quotation_products.supranet_price = 0
        this.quotation_products.amount = 1
      }else if(this.supranet_material!==null){
        this.clear_siemon_autocomplete = true;
        this.clear_supranet_autocomplete = true;    
        
        let total_supranet = this.quotation_products.amount * this.quotation_products.supranet_price;
        let supranet_price_percent = this.quotation_products.supranet_price * this.percentage.format(this.quotation_products.supranet_percent)
        let total_percent_supranet = total_supranet * this.percentage.format(this.quotation_products.supranet_percent)
      
        this.selected_materials.push({
          amount: this.quotation_products.amount,
          material: this.supranet_material.value,
          percent_supranet: this.quotation_products.supranet_percent,
          price_supranet: this.quotation_products.supranet_price,
          total_supranet: `${total_supranet.toFixed(2)}`,
          price_percent_supranet: supranet_price_percent.toFixed(2),
          total_percent_supranet: total_percent_supranet.toFixed(2),
          percent_siemon: this.quotation_products.supranet_percent,
          price_siemon: this.quotation_products.supranet_price,
          total_siemon: `${total_supranet.toFixed(2)}`,
          price_percent_siemon: supranet_price_percent.toFixed(2),
          total_percent_siemon: total_percent_supranet.toFixed(2)
        });

        this.selected_supranet_materials.push({
          amount: this.quotation_products.amount,
          percent: this.quotation_products.supranet_percent,
          product_id: this.supranet_material.id,
        })
        this.selected_siemon_materials.push({
          amount: this.quotation_products.amount,
          percent: this.quotation_products.supranet_percent,
          product_id: this.supranet_material.id,
        })
        
        this.supranet_material = null;
        this.siemon_material = null;
        this.quotation_products.supranet_percent = 15
        this.quotation_products.siemon_percent = 15
        this.quotation_products.siemon_price = 0
        this.quotation_products.supranet_price = 0
        this.quotation_products.amount = 1
      }else{
        this.alert(this.translations.errors.product_not_selected, 'danger')
      }
    },
    formatData: function(){

      var product_attributes = [];

      product_attributes = this.selected_siemon_materials.concat(this.selected_supranet_materials)
      console.log(product_attributes)
      var data = {
        quotation: {
          quotation_products_attributes: product_attributes
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
      this.selected_siemon_materials.splice(index,1);
      this.selected_supranet_materials.splice(index,1);
    }
  },
  mounted() {
    this.setTableHeaders();
    this.getQuotationProducts();
  }
}
</script>

<template>
  <b-form>
    <b-form-row>
      <div class="col-12">
        <label class="mb-0 text-primary font-weight-bold">{{translations.titles.material}}</label>
        <br />
        <label class="text-primary font-weight-bold">Siemon</label>
        <div class="input-group mb-3" >
          <div class="input-group-prepend">
            <div class="input-group-text bg-white text-primary">
              <i class="fas fa-user-alt"></i>
            </div>
          </div>
          <div class="col-7">
            <component-autocomplete
                :clear.sync="clear_siemon_autocomplete"
                :placeholder="translations.autocomplete.title"
                :source="`/api/products/per_brand/t_siemon_only`"
                @autocomplete:selected="materialSiemonSelected"
                @autocomplete:unselected="materialSiemonUnselected"
              />
          </div>
        </div>
      </div>
    </b-form-row>
    <b-form-row>
      <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.amount}}</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
            </div>
            <b-form-input v-model="quotation_products.amount"></b-form-input>
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
            <b-form-input disabled v-model="quotation_products.siemon_price"></b-form-input>
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
            <b-form-input v-model="quotation_products.siemon_percent"></b-form-input>
          </div>
        </div>
    </b-form-row>
    <b-form-row>
      <label class="text-primary font-weight-bold">Supranet</label>
      <div class="input-group mb-3" >
        <div class="input-group-prepend">
          <div class="input-group-text bg-white text-primary">
            <i class="fas fa-user-alt"></i>
          </div>
        </div>
        <div class="col-7">
          <component-autocomplete
              :clear.sync="clear_supranet_autocomplete"
              :placeholder="translations.autocomplete.title"
              :source="`/api/products/per_brand/t_supranet_only`"
              @autocomplete:selected="materialSupranetSelected"
              @autocomplete:unselected="materialSupranetUnselected"
            />
        </div>
      </div>
    </b-form-row>
    <b-form-row>
      <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold">{{translations.titles.amount}}</label>
          <div class="input-group mb-2">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-sort-amount-up"></i>
              </div>
            </div>
            <b-form-input v-model="quotation_products.amount"></b-form-input>
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
            <b-form-input disabled v-model="quotation_products.supranet_price"></b-form-input>
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
            <b-form-input v-model="quotation_products.supranet_percent"></b-form-input>
          </div>
        </div>
        <div class="col-2 offset-2">
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
      <template v-slot:thead-top="data">
        <b-tr class="text-center">
          <b-th rowspan="3" colspan="2" class="bg-dark text-white"></b-th>
          <b-th colspan="5" class="bg-dark">{{translations.custom_headers.expression}}</b-th>
          <b-th colspan="5" class="bg-dark">{{translations.custom_headers.expression}}</b-th>
          <b-th colspan="1" class="bg-dark text-white"></b-th>
        </b-tr>
        <b-tr class="text-center text-danger">
          <b-th colspan="5" class="text-center">Siemon</b-th>
          <b-th colspan="5" class="text-center">Supranet</b-th>
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
      <template v-slot:cell(amount)="data">{{ parseInt(data.item.amount) }}</template>
      <template v-slot:cell(name)="data">{{ data.item.name }}</template>
      <template v-slot:cell(actions)="data">
        <b-button class="btn btn-danger" type="submit" v-on:click="deleteProduct(data.index)">
          <i class="fas fa-trash-alt fa-xs"></i>
        </b-button>
      </template>
    </b-table>
    <div class="row">
      <div class="col-2 offset-10">
        <button class="btn btn-primary btn-block" type="submit" v-on:click="submit">{{translations.buttons.next}}</button>
      </div>
    </div>
  </b-form>
  
</template>
