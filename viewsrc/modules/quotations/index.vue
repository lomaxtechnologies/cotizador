<script type="text/javascript">
  export default {
    data() {
      return {
        page_size: 10,
        translations: {
          index: I18n.t('quotations.index'),
          quotation_types: I18n.t('quotations.quotation_types'),
          states: I18n.t('quotations.states')
        },
        table_headers:[],
        quotations: []
      }
    },
    mounted: function(){
      this.getQuotations();
      this.setTableHeaders();
    },
    methods:{
      generateEditLink: function(id){
        return `/quotations/${id}/edit`
      },

      showDeleteModal: function(id){
        console.log(id);
      },

      setTableHeaders: function(){
        ['id','name','quotation_date','quotation_type','state','actions'].forEach((element)=>{
          this.table_headers.push({
            key:element,
            label:this.translations.index.headers[element],
            sortable:true
          })
        });
      },

      getQuotations: function(){
        this.http
        .get('api/quotations')
        .then((response)=>{
          this.quotations = response.data;
        }).catch((err)=>{
          console.log(JSON.stringify(err));
        });
      },
      formatDate: function(date){
        return '01/01/2001';
      }
    }
  }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <div class="form-row">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <div class="row">
                <div class="col-8">
                  <h4 class="text-primary">
                    <b>
                      Cotizaciones
                    </b>
                  </h4>
                </div>
                <div class="col-4 text-right">
                  <b-link class="btn btn-primary" href="#/new">{{translations.index.buttons.new}}</b-link>
                </div>
              </div>
            </div>
            <div class="card-body">
              <div class="form-row mb-2">
                <div class="col-12">
                  <b class="font-size-search">
                    {{translations.index.search_title}}
                  </b>
                </div>
              </div>
              <div class="form-row">
                <div class="col-3">
                  <b class="color-search-title">
                    {{translations.index.search_fields.titles.code}}
                  </b>
                  <div class="input-group-prepend">
                    <div class="input-group-text">
                      <i class="fas fa-barcode"></i>
                    </div>
                    <b-input></b-input>
                  </div>
                </div>
                <div class="col-3">
                  <b class="color-search-title">
                    {{translations.index.search_fields.titles.date}}
                  </b>
                  <div class="input-group-prepend">
                    <div class="input-group-text">
                      <i class="fas fa-calendar"></i>
                    </div>
                    <b-input></b-input>
                  </div>
                </div>
                <div class="col-2 offset-4 text-right button-margin-top">
                  <button class="btn-block btn btn-purple" type="submit" value="Search">
                    <i class="fas fa-search fa-sm"></i>
                     {{translations.index.buttons.search}}
                  </button>
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
      <b-table thead-tr-class="bg-primary text-white" class="table table-sm table-striped"
        :items=quotations
        :fields=table_headers
        :per_page=page_size
      >
        <template v-slot:head(actions)="data">
          <div class="text-right">
            <input
              class="form-control-sm"
              min="0"
              placeholder="<%= t('.page_size_placeholder') %>"
              type="<%= :number %>" 
              value="<%= @page_size %>"
            >
          </div>
        </template>

        <template v-slot:cell(id)=data>
          {{data.item.id+100}}
        </template>
        <template v-slot:cell(quotation_type)=data>
          {{translations.quotation_types[data.item.quotation_type]}}
        </template>
        <template v-slot:cell(state)=data>
          {{translations.states[data.item.state]}}
        </template>
        <template v-slot:cell(quotation_date)=data>
          {{date.toLocalFormat(data.item.quotation_date)}}
        </template>
        <template v-slot:cell(actions)=data>
          <div class="text-right">
            <a class="btn btn-success text-white mr-1" v-bind:href=generateEditLink(data.item.id)>
              <i class="fas fa-edit fa-xs"></i>
            </a>
            <b-button class="btn btn-danger text-white" v-on:click=showDeleteModal(data.item.id)>
              <i class="fas fa-trash-alt fa-xs"></i>
            </b-button>
          </div>
        </template>
      </b-table>
    </div>
  </div>
</template>