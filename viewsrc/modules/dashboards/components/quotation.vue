<script>
export default {
  data() {
    return {
      recent_updated_quotations: [],
      translations: I18n.t('dashboards.index'),
      table_headers: []
    }
  },
  mounted () {
    this.getLastQuotationsUpdated();
    this.setTableHeaders();
  },
  methods: {
    setTableHeaders() {
      this.table_headers = [
        {
          key: 'quotation',
          label: this.translations.components.quotation
        },
        {
          key: 'client',
          label: this.translations.components.client
        },
        {
          key: 'user',
          label: this.translations.components.user
        },
        {
          key: 'date',
          label: this.translations.components.date
        }
      ];
    },
    getLastQuotationsUpdated() {
      this.http
      .get('api/dashboard/recent_quotations')
      .then((response) => {
        if(response.successful){
          this.recent_updated_quotations = response.data;
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
  <b-card header-tag="header" footer-tag="footer" >
    <template>
    <div>
      <b-table 
        thead-tr-class="bg-lomax text-white" 
        striped small 
        :fields="table_headers" 
        :items="recent_updated_quotations" 
      >
        <template v-slot:cell(date)=data>
          {{date.toLocalFormat(data.value,true)}}
        </template>
      </b-table>
    </div>
    </template>
  </b-card>
</template>