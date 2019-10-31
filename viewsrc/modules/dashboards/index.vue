<script>
    import dashboardQuotationStateCount from './components/state.vue'
    import dashboardQuotationExpiredSoon from './components/expiredsoon.vue'
    import dashboardQuotationComment from './components/comment.vue'
    import dashboardQuotationAttachment from './components/attachment.vue'
    import dashboardQuotationUpdated from './components/quotation.vue'
    import dashboardInfoState from './components/info.vue'
    import dashboardInfoExpiredSoon from './components/statequotationexpired.vue'
    export default {
      data(){
        return{
          states_count: {
              created: 0,
              active: 0,
              accepted: 0,
              expired: 0
              },
          info_states: {
            created: [],
            created: [],
            accepted: [],
            expired: [],
          },
          tabIndex: 1,
          expired_quotation:{},
          info_expired_quotation: {},
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
        //info-states
        'dashboard-quotation-created-info' : dashboardInfoState,
        'dashboard-quotation-active-info' : dashboardInfoState,
        'dashboard-quotation-accepted-info' : dashboardInfoState,
        'dashboard-quotation-expired-info' : dashboardInfoState,
        'dashboard-quotation-info-expired-soon': dashboardInfoExpiredSoon,
      },
      methods: {
          getStatesCounts: function() {
          this.http
          .get('api/dashboard/count-states')
          .then((response) => {
              if(response.successful){
                this.states_count = response.data
                console.log(JSON.stringify(this.states_count))
              }else{
                console.log(JSON.stringify(response));
              }
              }).catch((err)=>{
                console.log(JSON.stringify(err));
            });
          },
          getExpiredQuotations: function() {
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
          getInfoStates: function() {
          this.http
          .get('api/dashboard/info-states')
          .then((response) => {
              if(response.successful){
                this.info_states = response.data
              }else{
                console.log(JSON.stringify(response));
              }
          }).catch((err) => {
              console.log(JSON.stringify(err))
          })
          },
          getInfoExpiredSoon: function(){
          this.http
          .get('api/dashboard/state-expired-soon')
          .then((response) => {
              if(response.successful){
                this.info_expired_quotation = response.data
              }else{
                console.log(JSON.stringify(response));
              }
          }).catch((err) => {
              console.log(JSON.stringify(err))
          })
          }
        },
      mounted: function() {
        this.getStatesCounts();
        this.getExpiredQuotations();
        this.getInfoStates();
        this.getInfoExpiredSoon();
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
                :amount=states_count.created
                :title=translations.index.state_created
                class="bg-secondary"
                v-b-toggle.collapse-a
                >
                </dashboard-quotation-created>
                <dashboard-quotation-active
                :amount=states_count.active
                :title=translations.index.state_active
                class="bg-primary"
                v-b-toggle.collapse-a2
                >
                </dashboard-quotation-active>
                <dashboard-quotation-accepted
                :amount=states_count.accepted
                :title=translations.index.state_accepted
                class="bg-success"
                v-b-toggle.collapse-a3
                >
                </dashboard-quotation-accepted>
                <dashboard-quotation-expired-soon
                 :title_expired=translations.index.expired_soon
                 :expired_quotation_state=expired_quotation
                 class="bg-warning"
                 v-b-toggle.collapse-a4
                 >
                </dashboard-quotation-expired-soon>
                <dashboard-quotation-expired
                :amount=states_count.expired
                :title=translations.index.state_expired
                class="bg-danger"
                v-b-toggle.collapse-a5
                >
                </dashboard-quotation-expired>
              </b-card-group>
              <div>
                <b-collapse id="collapse-a" class="mt-2">
                  <dashboard-quotation-created-info
                  :info=info_states.created
                  >
                  </dashboard-quotation-created-info>
                </b-collapse>
                <b-collapse id="collapse-a2" class="mt-2">
                  <dashboard-quotation-active-info
                  :info=info_states.active
                  >
                  </dashboard-quotation-active-info>
                </b-collapse>
                <b-collapse id="collapse-a3" class="mt-2">
                  <dashboard-quotation-accepted-info
                  :info=info_states.accepted
                  >
                  </dashboard-quotation-accepted-info>
                </b-collapse>
                <b-collapse id="collapse-a4" class="mt-2">
                   <dashboard-quotation-info-expired-soon
                   :info=info_expired_quotation>
                  </dashboard-quotation-info-expired-soon>
                </b-collapse>
                <b-collapse id="collapse-a5" class="mt-2">
                  <dashboard-quotation-expired-info
                  :info=info_states.expired
                  >
                  </dashboard-quotation-expired-info>
                </b-collapse>
              </div>
          </div>
          <br>
          <div>
            <b-card no-body>
              <b-tabs v-model="tabIndex" small card>
                <b-tab active :title="translations.index.last_quotation_update">
                  <b-card-group deck >
                  <dashboard-quotation-updated>
                  </dashboard-quotation-updated>
                  </b-card-group>
                </b-tab>
                <b-tab :title="translations.index.last_attachments">
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
              </b-tabs>
            </b-card>
          </div>
        </div>
      <br>
    </div>
  </div>
</template>