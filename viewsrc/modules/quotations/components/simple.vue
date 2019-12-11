<script type="text/javascript">
export default {
  props: ["quotation_type"],
  data() {
    return {
      translations: I18n.t('quotations.new_edit.materials'),
      materials: [],
      material_id: null
    } 
  },
  methods: {
    getMaterials: function(){
      this.http
      .get("/api/products/simple")
      .then(response =>{
        if(response.successful){
          this.materials = response.data;
          console.log(this.materials);
        }else{
          this.handleError(response.error);
        }
      })
      .catch(err => {
        console.error("Error", err.stack, err.name, err.message);
      });
    }
  },
  mounted() {
    this.getMaterials();
  }
}
</script>

<template>
  <b-form>
    <b-form-row>
      <div class="col-12">
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
            text-field="name_and_brand"
          ></b-form-select>
        </div>
      </div>
    </b-form-row>
    <b-form-row>
      <div class="col-1" v-if="quotation_type!=='t_simple'">
        <label class="text-primary font-weight-bold">Supranet</label>
      </div>
      <div class="col-2">
        <label class="mb-0 text-primary font-weight-bold">{{translations.titles.amount}}</label>
        <div class="input-group mb-2">
          <div class="input-group-prepend">
            <div class="input-group-text bg-white text-primary">
              <i class="fas fa-sort-amount-up"></i>
            </div>
          </div>
          <b-form-input ></b-form-input>
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
          <b-form-input disabled></b-form-input>
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
          <b-form-input ></b-form-input>
        </div>
      </div>
      <div class="col-2">
      <br />
        <b-button variant="primary" block>{{translations.buttons.add_material}}</b-button>
      </div>
    </b-form-row>
  </b-form>
</template>
