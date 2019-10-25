<script>
export default {
    data() {
        return {
            translations: I18n.t("comments.form"),
            comment: {
                note: 'ldonis',
                commentable_type: 'Quotation',
                commentable_id: 1
            }
        }
    },
    methods: {
        postComment(e) {
            if (e) { e.preventDefault() }
            this.http.post('/comments', {
                comment: this.comment
            }).then(result =>{
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        }
    }  
}
</script>
<template>
    <section>
        
        <form class="form-inline" @submit="postComment">
            <div class="form-group">
                <input type="text" class="form-control" v-model="comment.note" :placeholder="translations.add">
            </div>
            <button type="submit" class="btn btn-primary" @click="postComment">{{ translations.send }} </button>
        </form>
    </section>
</template>
<style scoped>
    .form-inline {
        border: 1px solid rgb(210, 210, 210);
        border-radius: 3px;
        padding: 10px 15px;
    }
    .form-inline .form-group {
        flex-grow: 1;
    }
    .form-inline .form-group input {
        width: 100%;
        border: none;
    }
    .form-inline .form-group input:focus {
        box-shadow: none;
    }
</style>