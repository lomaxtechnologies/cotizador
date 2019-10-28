<script>
export default {
  props: {
    amount: {
      type: Number, default: 0
    },
    title: {
      type: String, default: null
    }
  },
  data() {
    return {
    }
  },
  methods: {
          hola() {
            console.log('hola')
          }
  }
}
</script>

<template>
    <b-card header-tag="header" footer-tag="footer">
        <template v-slot:header>
          <h6 class="mb-0 text-center">
            <b>{{title}}</b>
          </h6>
        </template>
        <h2 class="text-center">{{amount}}</h2>
    </b-card>
</template>