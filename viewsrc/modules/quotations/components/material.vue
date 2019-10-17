<script type="text/javascript">

  import axios from 'axios'

  export default{
    props:{
      brand: Array
    },
    data(){
      return{
        translations:{
          select_material: I18n.t('quotations.new.materials.select-material')
        },
        quotations_products:{
          amount: 0.0,
          percent: 15.00,
          product_id: null,
        },
        material_id: null,
        list_materials: [],
        selected_materials:[],
        brand_type: [{value: 0,text: I18n.t('quotations.new.brands.supranet') },{value: 1,text: I18n.t('quotations.new.brands.siemons') }],
        visible: 'invisible'
      }
    },
    methods:{
      listMaterial: function(){
        this.http
        .get('/materials/api/all')
        .then((response)=>{
          var data = response.data;
          data.forEach((element)=>{
            this.list_materials.push({value: element.id, text: `${element.name} - ${element.description}`});
          });
        });
      },
      onChange: function (event){
        this.visible= 'visible';
        this.http
        .get('/prices/api/products',{params:{material_id:event}})
        .then((response)=>{
          var data = response.data;
          data.forEach((element)=>{
            var brand = this.brand_type.filter((brand)=>{return brand.text == element.brand;})
            //.products_data[brand[0].value]={product_id: element.product_id,code:element.code,price:element.price,brand: element.brand, measure:element.measure_unit};
          })
        });
      },
      onIteration: function(b){
        console.log(b);
      }
    },
    mounted(){
      this.listMaterial();
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
        <div class="col-3" v-for="brand of brand_type" v-bind:key="brand.id">
          <label class="text-primary font-weight-bold">{{brand.text}}</label>    
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
            <b-form-select v-model="material_id" :options=list_materials></b-form-select>
          </div>
        </div>
        <!----------Materials------------->
        <!----------Double---------------->
        <div class="col-3" v-for="brand of brand_type" v-bind:key="brand.id">
          <label class="mb-0 text-primary font-weight-bold">Precio</label>
          <div class="input-group mb-1">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-money-bill-wave"></i>
              </div>
              <b-form-input disabled></b-form-input>
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