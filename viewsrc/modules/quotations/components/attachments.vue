<script type="text/javascript">
export default {
  props: ["quotation_id"],
  created() {
    this.load();
  },
  data() {
    return {
      translations: I18n.t("quotations.attachments"),
      attachment: {
        file: null
      },
      attachments: {
        
      }
    };
  },
  methods: {
    load() {
      if (this.quotation_id) {
        this.http
          .get("/api/quotations/" + this.quotation_id + "/attachments")
          .then(response => {
            this.attachments = response.data;
          });
      }
    },
    create() {
      // Create form data to allow upload files
      let attachment = new FormData();
      attachment.append("attachment[file]", this.attachment.location);
      attachment.append("attachment[name]", this.attachment.location.name);

      this.http
        .post(
          "/api/quotations/" + this.quotation_id + "/attachments/create",
          attachment
        )
        .then(response => {
          this.load();
        });
    },
    view(attached) {
      window.open(
        "/api/quotations/" + this.quotation_id + "/attachments/" + attached.id,
        "_blank"
      );
    },
    remove(attached) {
      this.http
        .delete(
          "/api/quotations/" +
            this.quotation_id +
            "/attachments/" +
            attached.id +
            "/destroy"
        )
        .then(response => {
          this.load();
        });
    }
  },
  watch: {
    quotation_id() {
      this.load();
    }
  }
};
</script>
<template>
  <div class="row">
    <div class="col-12">
      <button type="button" class="btn btn-primary pull-right" v-b-modal.attachment-upload>
        <i class="fa fa-plus"></i>
        Attach file
      </button>
    </div>
    <div
      class="col-12 attachment-list text-center"
      v-for="(attached,index) in attachments"
      :key="'attachmend_' + index"
    >
      <label>{{ attached.name }}</label>
      <a @click="view(attached)">
        <i class="fa fa-eye"></i>
      </a>
      <a @click="remove(attached)">
        <i class="fa fa-trash"></i>
      </a>
    </div>
    <b-modal id="attachment-upload" @ok="create">
      <b-form-group :label="translations.upload">
        <b-form-file v-model="attachment.location" />
      </b-form-group>
    </b-modal>
  </div>
</template>