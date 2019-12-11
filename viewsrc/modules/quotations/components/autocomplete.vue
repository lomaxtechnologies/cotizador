<script>
export default {

  props: ["value", "source", "placeholder"],

  data() {
    return {
      search: "",
      disableSearch: false,
      options: [],
      selected: {
        id: 0,
        value: ""
      },
      childs: null,
      index: 0
    };
  },

  mounted() {
    this.disableSearch = true;
    if (typeof this.value === "object") {
      this.search = this.value.value;
      this.selected = this.value;
    } else {
      this.search = this.value;
    }
    setTimeout(() => {
      this.disableSearch = false;
    }, 300);
  },

  methods: {
    listeners() {
      this.childs = this.$refs.list.querySelectorAll("li");
      document.getElementById("autocomplete-component").onkeydown = e => {
        if([38, 40, 13].includes(e.keyCode)){
          e.preventDefault()
        }
        switch (e.keyCode) {
          case 38:
            if (this.index > 0) {
              this.index--;
            }
            this.childs[this.index].focus();
            break;
          case 40:
            if (this.index < this.childs.length - 1) {
              this.index++;
            }
            this.childs[this.index].focus();
            break;
          case 13:
            this.childs[this.index].click();
            break;
        }
      };
    },

    loadOptions() {
      this.index = 0
      this.bus.$emit("autocomplete:unselected");
      this.http.get(this.$props.source, {
        params: {
          search: this.search.toLowerCase()
        }
      }).then(response => {
        this.options = response.data;
      }).then(this.listeners);
    },

    select(e, option) {
      e.preventDefault();
      this.disableSearch = true;
      this.options = [];
      this.selected = option;
      this.search = option.value;
      this.bus.$emit("autocomplete:selected", this.selected);
      document.getElementById("autocomplete-input").focus(); 
      setTimeout(() => {
        this.disableSearch = false;
      }, 300);
    }


  },

  watch: {

    search(value) {
      if (!this.disableSearch) {
        if (value !== "") {
          this.loadOptions();
        } else {
          this.options.length = 0;
        }
      }
    },

    value(value) {
      if (typeof value === "object") {
        this.search = value.value;
      } else {
        this.search = value;
      }
    }

  }
}
</script>
<template>
  <div id="autocomplete-component" class="component w-100">
    <input
      id="autocomplete-input"
      class="form-control text_input"
      type="text"
      v-model="search"
      :required="true"
      :placeholder="placeholder"
      ref="result"
    />
    <ul id="autocomplete-wrap" class="list-group w-100" v-show="options.length > 0" ref="list">
        <li
          class="list-group-item list-group-item-action"
          v-for="(option, index) in options"
          :key="option.id"
          @click="select($event, option)"
          :tabindex="index + 1"
        >
          {{ option.value }}
        </li>
    </ul>
  </div>
</template>
<style lang="scss">
#autocomplete-wrap {
  background-color: #FFFFFF;
  position: absolute;
  z-index: 200;
}
#autocomplete-wrap li {
  padding: 0.25rem;
}
</style>
