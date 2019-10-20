<script type="text/javascript">
   export default {
     data() {
      return {
        quotation_products: [],
        table_headers: [
          { key: 'amount', label: 'Cantidad' },
          { key: 'material', label: 'Detalle de Materiales' },
          { key: 'supranet_price', label: 'Unitario' },
          { key: 'supranet_total', label: 'Total' },
          { key: 'supranet_price_with_percentage', label: 'Unitario' },
          { key: 'supranet_total_with_percentage', label: 'Total' },
          { key: 'siemon_price', label: 'Unitario' },
          { key: 'siemon_total', label: 'Total' },
          { key: 'siemon_price_with_percentage', label: 'Unitario' },
          { key: 'siemon_total_with_percentage', label: 'Total' }
        ]
      }
    },
    computed: {
      //TODO: CHANGE
      supranet_total_without_percentage: function(){
        if(this.quotation_products.length == 0){
          return 0;
        }
        return this.quotation_products.reduce((total,product)=>{
          console.log(JSON.stringify(total + product.amount * product.supranet_price));
          return total + product.amount * product.supranet_price;
        },0);
      },
      supranet_total_with_percentage: function(){
        return 0;
      },siemon_total_without_percentage: function(){
        if(this.quotation_products.length == 0){
          return 0;
        }
        return this.quotation_products.reduce((total,product)=>{
          return total + product.amount * product.siemon_price;
        },0);
      },
      siemon_total_with_percentage: function(){
        return 0;
      }
    },
    mounted: function(){
      this.getQuotation();
    },
    methods: {
      getQuotation: function(){
        var id = this.$route.params.id;
        this.http
        .get(`/quotations/${id}`)
        .then((response)=>{


          this.quotation_products = [
            {material: 'Metros de cable UTP Cat. 6', amount: 4080, supranet_percent: 15, supranet_price: 3.45, siemon_price: 4.60, siemon_percent: 15},
            {material: 'Rack de 4 postes de 45 U', amount: 1, supranet_percent: 15, supranet_price: 2875, siemon_price: 3795, siemon_percent: 15},
            {material: 'Rack de 2 postes de 45 U', amount: 1, supranet_percent: 15, supranet_price: 1725, siemon_price: 3795, siemon_percent: 15},
            {material: 'Patch panel de 48 puertos', amount: 2, supranet_percent: 15, supranet_price: 596.25, siemon_price: 1983.75, siemon_percent: 15},
            {material: 'Barras para Sujetar Cables Ponchados', amount: 3, supranet_percent: 15, supranet_price: 126.50, siemon_price: 12, siemon_percent: 15}
          ];
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },
      calculateCellTotal: function(unit_price,amount=1,percentage=0, convert_to_money = true){
        var total = (1+percentage/100)*amount*unit_price;
        if(convert_to_money){
          total = this.currency.format(total);
        }
        return total;
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

            <!----------------------------------------- Detalles de Materiales ------------------------------------------->
            <div class="col-12 mt-4">
              <h5><b>Detalle de Materiales</b></h5>
              <b-table
                :items=quotation_products
                :fields=table_headers
                responsive="sm"
                thead-tr-class="bg-primary text-white text-center"
                class="table table-sm table-striped table-bordered"
              >
                <template v-slot:thead-top="data">
                  <b-tr class="text-center">
                    <b-th rowspan="3" colspan="2" class="bg-primary text-white"></b-th>
                    <b-th colspan="4" class="bg-dark">Expresión (GTQ)</b-th>
                    <b-th colspan="4" class="bg-dark">Expresión (GTQ)</b-th>
                  </b-tr>
                  <b-tr class="text-center text-danger">
                    <b-th colspan="4" >Supranet</b-th>
                    <b-th colspan="4" >Siemon</b-th>
                  </b-tr>
                  <b-tr class="text-center">
                    <b-th colspan="2" >Sin Holgura</b-th>
                    <b-th colspan="2" >Con Holgura</b-th>
                    <b-th colspan="2" >Sin Holgura</b-th>
                    <b-th colspan="2" >Con Holgura</b-th>
                  </b-tr>
                </template>

                <template v-slot:custom-foot>
                  <b-tr class="bg-dark text-center">
                    <b-td colspan="2">
                      TOTAL (GTQ)
                    </b-td>
                    <b-td></b-td>
                    <b-td class="text-right">
                      {{calculateCellTotal(supranet_total_without_percentage)}}
                    </b-td>
                    <b-td></b-td>
                    <b-td class="text-right">
                      {{calculateCellTotal(supranet_total_with_percentage)}}
                    </b-td>
                    <b-td></b-td>
                    <b-td class="text-right">
                      {{calculateCellTotal(siemon_total_without_percentage)}}
                    </b-td>
                    <b-td></b-td>
                    <b-td class="text-right">
                      {{calculateCellTotal(siemon_total_with_percentage)}}
                    </b-td>
                  </b-tr>
                </template>

                <template v-slot:cell(amount)="data">
                  <div class="text-center">
                    {{data.value}}
                  </div>
                </template>

                <template v-slot:cell(supranet_price)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.value)}}
                  </div>
                </template>

                <template v-slot:cell(supranet_total)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.item.supranet_price,data.item.amount)}}
                  </div>
                </template>

                <template v-slot:cell(supranet_price_with_percentage)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.item.supranet_price,1,data.item.supranet_percent)}}
                  </div>
                </template>

                <template v-slot:cell(supranet_total_with_percentage)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.item.supranet_price,data.item.amount,data.item.supranet_percent)}}
                  </div>
                </template>

                <template v-slot:cell(siemon_price)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.value)}}
                  </div>
                </template>

                <template v-slot:cell(siemon_total)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.item.amount*data.item.siemon_price)}}
                  </div>
                </template>

                <template v-slot:cell(siemon_price_with_percentage)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.item.siemon_price,1,data.item.siemon_percent)}}
                  </div>
                </template>

                <template v-slot:cell(siemon_total_with_percentage)="data">
                  <div class="text-right">
                    {{calculateCellTotal(data.item.siemon_price,data.item.amount,data.item.siemon_percent)}}
                  </div>
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