<script>
export default {
    props: {
        expired_quotation_state: {
        },
        title_expired: {
            type: String, default: null
        }
    },
    data () {
      return {
          translations: I18n.t('dashboards.index'),
      }
    }
}
</script>

<template>
    <b-card header-tag="header" footer-tag="footer">
        <template v-slot:header>
          <h6 class="mb-0 text-center">
            <b>{{translations.expired_soon}}</b>
          </h6>
        </template>
        <h2 class="text-center">{{expired_quotation_state}}</h2>

    </b-card>
</template>