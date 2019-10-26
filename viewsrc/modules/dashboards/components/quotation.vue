<script>
export default {
    data() {
        return {
            last_quotation_updated: []
        }
    },
    methods: {
        getQuotationUpdated() {
            this.http.get('api/dashboard/quotation_update').then(response =>{
                if (response.successful) {
                console.log(JSON.stringify(response));
                    this.last_quotation_updated = response.data.map((quotation) => {
                  return{ 
                    Cotización: quotation.id+100,
                    Usuario: quotation.user,
                    Fecha: quotation.created_at
                  }
                  } )
                  }else{
            console.log(JSON.stringify(response));
          }
          }).catch((err)=>{
            console.log(JSON.stringify(err));
        });
      }
    },
    mounted() {
        this.getQuotationUpdated()
    },
}
</script>
<template>
    <b-card header-tag="header" footer-tag="footer" >
      <template>
        <div>
          <b-table striped hover :items="last_quotation_updated"></b-table>
        </div>
      </template>
    </b-card>
</template>