<script>
export default {
    data() {
        return{
          translations: I18n.t('dashboards.index'),
          last_comments: [],
          table_fields: []
        }
    },
    mounted() {
      this.getLastComments();
      this.table_fields = [
        {
            key: 'user',
            label: this.translations.components.user
        }, {
            key: 'date',
            label: this.translations.components.date
        }, {
            key: 'note',
            label: this.translations.components.note
        }]
    },
    methods: {
        getLastComments() {
            this.http
            .get('api/dashboard/comments')
            .then((response) => {
                if(response.successful){
                  this.last_comments = response.data
                }else{
                  console.log(JSON.stringify(this.response));
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
            :items="last_comments" 
            >
          </b-table>
        </div>
      </template>
    </b-card>
</template>