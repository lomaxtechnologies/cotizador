<script>
    import dashboardQuotationStateCount from './components/state.vue'
    import dashboardQuotationExpiredSoon from './components/expiredsoon.vue'
    import dashboardQuotationComment from './components/comment.vue'
    import dashboardQuotationAttachment from './components/attachment.vue'
    import dashboardQuotationUpdated from './components/quotation.vue'
    export default {
      data(){
        return{
          states_count: {
              created: 0,
              active: 0,
              accepted: 0,
              expired: 0
              },
              tabIndex: 1,
          expired_quotation: {},
          translations: {
              index: I18n.t('dashboards.index')
            }
          }
        },
      components:{
        'dashboard-quotation-created' : dashboardQuotationStateCount,
        'dashboard-quotation-active' : dashboardQuotationStateCount,
        'dashboard-quotation-accepted' : dashboardQuotationStateCount,
        'dashboard-quotation-expired' : dashboardQuotationStateCount,
        'dashboard-quotation-expired-soon' : dashboardQuotationExpiredSoon,
        'dashboard-quotation-comment' : dashboardQuotationComment,
        'dashboard-quotation-attachment' : dashboardQuotationAttachment,
        'dashboard-quotation-updated' : dashboardQuotationUpdated,

        },
      methods: {
          getStatesCounts: function () {
          this.http
          .get('api/dashboard/count-states')
          .then((response) => {
              if(response.successful){
                this.states_count = response.data
              }else{
                console.log(JSON.stringify(response));
              }
              }).catch((err)=>{
                console.log(JSON.stringify(err));
            });
          },
          getExpiredQuotations: function () {
          this.http
          .get('api/dashboard/expired-soon')
          .then((response) => {
              if(response.successful){
                this.expired_quotation = response.data
              }else{
                console.log(JSON.stringify(response));
              }
              }).catch((err)=>{
                console.log(JSON.stringify(err));
            });
          },
        },
        mounted: function(){
          this.getStatesCounts();
          this.getExpiredQuotations();
          }
      }
</script>

<template>
  <div class="row">
    <div class="col-lg-12 offset-xl-1 col-xl-10">
      <div>
          <div>
              <b-card-group deck >
                <dashboard-quotation-created
                :amount = states_count.created
                :title=translations.index.state_created
                >
                </dashboard-quotation-created>
                <dashboard-quotation-active
                :amount = states_count.active
                :title=translations.index.state_active
                class="bg-primary"
                >
                </dashboard-quotation-active>
                <dashboard-quotation-accepted
                :amount = states_count.accepted
                :title=translations.index.state_accepted
                class="bg-success"
                >
                </dashboard-quotation-accepted>
                <dashboard-quotation-expired
                :amount = states_count.expired
                :title=translations.index.state_expired
                class="bg-danger"
                >
                </dashboard-quotation-expired>
              </b-card-group>
          </div>
          <br>
          <div>  
                <dashboard-quotation-expired-soon
                 :title_expired=translations.index.expired_soon
                 :expired_quotation_state = expired_quotation
                 >
                </dashboard-quotation-expired-soon>
          </div>
          <br>
          <div>
            <!-- Tabs with card integration -->
            <b-card no-body>
              <b-tabs v-model="tabIndex" small card>
                <b-tab active :title="translations.index.last_attachments">
                  <b-card-group deck >
                  <dashboard-quotation-attachment>
                  </dashboard-quotation-attachment>
                  </b-card-group>
                </b-tab>
                <b-tab :title="translations.index.last_comments">
                  <b-card-group deck >
                  <dashboard-quotation-comment>
                  </dashboard-quotation-comment>
                  </b-card-group>
                </b-tab>
                <b-tab :title="translations.index.last_quotation_update">
                  <b-card-group deck >
                  <dashboard-quotation-updated>
                  </dashboard-quotation-updated>
                  </b-card-group>
                </b-tab>
              </b-tabs>
            </b-card>
          </div>
        </div>
      <br>
    </div>
  </div>
</template>