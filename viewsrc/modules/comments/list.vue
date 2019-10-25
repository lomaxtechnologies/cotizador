<script>
export default {
    props: {
        quotation_id: {
            required: true,
            default: null
        }
    },
    data() {
        return {
            translations: I18n.t("comments.list"),
            table_fields: [],
            comments: []
        }
    },
    mounted() {
        this.table_fields = ['id', {
            key: 'name',
            label: this.translations.name
        }, {
            key: 'note',
            label: this.translations.note
        }, {
            key: 'date',
            label: this.translations.date
        }]
        this.getComments()
        this.bus.$on('post:/comments',() => this.getComments())
    },
    methods: {
        getComments() {
            this.http.get(`/api/comments/Quotation/${this.quotation_id}`).then(result =>{
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
                <b-table striped :fields="table_fields" :items="comments"></b-table>
            </div>
        </div>
    </section>
</template>