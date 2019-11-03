<script type="text/javascript">
   export default {
     props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_id:{
        type:Number,
        default: null
      },
      refresh_quotation:{
        type: Boolean,
        default: false
      },
      quotation_state:{
        type: String,
        default: null
      }
    },

     data() {
      return {
        brands:{
          supranet: 'supranet',
          siemon: 'siemon'
        },
        translations:{
          show: I18n.t('quotations.show'),
          types: I18n.t('quotations.api_types'),
          states: I18n.t('quotations.states')
        },
        quotation: {
          client: {},
          quotation_products: [],
          quotation_services: [],
          products_totals: {},
          services_totals:{}
        },
        quotation_products: [],
        quotation_products_headers: [],
        quotation_services_headers: []
      }
    },
    
    mounted: function(){
      this.refreshQuotation();
    },

    computed: {
      quotationProductsEmpty: function(){
        return this.quotation.quotation_products.length == 0;
      }
    },

    methods: {

      refreshQuotation(){
        if(this.quotation_id){
          this.getQuotation();
          this.setQuotationServicesHeaders();
        }
      },
      
      getQuotation: function(){
        this.http
        .get(`/quotations/${this.quotation_id}`)
        .then((response)=>{
          if(response.successful){
            this.quotation = response.data;
            this.setQuotationProductsHeaders();
          }else{
            console.log(JSON.stringify(response));
          }
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },

      setQuotationProductsHeaders: function(){
        var headers = ['amount','material'];
        var q_type = this.quotation.quotation_type;
        //sets columns dependind on quotation_type, types are:
        //t_comparative, t_supranet_only, t_siemon_only, t_simple
        ['t_supranet_only','t_siemon_only'].forEach((type)=>{
          if(q_type === 't_comparative' || q_type === type){
            headers.push(`${type}_percent`);
            //Adds four fields: unit price, total price, unit price plus percent and total price plus percent
            ['','_with_percent'].forEach((suffix)=>{
              headers = headers.concat([`${type}_price${suffix}`, `${type}_total${suffix}`]);
            });
          }
        });
        //simple type
        if(q_type === 't_simple'){
          headers = headers.concat(['brand','percent']);
          ['','_with_percent'].forEach((suffix)=>{
            headers = headers.concat([`${q_type}_price${suffix}`, `${q_type}_total${suffix}`]);
          });
        }
        headers.forEach((element)=>{
          this.quotation_products_headers.push({
            key:element,
            label:this.translations.show.headers[element],
            sortable:true
          });
        });
      },

      setQuotationServicesHeaders: function(){
        var headers = [
          'amount',
          'service',
          'percent',
          'price',
          'total',
          'price_with_percent',
          'total_with_percent'
        ].forEach((element)=>{
          this.quotation_services_headers.push({
            key:element,
            label:this.translations.show.headers[element],
            sortable:true
          })
        });
      }
    },

    watch: {
      refresh_quotation: function(){
        if(this.refresh_quotation){
          this.$emit('update:refresh_quotation', false);
          this.refreshQuotation();
        }
      },
      quotation_state: function(){
        this.quotation.state = this.quotation_state;
      }
    }
  }
</script>

<template>
  <div class="card">
    <div class="card-header">
      <div class="row">
        <div class="col-2 mb-4">
          <b-img src="/assets/lomax-logo.png" fluid alt="Fluid image"></b-img>
        </div>
        <div class="col-10 mb-4 text-right">
          <h3><b>{{translations.show.titles.quotation_number}}
            <span class="text-danger"> {{quotation.id}}</span>
          </b></h3>
        </div>
        <div class="col-7">
          <h5><b>{{translations.show.titles.client.info}}</b></h5>
          <div class="row">
            <div class="col-12">
              <b>{{translations.show.titles.client.client}}</b>: {{quotation.client.name}}
            </div>
            <div class="col-12">
              <b>{{translations.show.titles.client.address}}</b>: {{quotation.client.address}}
            </div>
            <div class="col-12">
              <b>{{translations.show.titles.client.nit}}</b>: {{quotation.client.nit}}
            </div>
            <div class="col-12">
              <b>{{translations.show.titles.client.phone}}</b>: {{quotation.client.phone}}
            </div>
          </div>
        </div>
        <div class="col-5 text-right">
          <h5><b>{{translations.show.titles.quotation.info}}</b></h5>
          <div class="row">
            <div class="col-12">
              <b>{{translations.show.titles.quotation.number}}</b>: {{quotation.id}}
            </div>
            <div class="col-12">
              <b>{{translations.show.titles.quotation.date}}</b>:
              {{date.toLocalFormat(quotation.quotation_date)}}
            </div>
            <div class="col-12">
              <b>{{translations.show.titles.quotation.type}}</b>:
              {{translations.types[quotation.quotation_type]}}
            </div>
            <div class="col-12">
              <b>{{translations.show.titles.quotation.state}}</b>:
              {{translations.states[quotation.state]}}
            </div>
          </div>
        </div>

        <div v-if="!quotationProductsEmpty" class="col-12 mt-3">
          <b-table
            :items=quotation.quotation_products
            :fields=quotation_products_headers
            responsive="sm"
            thead-tr-class="bg-lomax text-white text-center"
            striped bordered small
          >
            <!---- One of 2 templates below is rendered for the header depending on quotation_type ---->
            <template v-if="quotation.quotation_type=='t_comparative'" v-slot:thead-top="data">
              <b-tr class="text-center">
                <b-th rowspan="3" colspan="2" class="align-middle bg-outline-primary">
                  <h5><b>{{translations.show.titles.materials}}</b></h5>
                </b-th>
                <b-th colspan="5" class="bg-dark">{{translations.show.custom_headers.expression}}</b-th>
                <b-th colspan="5" class="bg-dark">{{translations.show.custom_headers.expression}}</b-th>
              </b-tr>
              <b-tr class="text-center text-danger">
                <b-th colspan="5" >{{translations.show.brands.t_supranet_only}}</b-th>
                <b-th colspan="5" >{{translations.show.brands.t_siemon_only}}</b-th>
              </b-tr>
              <b-tr class="text-center">
                <b-th></b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.without_percent}}</b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.with_percent}}</b-th>
                <b-th></b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.without_percent}}</b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.with_percent}}</b-th>
              </b-tr>
            </template>
            <template v-else v-slot:thead-top="data">
              <b-tr class="text-center">
                <b-th 
                  v-if="quotation.quotation_type=='t_simple'"
                  rowspan="2"
                  colspan="4"
                  class="align-middle bg-outline-primary"
                >
                  <h5><b>{{translations.show.titles.materials}}</b></h5>
                </b-th>
                <b-th v-else rowspan="3" colspan="3" class="align-middle bg-outline-primary">
                  <h5><b>{{translations.show.titles.materials}}</b></h5>
                </b-th>
                <b-th colspan="4" class="bg-dark">{{translations.show.custom_headers.expression}}</b-th>
              </b-tr>
              <b-tr v-if="quotation.quotation_type!=='t_simple'" class="text-center text-danger">
                <b-th colspan="4" >{{translations.show.brands[quotation.quotation_type]}}</b-th>
              </b-tr>
              <b-tr  class="text-center">
                <b-th colspan="2" >{{translations.show.custom_headers.without_percent}}</b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.with_percent}}</b-th>
              </b-tr>
            </template>
            <!---- One of 2 templates above is rendered for the header depending on quotation_type ---->

            <!---- One of 2 templates below is rendered for the footer depending on quotation_type ---->
            <template v-if="quotation.quotation_type=='t_comparative'" v-slot:custom-foot>
              <b-tr class="bg-dark text-center">
                <b-td colspan="2">{{translations.show.custom_headers.total}}</b-td>
                <b-td></b-td>
                <b-td></b-td>
                <b-td class="text-right">
                  {{currency.format(quotation.products_totals.t_supranet_only.without_percent)}}
                </b-td>
                <b-td></b-td>
                <b-td class="text-right">
                  {{currency.format(quotation.products_totals.t_supranet_only.with_percent)}}
                </b-td>
                <b-td></b-td>
                <b-td></b-td>
                <b-td class="text-right">
                  {{currency.format(quotation.products_totals.t_siemon_only.without_percent)}}
                </b-td>
                <b-td></b-td>
                <b-td class="text-right">
                  {{currency.format(quotation.products_totals.t_siemon_only.with_percent)}}
                </b-td>
              </b-tr>
            </template>
            <template v-else v-slot:custom-foot>
              <b-tr class="bg-dark text-center">
                <b-td 
                  v-if="quotation.quotation_type=='t_simple'"
                  colspan="4"
                >
                  {{translations.show.custom_headers.total}}
                </b-td>
                <b-td v-else colspan="3">{{translations.show.custom_headers.total}}</b-td>
                <b-td></b-td>
                <b-td class="text-right">{{currency.format(quotation.products_totals.without_percent)}}</b-td>
                <b-td></b-td>
                <b-td class="text-right">{{currency.format(quotation.products_totals.with_percent)}}</b-td>
              </b-tr>
            </template>
            <!---- One of 2 templates above is rendered for the footer depending on quotation_type ---->
            <template v-slot:cell(amount)="data">
              <div class="text-center">
                {{parseInt(data.value)}}
              </div>
            </template>
            <template v-slot:cell(brand)="data">
              <div class="text-left">
                {{data.value}}
              </div>
            </template>
            <template v-slot:cell(material)="data">
              <div class="text-left">
                {{data.value}}
              </div>
            </template>
            <template v-slot:cell()="data">
              <div class="text-right">
                {{currency.format(data.value)}}
              </div>
            </template>

          </b-table>
        </div>
        <div class="col-12 mt-2">
          <h5 v-if="quotation.quotation_type=='t_comparative'">
            <b>{{translations.show.titles.services}}</b>
          </h5>
          <b-table
            :items=quotation.quotation_services
            :fields=quotation_services_headers
            responsive="sm"
            thead-tr-class="bg-lomax text-white text-center"
            striped bordered small
          >
            <template v-slot:thead-top="data">
              <b-tr class="text-center">
                <b-th rowspan="3" colspan="3"  class="bg-outline-lomax align-middle">
                  <h5 v-if="quotation.quotation_type=='t_comparative'">
                    <b class="text-danger">{{translations.show.titles.option_a}}</b>
                  </h5>
                  <h5 v-else>
                    <b>{{translations.show.titles.services}}</b>
                  </h5>
                </b-th>
                <b-th colspan="4" class="bg-dark">{{translations.show.custom_headers.expression}}</b-th>
              </b-tr>
              <b-tr class="text-center text-danger">
                <b-th colspan="4" >{{translations.show.custom_headers.prices}}</b-th>
              </b-tr>
              <b-tr  class="text-center">
                <b-th colspan="2" >{{translations.show.custom_headers.without_percent}}</b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.with_percent}}</b-th>
              </b-tr>
            </template>
            <template v-slot:cell(amount)="data">
              <div class="text-center">
                {{parseInt(data.value)}}
              </div>
            </template>
            <template v-slot:cell(service)="data">
              <div class="text-left">
                {{data.value}}
              </div>
            </template>
            <template v-slot:cell()="data">
              <div class="text-right">
                {{currency.format(data.value)}}
              </div>
            </template>
            <template v-slot:custom-foot>
              <b-tr v-if="!quotationProductsEmpty" class="text-important">
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td>
                  {{translations.show.custom_footers.materials}}
                  <span v-if="quotation.quotation_type=='t_comparative'">
                    {{translations.show.brands.t_supranet_only}}
                  </span>
                  <span v-else>
                    {{translations.show.brands[quotation.quotation_type]}}
                  </span>
                </b-td>
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td class="text-right">
                  <span v-if="quotation.quotation_type=='t_comparative'">
                    {{currency.format(quotation.products_totals.t_supranet_only.without_percent)}}
                  </span>
                  <span v-else>
                    {{currency.format(quotation.products_totals.without_percent)}}
                  </span>
                </b-td>
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td class="text-right">
                  <span v-if="quotation.quotation_type=='t_comparative'">
                    {{currency.format(quotation.products_totals.t_supranet_only.with_percent)}}
                  </span>
                  <span v-else>
                    {{currency.format(quotation.products_totals.with_percent)}}
                  </span>
                </b-td>
              </b-tr>
              <b-tr class="bg-dark text-center">
                <b-td colspan="2">{{translations.show.custom_headers.total}}</b-td>
                <b-td ></b-td>
                <b-td ></b-td>
                <b-td 
                  v-if="quotation.quotation_type=='t_comparative'" 
                  class="text-right"
                >{{
                  currency.format(
                    parseFloat(quotation.services_totals.without_percent) + 
                    parseFloat(quotation.products_totals.t_supranet_only.without_percent)
                  )}}
                </b-td>
                <b-td 
                  v-else 
                  class="text-right"
                >{{currency.format(
                    parseFloat(quotation.services_totals.without_percent) + 
                    parseFloat(quotation.products_totals.without_percent)
                  )}}
                </b-td>
                <b-td></b-td>
                <b-td
                  v-if="quotation.quotation_type=='t_comparative'"
                  class="text-right"
                >{{
                  currency.format(
                    parseFloat(quotation.services_totals.with_percent) + 
                    parseFloat(quotation.products_totals.t_supranet_only.with_percent)
                  )}}
                </b-td>
                <b-td 
                  v-else
                  class="text-right"
                >
                  {{currency.format(
                    parseFloat(quotation.services_totals.with_percent) + 
                    parseFloat(quotation.products_totals.with_percent)
                  )}}
                </b-td>
              </b-tr>
            </template>
          </b-table>
          <b-table
            v-if="quotation.quotation_type=='t_comparative'"
            :items=quotation.quotation_services
            :fields=quotation_services_headers
            responsive="sm"
            thead-tr-class="bg-lomax text-white text-center"
            striped bordered small
          >
            <template v-slot:thead-top="data">
              <b-tr class="text-center">
                <b-th rowspan="3" colspan="3"  class="bg-outline-primary align-middle">
                  <h5><b class="text-danger">{{translations.show.titles.option_b}}</b></h5>
                </b-th>
                <b-th colspan="4" class="bg-dark">{{translations.show.custom_headers.expression}}</b-th>
              </b-tr>
              <b-tr class="text-center text-danger">
                <b-th colspan="4" >{{translations.show.custom_headers.prices}}</b-th>
              </b-tr>
              <b-tr  class="text-center">
                <b-th colspan="2" >{{translations.show.custom_headers.without_percent}}</b-th>
                <b-th colspan="2" >{{translations.show.custom_headers.with_percent}}</b-th>
              </b-tr>
            </template>
            <template v-slot:cell(amount)="data">
              <div class="text-center">
                {{parseInt(data.value)}}
              </div>
            </template>
            <template v-slot:cell(service)="data">
              <div class="text-left">
                {{data.value}}
              </div>
            </template>
            <template v-slot:cell()="data">
              <div class="text-right">
                {{currency.format(data.value)}}
              </div>
            </template>
            <template v-slot:custom-foot>
              <b-tr class="text-important">
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td>
                  {{translations.show.custom_footers.materials}}
                  <span v-if="quotation.quotation_type=='t_comparative'">
                    {{translations.show.brands.t_siemon_only}}
                  </span>
                  <span v-else>
                    {{translations.show.brands[quotation.quotation_type]}}
                  </span>
                </b-td>
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td class="text-right">
                  {{currency.format(quotation.products_totals.t_siemon_only.without_percent)}}
                </b-td>
                <b-td class="text-center">{{translations.show.custom_footers.not_used}}</b-td>
                <b-td class="text-right">
                  {{currency.format(quotation.products_totals.t_siemon_only.with_percent)}}
                </b-td>
              </b-tr>
              <b-tr class="bg-dark text-center">
                <b-td colspan="2">{{translations.show.custom_headers.total}}</b-td>
                <b-td ></b-td>
                <b-td ></b-td>
                <b-td class="text-right">{{
                  currency.format(
                    parseFloat(quotation.services_totals.without_percent) + 
                    parseFloat(quotation.products_totals.t_siemon_only.without_percent)
                  )}}
                </b-td>
                <b-td></b-td>
                <b-td class="text-right">{{
                  currency.format(
                    parseFloat(quotation.services_totals.with_percent) + 
                    parseFloat(quotation.products_totals.t_siemon_only.with_percent)
                  )}}
                </b-td>
              </b-tr>
            </template>
          </b-table>
        </div>
        <div class="col-12 mt-2">
          <h5><b>{{translations.show.titles.payment_condition}}</b></h5>
          <span class="text-justify" v-html="quotation.payment_condition">
          </span>
        </div>
        <div class="col-12 mt-2">
          <h5><b>{{translations.show.titles.warranty}}</b></h5>
          <span class="text-justify" v-html="quotation.warranty">
          </span>
        </div>
        <div v-if="quotation.quotation_type=='t_comparative'" class="col-8 offset-2 mt-2">
          <center>
            <br>
            <hr size="20" color="black" width="35%">
            <b>{{translations.show.titles.signature}}</b>
            <table>
              <tr>
                <th>
                  <p>{{translations.show.titles.option}}: </p>
                </th>
                <th>
                   <b><p>{{translations.show.titles.option_a_b}}</p></b>
                </th>
              </tr>
            </table>
          </center>
        </div>
        <div v-if="quotation.quotation_type!='t_comparative'" class="col-8 offset-2 mt-2">
          <hr size="20" color="black" width="35%">
            <center>
              <b>{{translations.show.titles.signature}}</b>
              <br/>
            </center>
        </div>
        <div class="col-12 mt-3">
          <hr>
          <span class="text-muted">
            <b>{{translations.show.company.name}}</b>
            <b>{{translations.show.titles.address}}</b>: {{translations.show.company.address}}
            <b>{{translations.show.titles.email}}</b>: {{translations.show.company.email}}
            <b>{{translations.show.titles.web_page}}</b>: {{translations.show.company.web_page}}
            <b>{{translations.show.titles.phone}}</b>: {{translations.show.company.phone}}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>