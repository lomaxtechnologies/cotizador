<script>
export default {
    data() {
      return {
          last_quotations_updated: [],
          translations: I18n.t('dashboards.index'),
          table_fields: []
      }
    },
    mounted () {
       this.getLastQuotationsUpdated();
       this.table_fields = [
         {
            key: 'quotation',
            label: this.translations.components.quotation
         }, {
            key: 'client',
            label: this.translations.components.client
         }, {
            key: 'user',
            label: this.translations.components.user
         }, {
            key: 'date',
            label: this.translations.components.date
         }
       ]
    },
    methods: {
        getLastQuotationsUpdated() {
            this.http
            .get('api/dashboard/quotations_update')
            .then((response) => {
                if(response.successful){
                  this.last_quotations_updated = response.data
                }else{
                  console.log(JSON.stringify(response))
                }
            })
        }
    }
}
</script>

<template>
    <b-card header-tag="header" footer-tag="footer" >
      <template>
        <div>
          <b-table striped 
            :fields="table_fields" 
            :items="last_quotations_updated" 
            >
          </b-table>
        </div>
      </template>
    </b-card>
</template>