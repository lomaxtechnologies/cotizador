<script>
export default {
  data() {
    return{
      translations: I18n.t('dashboards.index'),
      recent_comments: [],
      table_headers: []
    }
  },
  mounted() {
    this.getLastComments();
    this.setTableHeaders();
  },
  methods: {
    setTableHeaders() {
      this.table_headers = [
        {
          key: 'commentable_id',
          label: this.translations.components.quotation
        },
        {
          key: 'user',
          label: this.translations.components.user
        },
        {
          key: 'date',
          label: this.translations.components.date
        },
        {
          key: 'note',
          label: this.translations.components.note
        }
      ];
    },
    getLastComments() {
      this.http
      .get('/api/dashboard/comments')
      .then((response) => {
        if(response.successful){
          this.recent_comments = response.data;
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
        :items="recent_comments" 
      >
        <template v-slot:cell(date)=data>
          {{date.toLocalFormat(data.value,true)}}
        </template>
      </b-table>
    </div>
    </template>
  </b-card>
</template>