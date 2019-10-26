<script>
export default {
    data(){
        return {
          translations: I18n.t('dashboards.index'),
          last_attachments: []
        }
    },
    mounted() {
        this.getLastAttachments();
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
            :fields="['id', 'user', 'name', 'quotation', 'date' ]" 
            :items="last_attachments" 
            >
          </b-table>
        </div>
      </template>
    </b-card>
</template>