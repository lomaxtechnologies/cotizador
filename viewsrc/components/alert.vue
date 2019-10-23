<script type="text/javascript">
  export default {
    data() {
      return {
        variant: 'info',
        text: '',
        dismissSecs: 10,
        dismissCountDown: 0
      }
    },

    created: function(){
      this.bus.$on('show-vue-alert',(text,type='info')=>{
        this.show(text,type);
      });
    },

    methods: {
      show(text, type) {
        this.text = text;
        this.variant = type;
        this.dismissCountDown = this.dismissSecs;
      },

      countDownChanged (dismissCountDown) {
        this.dismissCountDown = dismissCountDown;
      }
    }
  }
</script>

<template>
  <b-alert 
    id="vue-alert"
    dismissible="dismissible"
    :variant=variant
    :show=dismissCountDown
    v-on:dismissed="dismissCountDown=0"
    v-on:dismiss-count-down="countDownChanged"
  >
    <p>{{text}}</p>
  </b-alert>
</template>

<style type="text/css">
  #vue-alert{
    position: fixed;
    margin: 0 auto;
    border: none;
    z-index: 1021;
    padding-left: 1em;
    padding-right: 1em;
    padding-top: 1.3em;
    width: 96%;
    right: 0;
    left: 0;
    top: 1em;
  }
</style>