<script type="text/javascript">
  export default {

    data() {
      return {
        config: {
          selected_quotation: null,
          current_page: 1,
          page_size: 5,
          page_size_created: 5,
          page_size_active: 5,
          page_size_accepted: 5,
          page_size_expired: 5,
        },
        translations: {
          dashboard: I18n.t('dashboards.index'),
          states: I18n.t('dashboards.states'),
          types: I18n.t('quotations.api_types')
        },
        table_headers:[],
        quotations: [],
        quotation_created: [],
        quotation_active: [],
        quotation_accepted: [],
        quotation_expired: []
      }
    },

    mounted: function(){
      this.getQuotations();
      this.setTableHeaders();
    },

    computed:{
      quotationRows: function(){
        return this.quotations.length;
      }
    },

    methods:{
        
        generateEditLink: function(id){
            return `quotations/#/${id}/edit`
        },

        generateShowLink: function(id){
            return `quotations/#/${id}/show`
        },
        setTableHeaders: function () {
            ['id','name','quotation_date','quotation_type','state','actions'].forEach((element) => {
            this.table_headers.push({
                key:element,
                label:this.translations.dashboard.headers_dashboard[element],
                sortable:true
            });
            });
        },
        getQuotations: function(){
            this.http
            .get('api/quotations')
            .then((response) => {
            if(response.successful){
              this.quotation = response.data; 
              this.quotation_accepted = this.quotation.filter(element => element.state === 'accepted')             
              this.quotation_created = this.quotation.filter(element => element.state === 'created')
              this.quotation_expired = this.quotation.filter(element => element.state === 'expired')
              this.quotation_active = this.quotation.filter(element => element.state === 'active')
            }else{
                console.log(JSON.stringify(response));
            }
            }).catch((err)=>{
            console.log(JSON.stringify(err));
            });
        }
    }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10 text-left">
            <div>
                <h2 class="text-primary">
                    <b>
                        {{translations.dashboard.state_created}}
                    </b>
                </h2>
            </div>
        <b-table 
            id="quotations_table" 
            thead-tr-class="bg-primary text-white" 
            class="table table-sm table-striped"
            :items=quotation_created
            :fields=table_headers
            :per-page=config.page_size_created
            :current-page=config.current_page
        >
            <template v-slot:cell(quotation_type)=data>
                {{translations.types[data.item.quotation_type]}}
            </template>
            <template v-slot:cell(state)=data>
                {{translations.states[data.item.state]}}
            </template>
            <template v-slot:cell(quotation_date)=data>
                {{date.toLocalFormat(data.item.quotation_date)}}
            </template>
            <template v-slot:head(actions)="data">
                <div class="text-right">
                    <input
                    class="form-control-sm"
                    min="0"
                    v-bind:placeholder=translations.dashboard.page_size_placeholder
                    v-model=config.page_size_created
                    type="number" 
                    >
                </div>
            </template>
            <template v-slot:cell(actions)=data>
                <div class="text-right">
                    <a class="btn btn-warning text-white" v-bind:href=generateShowLink(data.item.id)>
                    <i class="fas fa-eye fa-xs"></i>
                    </a>
                    <a class="btn btn-success text-white" v-bind:href=generateEditLink(data.item.id)>
                    <i class="fas fa-edit fa-xs"></i>
                    </a>
                </div>
            </template>
        </b-table>
        <div>
            <h2 class="text-primary">
                <b>
                    {{translations.dashboard.state_active}}
                </b>
            </h2>
        </div>
        <b-table 
            id="quotations_table" 
            thead-tr-class="bg-primary text-white" 
            class="table table-sm table-striped"
            :items=quotation_active
            :fields=table_headers
            :per-page=config.page_size_active
            :current-page=config.current_page
        >
            <template v-slot:cell(quotation_type)=data>
                {{translations.types[data.item.quotation_type]}}
            </template>
            <template v-slot:cell(state)=data>
                {{translations.states[data.item.state]}}
            </template>
            <template v-slot:cell(quotation_date)=data>
                {{date.toLocalFormat(data.item.quotation_date)}}
            </template>
            <template v-slot:head(actions)="data">
                <div class="text-right">
                    <input
                    class="form-control-sm"
                    min="0"
                    v-bind:placeholder=translations.dashboard.page_size_placeholder
                    v-model=config.page_size_active
                    type="number" 
                    >
                </div>
            </template>
            <template v-slot:cell(actions)=data>
                <div class="text-right">
                    <a class="btn btn-warning text-white" v-bind:href=generateShowLink(data.item.id)>
                    <i class="fas fa-eye fa-xs"></i>
                    </a>
                    <a class="btn btn-success text-white" v-bind:href=generateEditLink(data.item.id)>
                    <i class="fas fa-edit fa-xs"></i>
                    </a>
                </div>
            </template>
        </b-table>
        <div>
            <h2 class="text-primary">
                <b>
                    {{translations.dashboard.state_accepted}}
                </b>
            </h2>
        </div>
        <b-table 
            id="quotations_table" 
            thead-tr-class="bg-primary text-white" 
            class="table table-sm table-striped"
            :items=quotation_accepted
            :fields=table_headers
            :per-page=config.page_size_accepted
            :current-page=config.current_page
        >
            <template v-slot:cell(quotation_type)=data>
                {{translations.types[data.item.quotation_type]}}
            </template>
            <template v-slot:cell(state)=data>
                {{translations.states[data.item.state]}}
            </template>
            <template v-slot:cell(quotation_date)=data>
                {{date.toLocalFormat(data.item.quotation_date)}}
            </template>
            <template v-slot:head(actions)="data">
                <div class="text-right">
                    <input
                    class="form-control-sm"
                    min="0"
                    v-bind:placeholder=translations.dashboard.page_size_placeholder
                    v-model=config.page_size_accepted
                    type="number" 
                    >
                </div>
            </template>
            <template v-slot:cell(actions)=data>
                <div class="text-right">
                    <a class="btn btn-warning text-white" v-bind:href=generateShowLink(data.item.id)>
                    <i class="fas fa-eye fa-xs"></i>
                    </a>
                    <a class="btn btn-success text-white" v-bind:href=generateEditLink(data.item.id)>
                    <i class="fas fa-edit fa-xs"></i>
                    </a>
                </div>
            </template>
        </b-table>
        <div>
            <h2 class="text-primary">
                <b>
                    {{translations.dashboard.state_expired}}
                </b>
            </h2>
        </div>
        <b-table 
            id="quotations_table" 
            thead-tr-class="bg-primary text-white" 
            class="table table-sm table-striped"
            :items=quotation_expired
            :fields=table_headers
            :per-page=config.page_size_expired
            :current-page=config.current_page
        >
            <template v-slot:cell(quotation_type)=data>
                {{translations.types[data.item.quotation_type]}}
            </template>
            <template v-slot:cell(state)=data>
                {{translations.states[data.item.state]}}
            </template>
            <template v-slot:cell(quotation_date)=data>
                {{date.toLocalFormat(data.item.quotation_date)}}
            </template>
            <template v-slot:head(actions)="data">
                <div class="text-right">
                    <input
                    class="form-control-sm"
                    min="0"
                    v-bind:placeholder=translations.dashboard.page_size_placeholder
                    v-model=config.page_size_expired
                    type="number" 
                    >
                </div>
            </template>
            <template v-slot:cell(actions)=data>
                <div class="text-right">
                    <a class="btn btn-warning text-white" v-bind:href=generateShowLink(data.item.id)>
                    <i class="fas fa-eye fa-xs"></i>
                    </a>
                    <a class="btn btn-success text-white" v-bind:href=generateEditLink(data.item.id)>
                    <i class="fas fa-edit fa-xs"></i>
                    </a>
                </div>
            </template>
        </b-table>
    </div>
  </div>
</template>