<script>
export default {
    props: {
      title: {
        type: String, default: null
      }
    },
    data() {
      return {
        last_comment: []
      }
    },
    methods:{
      getLastComment: function () {
      this.http
      .get('api/dashboard/comment')
      .then((response) => {
          if(response.successful){
            this.last_comment = response.data.map((comment) => {
                return{ 
                  Cotización: comment.id+100,
                  Fecha: comment.created_at,
                  Usuario: comment.user,
                  Comentario: comment.note
                }
                } )
          }else{
            console.log(JSON.stringify(response));
          }
          })
      }
    },
    mounted: function(){
      this.getLastComment();
    }

}
</script>

<template>
    <b-card header-tag="header" footer-tag="footer" >
      <template>
        <div>
          <b-table striped hover small :items="last_comment"></b-table>
        </div>
      </template>
    </b-card>
</template>