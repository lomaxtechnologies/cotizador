<script>
export default {
    data(){
        return {
          translations: I18n.t('dashboards.index'),
          last_attachments: [],
          table_fields: []
        }
    },
    mounted() {
        this.getLastAttachments();
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
            key: 'name',
            label: this.translations.components.name
        }, {
            key: 'date',
            label: this.translations.components.date
        }]
    },
    methods: {
        getLastAttachments() {
            this.http
            .get('api/dashboard/attachments')
            .then((response) => {
                if(response.successful){
                  this.last_attachments = response.data
                }else{
                  console.log(JSON.stringify(response));
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
            :items="last_attachments" 
            >
          </b-table>
        </div>
      </template>
    </b-card>
</template>