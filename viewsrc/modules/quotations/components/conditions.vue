<script type="text/javascript">
  import { Editor, EditorContent, EditorMenuBar } from 'tiptap';
  import {
    Blockquote,
    CodeBlock,
    HardBreak,
    Heading,
    HorizontalRule,
    OrderedList,
    BulletList,
    ListItem,
    TodoItem,
    TodoList,
    Bold,
    Code,
    Italic,
    Link,
    Strike,
    Underline,
    History,
  } from 'tiptap-extensions';

  export default {

    props:{
      section_valid: {
        type: Boolean,
        default: false
      },
      quotation_id:{
        type:Number,
        default: null
      }
    },
    
    components: {
      "editor-content": EditorContent,
      "editor-menu-bar": EditorMenuBar,
    },

    data(){
      return {
        translations: I18n.t('quotations.new_edit.conditions'),
        quotation:{
          payment_condition:'',
          warranty:''
        },
        editors: [
          //Editor for payment_condition
          {
            name:'payment_condition',
            editor: new Editor({
              extensions: [
                new Blockquote(),
                new BulletList(),
                new CodeBlock(),
                new HardBreak(),
                new Heading({ levels: [1, 2, 3] }),
                new HorizontalRule(),
                new ListItem(),
                new OrderedList(),
                new TodoItem(),
                new TodoList(),
                new Link(),
                new Bold(),
                new Code(),
                new Italic(),
                new Strike(),
                new Underline(),
                new History(),
              ],
              content: '',
              onUpdate: ({getJson,getHTML})=>{
                this.quotation.payment_condition = getHTML();
              }
            }),
          },
          //Editor for warranty
          {
            name:'warranty',
            editor: new Editor({
              extensions: [
                new Blockquote(),
                new BulletList(),
                new CodeBlock(),
                new HardBreak(),
                new Heading({ levels: [1, 2, 3] }),
                new HorizontalRule(),
                new ListItem(),
                new OrderedList(),
                new TodoItem(),
                new TodoList(),
                new Link(),
                new Bold(),
                new Code(),
                new Italic(),
                new Strike(),
                new Underline(),
                new History(),
              ],
              content: '',
              onUpdate: ({getJson,getHTML})=>{
                this.quotation.warranty = getHTML();
              }
            }),
          }
        ]
      }
    },

    mounted(){
      this.getConditions();
    },

    beforeDestroy() {
      this.editors.forEach((editor)=>{
        this.editor.destroy();
      });
    },

    methods:{
      getConditions(){
        if(this.quotation_id){
          this.http
          .get(`/api/quotations/${this.quotation_id}/conditions`)
          .then((response)=>{
            if(response.successful){
              this.setConditions(response.data);
            }else{
              this.handleError(response.error);
            }
          }).catch((err)=>{
            console.log("Error", err.stack, err.name, err.message);
          })
        }
      },
      //sets the quotation data, and also sets the editors text
      setConditions(data){
        this.quotation = data;
        this.editors.forEach((editor)=>{
          editor.editor.setContent(data[editor.name]);
        });
      },
      
      updateConditions(event){
        event.preventDefault();
        this.$emit('update:section_valid', false);
        this.http
        .put(`/quotations/${this.quotation_id}`, {quotation: this.quotation})
        .then((response)=>{
          if(response.successful){
            this.$emit('update:section_valid', true);
            this.alert(this.translations.notifications.conditions_updated,'success');
          }else{
            this.handleError(response.error);
          }
        }).catch((err)=>{
          console.log("Error", err.stack, err.name, err.message);
        });
      }
    }
  }
</script>

<template>
  <div>
    <b-form @submit=updateConditions>
      <b-form-row>
        <div class="col-12 mb-3" v-for="editor in editors" v-bind:key="editor.name">
          <label class="mb-0 text-primary font-weight-bold">
            {{translations.titles[editor.name]}}
          </label>
          <div class="card">
            <div class="card-header bg-light">
              <editor-menu-bar :editor="editor.editor" v-slot="{commands,isActive}">
                <div class="menubar">
                  <b-button variant="light" @click="commands.paragraph" :class="{'active':isActive.paragraph()}">
                    <i class="fas fa-paragraph"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.bold" :class="{'active':isActive.bold()}">
                    <i class="fas fa-bold"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.italic" :class="{'active':isActive.italic()}">
                    <i class="fas fa-italic"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.strike" :class="{'active':isActive.strike()}">
                    <i class="fas fa-strikethrough"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.underline" :class="{'active':isActive.underline()}">
                    <i class="fas fa-underline"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.heading({level:1})" :class="{'active':isActive.heading({level:1})}">
                    H1
                  </b-button>
                  <b-button variant="light" @click="commands.heading({level:2})" :class="{'active':isActive.heading({level:2})}">
                    H2
                  </b-button>
                  <b-button variant="light" @click="commands.heading({level:3})" :class="{'active':isActive.heading({level:3})}">
                    H3
                  </b-button>
                  <b-button variant="light" @click="commands.bullet_list" :class="{'active':isActive.bullet_list()}">
                    <i class="fas fa-list-ul"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.ordered_list" :class="{'active':isActive.ordered_list()}">
                    <i class="fas fa-list-ol"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.undo">
                    <i class="fas fa-undo"></i>
                  </b-button>
                  <b-button variant="light" @click="commands.redo">
                    <i class="fas fa-redo"></i>
                  </b-button>
                </div>
              </editor-menu-bar>
            </div>
            <editor-content class="border p-3" :editor="editor.editor">
            </editor-content>
          </div>
        </div>
        <div class="col-2 offset-10 mb-3">
          <b-button variant="primary" block type="submit">
            {{translations.next}}
          </b-button>
        </div>
      </b-form-row>
    </b-form>
  </div>
</template>
