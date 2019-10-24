<script>
    import dashboardQuotationStateCount from './components/state.vue'
    import dashboardQuotationExpiredSoon from './components/expiredsoon.vue'
    export default {
      data(){
        return{
          states_count: {
              created: 0,
              active: 0,
              accepted: 0,
              expired: 0
              },
          expired_quotation: {
              quotation_date: 0
          },    
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
        'dashboard-quotation-expired-soon' : dashboardQuotationExpiredSoon
        },
      methods: {
          getStatesCounts: function () {
          this.http
          .get('api/dashboard/count-states')
          .then((response)=>{
              if(response.successful){
                this.states_count = response.data
                console.log(JSON.stringify(states_count));
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
          .then((response)=>{
          if(response.successful){
            this.expired_quotation = response.data
            console.log(JSON.stringify(this.expired_quotation));
      
          }else{
            this.handleError(response.error);
          }
          }).catch((err)=>{
            console.log("Error", err.stack, err.name, err.message);
          });
            }
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
                >
                </dashboard-quotation-active>
                <dashboard-quotation-accepted
                :amount = states_count.accepted
                :title=translations.index.state_accepted
                >
                </dashboard-quotation-accepted>
                <dashboard-quotation-expired
                :amount = states_count.expired
                :title=translations.index.state_expired
                >
                </dashboard-quotation-expired>
              </b-card-group>
          </div>
          <br>
          <div>  
            <b-card class="text-center">
                <dashboard-quotation-expired-soon
                 :title_expired=translations.index.expired_soon
                 :quotation_expired = expired_quotation.quotation_date
                 >
                </dashboard-quotation-expired-soon>
            </b-card>
          </div>
        </div>
      <br>
    </div>
  </div>
</template>