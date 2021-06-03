function scrollChat() {
    var chat = document.getElementById('chat');

    chat.scrollTo({top: 100, behavior: 'smooth'});
    chat.scrollTo({top: chat.scrollHeight, behavior: 'smooth'});
  }

  Vue.use(EmojiPicker)

  var app = new Vue({
      el: '#app',
      data: {
          date: '',
          author: '',
          showContacts: true,
          contacts: [],
          messages: [],
          message: '',
          playersWritingToMe: []
      },methods: {
        resiveMessage: function(message, author, time){
          this.msg = 
            `<div class="flex ">
              <div
                class="rounded py-2 px-3"
                style="background-color: #f2f2f2;padding:8px!important"
              >
                <p class="text-sm mt-1">${message}</p>
                <p class="text-right text-xs text-grey-dark mt-1">
                  ${time} pm 
                </p>
              </div>
            </div>`;

            this.messages.push({
              msg: this.msg,
              msgContent: message,
              author:author,
              resived: true
            });

            
            scrollChat()
        },
        sendMessage: function(message, author, time){
            this.msg =
              `<div class="flex justify-end mb-2">
                <div
                  class="rounded py-2 px-3"
                  style="background-color: #e2f7cb;padding:8px!important"
                >
                  <p class="text-sm mt-1">${message}</p>
                  <p class="text-right text-xs text-grey-dark mt-1">
                    ${time} pm 
                  </p>
                </div>
              </div>`;
              
              this.messages.push({
                msg: this.msg,
                msgContent: message,
                author: author,
                resived: false
              });

              
              scrollChat()
        },
        selectContact: function(name) {
          this.showContacts = false
          this.author = name // format
        },
        goback: function(){
          this.showContacts = true
        },
        sendToServer: function() {
          //app.sendMessage('Hola Marcelo','caca')
          mta.triggerEvent("sendMessageFromWebApp",this.author, this.message)
          this.message = ''
        },
        onKeyPress: function(e) {
          if (e.keyCode === 13) {
            mta.triggerEvent("sendMessageFromWebApp",this.author, this.message)
            this.message = ''
          }
        },
        showIsTyping: function(name){
          if(!this.playersWritingToMe.includes(name)){
            this.playersWritingToMe.push(name)
            // delates the player from writing to me list..
            var self = this
            setTimeout(function() {
              const index =  self.playersWritingToMe.indexOf(name);
              if (index > -1) {
                self.playersWritingToMe.splice(index, 1);
              }
            }, 1200);
          }
        }

        //todo: poder mandar ubicacion
      },directives: {
        focus: {
          inserted(el) {
            el.focus()
          },
        },
      }
  })

/*  app.sendMessage('Hola Marcelo','caca')
  app.resiveMessage('Hola weon','caca')
  app.sendMessage('Hola fff','caca')






// port this
if (guiGetText(chat_Windows[player].editBox) ~= '') then
      triggerServerEvent('onServerCheckShow', Cplayer, player,
                         getPlayerName(Cplayer))



*/

function isTyping() {
  setTimeout(function() {
    mta.triggerEvent('isTyping',app.author)
  },200);
  
}

  var today = new Date();
  var dd = String(today.getDate()).padStart(2, '0');
  var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
  var yyyy = today.getFullYear();
  
  app.date = mm + '/' + dd + '/' + yyyy;