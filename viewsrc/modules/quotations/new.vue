<script type="text/javascript">
  import quotationHeader from './components/header.vue'
  import quotationMaterial from './components/material.vue'

   export default {
     components:{
       'quotation-header' : quotationHeader,
       'qotation-material': quotationMaterial
     },
    data() {
        return {
          translations: {
            title: I18n.t('quotations.new.title'),
            header:{
              title: I18n.t('quotations.new.header.title')
            },
            materials:{
              title: I18n.t('quotations.new.materials.title')
            },
            services:{
              title: I18n.t('quotations.new.services.title')
            },
            conditions:{
              title: I18n.t('quotations.new.conditions.title')
            },
            global_view:{
              title: I18n.t('quotations.new.global_view.title')
            }
          }
        }
    }
   }
</script>

<template>
  <div class='row'>
    <div class='col-lg-12 offset-xl-1 col-xl-10'>
      <h2 class='text-primary'>
        <b>{{translations.title}}</b>
      </h2>
      <b-card no-body>
        <b-tabs card>
          <b-tab>
            <template v-slot:title>
              {{translations.header.title}} &nbsp;
              <i class='fas fa-check-circle'></i>
            </template>
            <quotation-header>
            </quotation-header>
          </b-tab>
          <b-tab active>
            <template v-slot:title>
              {{translations.materials.title}} &nbsp;
              <i class='fas fa-check-circle'></i>
            </template>
            <qotation-material>
            </qotation-material>
          </b-tab>
          <b-tab>
            <template v-slot:title>
              {{translations.services.title}} &nbsp;
              <i class='fas fa-check-circle'></i>
            </template>
            {{translations.services.title}}
          </b-tab>
          <b-tab>
            <template v-slot:title>
              {{translations.conditions.title}} &nbsp;
              <i class='fas fa-check-circle'></i>
            </template>
            {{translations.conditions.title}}
          </b-tab>
          <b-tab>
            <template v-slot:title>
              {{translations.global_view.title}} &nbsp;
              <i class='fas fa-check-circle'></i>
            </template>
            {{translations.global_view.title}}
          </b-tab>
        </b-tabs>
      </b-card>
    </div>
  </div>
</template>