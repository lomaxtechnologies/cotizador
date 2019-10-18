<script type="text/javascript">
   export default {
     data() {
      return {
        items: [
          { name: 'Stephen Hawking', id: 1, type1: false, type2a: true, type2b: false, type2c: false, type3: false },
          { name: 'Johnny Appleseed', id: 2, type1: false, type2a: true, type2b: true, type2c: false, type3: false },
          { name: 'George Washington', id: 3, type1: false, type2a: false, type2b: false, type2c: false, type3: true },
          { name: 'Albert Einstein', id: 4, type1: true, type2a: false, type2b: false, type2c: true, type3: false },
          { name: 'Isaac Newton', id: 5, type1: true, type2a: true, type2b: false, type2c: true, type3: false },
        ],
        fields: [
          'name',
          { key: 'amount', label: 'Cantidad' },
          { key: 'material', label: 'Detalle de Materiales' },
          { key: 'price', label: 'Unitario S/H' },
          { key: 'type2b', label: 'Type 2B' },
          { key: 'type2c', label: 'Type 2C' },
          { key: 'type3', label: 'Type 3' }
        ]
      }
    },
    mounted: function(){
      this.getQuotation();
    },
    methods: {
      getQuotation: function(){
        var id = this.$route.params.id;
        this.http
        .get(`/api/quotations/${id}`)
        .then((response)=>{
          console.log(JSON.stringify(response));
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      }
    }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <div class="card">
        <div class="card-header">
          <div class="row">
            <div class="col-12 mb-4">
              <h3><b>Cotización No. <span class="text-danger">101</span></b></h3>
            </div>

            <!------------------------------------------- Datos del Cliente -------------------------------------------->
            <div class="col-7">
              <h5><b>Datos del Cliente</b></h5>
              <div class="row">
                <div class="col-12">
                  <b>Cliente</b>: Almacenadora y Recursos 2000, Region Central
                </div>
                <div class="col-12">
                  <b>Dirección</b>: 15 Avenida, 2-44 Zona 1, Edificio Insight, Oficina 33
                </div>
                <div class="col-12">
                  <b>Nit</b>: 602584-5 
                  <b>Teléfono</b>: (502) 9403-3367
                </div>
              </div>
            </div>
            <!------------------------------------------- Datos del Cliente -------------------------------------------->

            <!------------------------------------------- Tipo de Cotización -------------------------------------------->
            <div class="col-5 text-right">
              <h5><b>Datos de la Cotización</b></h5>
              <div class="row">
                <div class="col-12">
                  <b>Número</b>: 101
                </div>
                <div class="col-12">
                  <b>Fecha</b>: 12/09/2019
                </div>
                <div class="col-12">
                  <b>Tipo</b>: Comparativa
                </div>
              </div>
            </div>
            <!------------------------------------------- Tipo de Cotización -------------------------------------------->

            <!----------------------------------------- Detalles de Materiales <!----------------------------------------->
            <div class="col-12 mt-4">
              <h5><b>Detalle de Materiales</b></h5>
              <b-table
                :items="items"
                :fields="fields"
                responsive="sm"
                thead-tr-class="bg-primary text-white"
                class="table table-sm table-striped"
              >
                <template v-slot:thead-top="data">
                  <b-tr>
                    <b-th colspan="2"></b-th>
                    <b-th colspan="5" class="bg-dark">Expresión (GTQ)</b-th>
                    <b-th colspan="5" class="bg-dark">Expresión (GTQ)</b-th>
                  </b-tr>
                </template>
              </b-table>
            </div>
            <!----------------------------------------- Detalles de Materiales <!----------------------------------------->
          </div>
        </div>
      </div>
    </div>
  </div>
</template>