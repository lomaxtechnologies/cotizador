name = 'confirmation-modal';
window.confirmation_modal= {
   name: name,
   title_id: `${name}-title`,
   body_id: `${name}-body`,
   yes_button_id: `${name}-yes`,
   no_button_id: `${name}-no`,
   set_text: function(section_id,text){
      $(`#${section_id}`).html(text);
   }
   ,set_title: function(title){
      this.set_text(this.title_id,title);
   },
   set_body: function(body){
      this.set_text(this.body_id,body)
   },set_yes_text: function(yes_text){
      this.set_text(this.yes_button_id,yes_text);
   },set_no_text: function(no_text){
      this.set_text(this.no_button_id,no_text);
   },set_attr: function(id,key,value){
      $(`#${id}`).attr(key,value);
   }
};