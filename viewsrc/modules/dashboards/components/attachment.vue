<script>
export default {
    data() {
      return {
        last_attachment: []
      }
    },
    methods:{
      getLastAttachment: function () {
      this.http
      .get('api/dashboard/attachment')
      .then((response) => {
          if(response.successful){
            this.last_attachment = response.data.map(function(attachment){
                return{
                  Cotización: attachment.quotation+100,
                  Archivo: attachment.name,
                  Usuario: attachment.user,
                  Fecha: attachment.created_at,
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
    mounted: function(){
      this.getLastAttachment();
    }

}
</script>

<template>
    <b-card header-tag="header" footer-tag="footer" >
      <template>
        <div>
          <b-table striped hover :items="last_attachment"></b-table>
        </div>
      </template>
    </b-card>
</template>