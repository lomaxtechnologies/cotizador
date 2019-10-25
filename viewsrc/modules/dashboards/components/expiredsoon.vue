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
      }
    }
}
</script>

<template>
    <div class="alert alert-danger text-center" role="alert">
        <h3>{{title_expired}}: {{expired_quotation_state}}</h3> 
    </div>
</template>