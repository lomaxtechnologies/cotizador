<script>
export default {
    data() {
        return {
            comments: []
        }
    },
    mounted() {
        this.getComments()
    },
    methods: {
        getComments() {
            this.http.get('/api/comments/Quotation/1').then(result =>{
                if (result.successful) {
                    this.comments = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section>
        <div class="card">
            <div class="card-body">
                <b-table striped :fields="['id', 'name', 'note', 'date']" :items="comments"></b-table>
            </div>
        </div>
    </section>
</template>