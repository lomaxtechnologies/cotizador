<script type="text/javascript">
import quotationHeader from "./components/header.vue";
import quotationMaterials from "./components/material.vue";
import quotationConditions from "./components/conditions.vue";
import quotationService from "./components/service.vue";
import quotationAttachments from "./components/attachments.vue";

export default {
  components: {
    "quotation-header": quotationHeader,
    "quotation-materials": quotationMaterials,
    "quotation-service": quotationService,
    "quotation-conditions": quotationConditions,
    "quotation-attachments": quotationAttachments
  },

  data() {
    return {
      translations: I18n.t("quotations.new"),
      tab_index: 0,
      //these are only used to change the color of the tabs to green when the user finishes a section
      completed: {
        header: false,
        materials: false,
        services: false,
        conditions: false,
        global_view: false
      },
      quotation: {
        id: null
      }
    };
  },

  watch: {
    "completed.header": function() {
      if (this.completed.header) {
        this.tab_index++;
      }
    },
    "completed.conditions": function() {
      if (this.completed.conditions) {
        this.tab_index++;
      }
    },
    "completed.services": function() {
      if (this.completed.services) {
        this.tab_index++;
      }
    },
    "completed.materials": function() {
      if (this.completed.materials) {
        this.tab_index++;
      }
    }
  }
};
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
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
              <b-card-text>
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
              <b-card-text>
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
              <b-card-text>
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
              <b-card-text></b-card-text>
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
    </div>
  </div>
</template>