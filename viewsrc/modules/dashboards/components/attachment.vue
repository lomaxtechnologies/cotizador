<script>
export default {
    props: {
      title: {
        type: String, default: null
      }
    },
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
            console.log(JSON.stringify(response));
            this.last_attachment = response.data.map(function(attachment){
                return{
                  Archivo: attachment.name,
                  Usuario: attachment.user,
                  Fecha: attachment.created_at
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