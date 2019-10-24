<script>
export default {
    props: {
        quotation_expired: {
            type: Number, default: 0
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
    <div class="text-center">
      <h3>{{title_expired}}:</h3>
      <h1>{{quotation_expired}}</h1> 
    </div>
</template>