<script type="text/javascript">
import quotationHeader from "./components/header.vue";
import quotationMaterials from "./components/material.vue";
import quotationConditions from "./components/conditions.vue";
import quotationService from "./components/service.vue";
import quotationGlobalView from "./components/global_view.vue";
import quotationAttachments from "./components/attachments.vue";

export default {
  components: {
    "quotation-header": quotationHeader,
    "quotation-materials": quotationMaterials,
    "quotation-service": quotationService,
    "quotation-conditions": quotationConditions,
    "quotation-global-view": quotationGlobalView,
    "quotation-attachments": quotationAttachments
  },

  data() {
    return {
      translations: I18n.t("quotations.new"),
      global_view_index: 4,
      tab_index: 0,
      //these are only used to change the color of the tabs to green when the user finishes a section
      completed: {
        header: false,
        materials: false,
        services: false,
        conditions: false,
        global_view: false
      },
      refresh_global_view: false,
      quotation: {
        id: null
      }
    };
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
            this.$router.push({ path: "/new" });
          } else {
            console.log(JSON.stringify(response));
          }
        })
        .catch(err => {
          console.log(JSON.stringify(err));
        });
    },

    activateQuotation: function() {
      this.http
        .put(`api/quotations/${this.quotation.id}/activate`)
        .then(response => {
          if (response.successful) {
            this.$router.push({ path: `/${this.quotation.id}/show` });
          } else {
            console.log(JSON.stringify(response));
          }
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
    "completed.materials": function() {
      if (this.completed.materials) {
        this.refresh_global_view = true;
        this.tab_index++;
      }
    }
  }
};
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
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
      <h2 class="text-primary">
        <b>{{translations.title}}</b>
      </h2>
      <div>
        <b-card no-body>
          <b-tabs card v-model="tab_index">
            <b-tab active>
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
                <span v-bind:class="{'text-success':completed.materials}">
                  {{translations.materials.title}} &nbsp;
                  <i class="fas fa-check-circle"></i>
                </span>
              </template>
              <b-card-text v-if="completed.header">
                <quotation-materials
                  :section_valid.sync="completed.materials"
                  :quotation_id="quotation.id"
                ></quotation-materials>
              </b-card-text>
            </b-tab>
            <b-tab>
              <template v-slot:title>
                <span v-bind:class="{'text-success':completed.services}">
                  {{translations.services.title}} &nbsp;
                  <i class="fas fa-check-circle"></i>
                </span>
              </template>
              <b-card-text v-if="completed.header">
                <quotation-service
                  :section_valid.sync="completed.services"
                  :quotation_id="quotation.id"
                ></quotation-service>
              </b-card-text>
            </b-tab>
            <b-tab>
              <template v-slot:title>
                <span v-bind:class="{'text-success':completed.conditions}">
                  {{translations.conditions.title}} &nbsp;
                  <i class="fas fa-check-circle"></i>
                </span>
              </template>
              <b-card-text v-if="completed.header">
                <quotation-conditions
                  :section_valid.sync="completed.conditions"
                  :quotation_id="quotation.id"
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
              <b-card-text v-if="completed.header">
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
              <b-card-text v-if="completed.header">
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
                <quotations-attachments :quotation_id="quotation.id" />
              </b-card-text>
            </b-tab>
          </b-tabs>
        </b-card>
      </div>
    </div>
  </div>
</template>