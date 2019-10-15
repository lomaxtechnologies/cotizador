<script type="text/javascript">

  import axios from 'axios'

  export default {
    data(){
      return {
        translations:{
          select_client: I18n.t('quotations.new.header.select-client')
        },
        quotation:{
          client: null,
          quotation_date: this.today(),
          services_percentage: 0.00,
          type: 1,
          supranet_percentage: 15.00,
          siemon_percentage: 15.00
        },
        clients: [],
        quotation_types: [
          {value: 0, text: I18n.t('quotations.new.header.quotation_types.simple')},
          {value: 1, text: I18n.t('quotations.new.header.quotation_types.composed')}
        ]
      }
    },
    mounted(){
      this.http
      .get('/clients/api/get-all')
      .then((response)=>{
        var data = response.data;
        this.clients.push({value: null, text: this.translations.select_client});
        data.forEach((element)=>{
          this.clients.push({value: element.id, text: `${element.name}, Nit: ${element.nit}`});
        });
      });
    }
  }
</script>

<template>
  <div>
    <b-form>
      <b-form-row>
        <!----------------------------- quotation.client -------------------------------------->
        <div class="col-7">
          <label class="mb-0 text-primary font-weight-bold"> Cliente </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-user-alt"></i>
              </div>
            </div>
            <b-form-select v-model="quotation.client" :options=clients></b-form-select>
          </div>
        </div>
        <!----------------------------- quotation.client -------------------------------------->

        <!------------------------------- quotation.date -------------------------------------->
        <div class="col-3 offset-2">
          <label class="mb-0 text-primary font-weight-bold"> Fecha </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-calendar"></i>
              </div>
            </div>
            <b-form-input type="date" v-model=quotation.quotation_date></b-form-input>
          </div>
        </div>
        <!------------------------------- quotation.date -------------------------------------->

        <!-------------------------- quotation.service_percentage ------------------------------>
        <div class="col-2">
          <label class="mb-0 text-primary font-weight-bold"> Holgura Servicios </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
            </div>
            <b-form-input class=" text-right" type="number" v-model=quotation.services_percentage step="0.01"></b-form-input>
          </div>
        </div>
        <!-------------------------- quotation.service_percentage ------------------------------>

        <!----------------------------- quotation.quotation_type -------------------------------->
        <div class="col-3">
          <label class="mb-0 text-primary font-weight-bold"> Tipo Cotización </label>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <div class="input-group-text bg-white text-primary">
                <i class="fas fa-percentage"></i>
              </div>
            </div>
            <b-form-select v-model="quotation.type" :options=quotation_types></b-form-select>
          </div>
        </div>
        <!----------------------------- quotation.quotation_type -------------------------------->

        <!------------------------------- quotation.use_supranet --------------------------------->
        <div class="col-2">
          <div>
            <div class="custom-control custom-checkbox custom-control-inline">
              <input class="custom-control-input" type="checkbox">
              <label class="custom-control-label mb-0 text-primary font-weight-bold">Supranet</label>
            </div>
            <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-percentage"></i>
                </div>
              </div>
              <b-form-input class=" text-right" placeholder="Holgura  " type="number" step="0.01" v-model=quotation.supranet_percentage>
              </b-form-input>
            </div>
          </div>
        </div>
        <!------------------------------- quotation.use_supranet --------------------------------->

        <!--------------------------------- quotation.use_siemon ---------------------------------->
        <div class="col-2">
          <div>
            <div class="custom-control custom-checkbox custom-control-inline">
              <input class="custom-control-input" type="checkbox">
              <label class="custom-control-label mb-0 text-primary font-weight-bold">Siemon</label>
            </div>
            <div class="input-group mb-3">
              <div class="input-group-prepend">
                <div class="input-group-text bg-white text-primary">
                  <i class="fas fa-percentage"></i>
                </div>
              </div>
              <b-form-input class=" text-right" placeholder="Holgura  " type="number" v-model=quotation.siemon_percentage>
              </b-form-input>
            </div>
          </div>
        </div>
        <!--------------------------------- quotation.use_siemon ---------------------------------->

        <!--------------------------------- quotation.submit ---------------------------------->
        <div class="col-2 offset-1">
          <label class="mb-0 text-primary font-weight-bold">&nbsp;</label>
          <button class="btn btn-primary btn-block">
            Siguiente
          </button>
        </div>
        <!--------------------------------- quotation.submit ---------------------------------->
      </b-form-row>
    </b-form>
  </div>
</template>
