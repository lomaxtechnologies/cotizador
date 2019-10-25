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
    <div>
        <div class="alert alert-danger text-center" role="alert">
        <p>{{title_expired}}: {{expired_quotation_state}}</p> 
        </div>    
    </div>
</template>