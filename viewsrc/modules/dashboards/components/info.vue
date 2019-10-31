<script>
export default {
  props: {
    info: {
      type: Array
    }
  },
  data() {
    return {
      table_fields: [],
      translations: I18n.t('dashboards.index'),

    }
  },
  mounted () {
    this.table_fields = [
      {
          key: 'id',
          label: this.translations.components.quotation
      }, {
          key: 'name_user',
          label: this.translations.components.user
      }, {
          key: 'name',
          label: this.translations.components.client
      }, {
          key: 'date',
          label: this.translations.components.date
      }
    ]
  }
}
</script>

<template>
      <b-table striped 
            :fields="table_fields"
            :items="info" 
            >
          </b-table>
</template>