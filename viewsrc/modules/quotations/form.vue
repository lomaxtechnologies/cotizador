<script type="text/javascript">
import quotationHeader from "./components/header.vue";
import quotationProducts from "./components/products.vue";
import quotationConditions from "./components/conditions.vue";
import quotationServices from "./components/services.vue";
import quotationGlobalView from "./components/global_view.vue";
import quotationAttachments from "./components/attachments.vue";

export default {
  components: {
    "quotation-header": quotationHeader,
    "quotation-products": quotationProducts,
    "quotation-services": quotationServices,
    "quotation-conditions": quotationConditions,
    "quotation-global-view": quotationGlobalView,
    "quotation-attachments": quotationAttachments
  },

  props:{
    is_edit: {
      type: Boolean,
      default: false
    }
  },

  data() {
    return {
      translations: I18n.t("quotations.new_edit"),
      global_view_index: 4,
      tab_index: 0,
      //these are only used to change the color of the tabs to green when the user finishes a section
      completed: {
        header: false,
        products: false,
        services: false,
        conditions: false,
        global_view: false
      },
      refresh_global_view: false,
      quotation: {
        id: parseInt(this.$route.params.id) || null
      }
    };
  },

  created(){
    if(this.is_edit){
      this.completed.header = true;
      this.completed.products = true;
      this.completed.services = true;
      this.completed.conditions = true;
    }
  },

  computed: {
    globalViewCompleted: function() {
      return this.completed.header && this.tab_index === this.global_view_index;
    }
  },

  methods: {
    discardQuotation: function() {
      this.http
        .delete(`/quotations/${this.quotation.id}`)
        .then(response => {
          if (response.successful) {
            this.hideDiscardModal();
            this.$router.push({ path: "/index" });
            this.alert(this.translations.notifications.quotation_discarded);
          } else {
            this.handleError(response.error);
          }
        })
        .catch(err => {
          console.log("Error", err.stack, err.name, err.message);
        });
    },

    activateQuotation: function() {
      this.http
        .put(`api/quotations/${this.quotation.id}/activate`)
        .then(response => {
          if (response.successful) {
            this.alert(
              this.translations.notifications.quotation_activated,
              "success"
            );
            this.$router.push({ path: `/${this.quotation.id}/show` });
          } else {
            this.handleError(response.error);
          }
        })
        .catch(err => {
          console.log("Error", err.stack, err.name, err.message);
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
    },

    hideDiscardModal: function() {
      this.$bvModal.hide("discard-modal");
    }
  },

  watch: {
    "completed.header": function() {
      if (this.completed.header) {
        this.refresh_global_view = true;
        this.tab_index++;
      }
    },
    "completed.conditions": function() {
      if (this.completed.conditions) {
        this.refresh_global_view = true;
        this.tab_index++;
      }
    },
    "completed.services": function() {
      if (this.completed.services) {
        this.refresh_global_view = true;
        this.tab_index++;
      }
    },
    "completed.products": function() {
      if (this.completed.products) {
        this.refresh_global_view = true;
        this.tab_index++;
      }
    }
  }
};
</script>

<template>
  <div>
    <b-modal id="discard-modal" :title="translations.discard_modal.title">
      <p>{{translations.discard_modal.body}}</p>
      <template v-slot:modal-footer>
        <div>
          <b-button
            variant="danger"
            v-on:click="discardQuotation"
          >{{translations.discard_modal.yes_text}}</b-button>
          <b-button
            class="btn btn-secondary"
            v-on:click="hideDiscardModal"
          >{{translations.discard_modal.no_text}}</b-button>
        </div>
      </template>
    </b-modal>
    <b-card no-body>
      <b-tabs card v-model="tab_index">
        <b-tab  active>
          <template v-slot:title>
            <span v-bind:class="{'text-success':completed.header}">
              {{translations.header.title}} &nbsp;
              <i class="fas fa-check-circle"></i>
            </span>
          </template>
          <b-card-text>
            <quotation-header
              :section_valid.sync="completed.header"
              :quotation_id.sync="quotation.id"
            ></quotation-header>
          </b-card-text>
        </b-tab>
        <b-tab>
          <template v-slot:title>
            <span v-bind:class="{'text-success':completed.products}">
              {{translations.materials.title}} &nbsp;
              <i class="fas fa-check-circle"></i>
            </span>
          </template>
          <b-card-text>
            <quotation-products
              :section_valid.sync="completed.products"
              :quotation_id="quotation.id"
            ></quotation-products>
          </b-card-text>
        </b-tab>
        <b-tab>
          <template v-slot:title>
            <span v-bind:class="{'text-success':completed.services}">
              {{translations.services.title}} &nbsp;
              <i class="fas fa-check-circle"></i>
            </span>
          </template>
          <b-card-text>
            <quotation-services
              :section_valid.sync="completed.services"
              :quotation_id="quotation.id"
            ></quotation-services>
          </b-card-text>
        </b-tab>
        <b-tab>
          <template v-slot:title>
            <span v-bind:class="{'text-success':completed.conditions}">
              {{translations.conditions.title}} &nbsp;
              <i class="fas fa-check-circle"></i>
            </span>
          </template>
          <b-card-text>
            <quotation-conditions
              :section_valid.sync="completed.conditions"
              :quotation_id="quotation.id"
              :get_conditions="true"
            ></quotation-conditions>
          </b-card-text>
        </b-tab>
        <b-tab>
          <template v-slot:title>
            <span v-bind:class="{'text-success':completed.global}">
              {{translations.global_view.title}} &nbsp;
              <i class="fas fa-check-circle"></i>
            </span>
          </template>
          <b-card-text>
            <div class="row">
              <div class="col-12 text-right mb-2">
                <b-button
                  variant="danger"
                  v-b-modal.discard-modal
                  :disabled="quotation.id==null"
                >
                  <i class="fas fa-trash"></i>
                  &nbsp;{{translations.buttons.discard_quotation}}
                </b-button>
                <b-button
                  variant="primary"
                  :disabled="quotation.id==null"
                  v-on:click="activateQuotation"
                >
                  <i class="fas fa-check-circle"></i>
                  &nbsp;{{translations.buttons.approve_quotation}}
                </b-button>
              </div>
            </div>
            <quotation-global-view
              :section_valid.sync="completed.global_view"
              :refresh_quotation.sync="refresh_global_view"
              :quotation_id="quotation.id"
            ></quotation-global-view>
          </b-card-text>
        </b-tab>
        <b-tab>
          <template v-slot:title>
            <span v-bind:class="{'text-success':completed.global}">
              {{translations.attachments_view.title}} &nbsp;
              <i class="fas fa-check-circle"></i>
            </span>
          </template>
          <quotation-attachments :quotation_id="quotation.id" />
        </b-tab>
      </b-tabs>
    </b-card>
  </div>
</template>