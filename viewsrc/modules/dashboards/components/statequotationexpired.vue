<script>
export default {
  props: {
    expired: {
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
          key: 'user_id',
          label: this.translations.components.user
      }, {
          key: 'created_at',
          label: this.translations.components.date
      }
    ]
  }
}
</script>

<template>
      <b-table striped 
            :fields="table_fields"
            :items="expired" 
            >
          </b-table>
</template>