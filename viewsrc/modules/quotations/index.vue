<script type="text/javascript">
  export default {

    data() {
      return {
        config: {
          current_page: 1,
          page_size: 10,
          show_modal:false,
          rows: 0,
          //This is the quotation to be deleted once the user confirms
          selected_quotation: null
        },
        translations: {
          index: I18n.t('quotations.index'),
          states: I18n.t('quotations.states'),
          types: I18n.t('quotations.api_types')
        },
        table_headers:[],
        quotations: [],
        filters:{
          id: '',
          quotation_date: ''
        }
      }
    },

    mounted: function(){
      this.getQuotations();
      this.setTableHeaders();
    },

    computed:{

      filteredQuotations: function(){
        var filtered_quotations = this.quotations.filter((quotation)=>{
          return String(quotation.id+100).includes(this.filters.id) && quotation.quotation_date.includes(this.filters.quotation_date);
        });
        this.config.rows = filtered_quotations.length;
        this.config.current_page = 1;
        return filtered_quotations;
      }
    },

    methods:{

      deleteSelectedQuotation: function(){
        this.http
        .delete(`/quotations/${this.config.selected_quotation}`)
        .then((response)=>{
          this.$bvModal.hide('delete_confirmation_modal');
          if(response.successful){
            this.alert(this.translations.index.notifications.quotation_deleted);
            this.quotations = this.quotations.filter((quotation)=>{
              return quotation.id != this.config.selected_quotation;
            });
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      },

      generateEditLink: function(id){
        return `#/${id}/edit`
      },

      generateShowLink: function(id){
        return `#/${id}/show`
      },

      hideModal: function(){
        this.config.show_modal = false;
      },

      showModal: function(quotation_id){
        this.config.selected_quotation = quotation_id;
        this.config.show_modal = true;
      },

      setTableHeaders: function(){
        ['id','name','quotation_date','quotation_type','state','actions'].forEach((element)=>{
          this.table_headers.push({
            key:element,
            label:this.translations.index.headers[element],
            sortable:true
          });
        });
      },

      getQuotations: function(){
        this.http
        .get('api/quotations')
        .then((response)=>{
          if(response.successful){
            this.quotations = response.data;
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      }
    }
  }
</script>

<template>
  <div class="row">
    <b-modal 
      v-model=config.show_modal 
      id="delete_confirmation_modal"
      :title=translations.index.delete_modal.title
    >
      <p class="text-justify">{{translations.index.delete_modal.body}}</p>
      <template v-slot:modal-footer>
        <div>
          <b-button
            class="btn btn-danger"
            v-on:click=deleteSelectedQuotation
          > {{translations.index.delete_modal.yes_text}}
          </b-button>
          <b-button
            class="btn btn-secondary"
            v-on:click=hideModal
          > {{translations.index.delete_modal.no_text}}
          </b-button>
        </div>
      </template>
    </b-modal>
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <div class="form-row">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <div class="row">
                <div class="col-8">
                  <h4 class="text-primary">
                    <b>
                     {{translations.index.title}}
                    </b>
                  </h4>
                </div>
                <div class="col-4 text-right">
                  <b-link 
                    class="btn btn-primary" 
                    href="#/new">{{translations.index.buttons.new}}
                  </b-link>
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
                    <b-input v-model=filters.id></b-input>
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
                    <b-input v-model=filters.quotation_date type="date"></b-input>
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
      <b-table 
        id="quotations_table" 
        thead-tr-class="bg-primary text-white" 
        class="table table-sm table-striped"
        :items=filteredQuotations
        :fields=table_headers
        :per-page=config.page_size
        :current-page=config.current_page
      >
        <template v-slot:head(actions)="data">
          <div class="text-right">
            <input
              class="form-control-sm"
              min="0"
              v-bind:placeholder=translations.index.page_size_placeholder
              v-model=config.page_size
              type="number" 
            >
          </div>
        </template>
        <template v-slot:cell(id)=data>
          {{data.item.id+100}}
        </template>
        <template v-slot:cell(quotation_type)=data>
          {{translations.types[data.item.quotation_type]}}
        </template>
        <template v-slot:cell(state)=data>
          {{translations.states[data.item.state]}}
        </template>
        <template v-slot:cell(quotation_date)=data>
          {{date.toLocalFormat(data.item.quotation_date)}}
        </template>
        <template v-slot:cell(actions)=data>
          <div class="text-right">
            <a class="btn btn-warning text-white" v-bind:href=generateShowLink(data.item.id)>
              <i class="fas fa-eye fa-xs"></i>
            </a>
            <a class="btn btn-success text-white" v-bind:href=generateEditLink(data.item.id)>
              <i class="fas fa-edit fa-xs"></i>
            </a>
            <b-button class="btn btn-danger text-white" v-on:click=showModal(data.item.id)>
              <i class="fas fa-trash-alt fa-xs"></i>
            </b-button>
          </div>
        </template>
      </b-table>
      <b-pagination
        v-model=config.current_page
        :total-rows=config.rows
        :per-page=config.page_size
        aria-controls="quotations_table"
        class="justify-content-center"
      ></b-pagination>
    </div>
  </div>
</template>