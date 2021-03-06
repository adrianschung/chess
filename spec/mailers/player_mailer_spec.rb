require 'rails_helper'

RSpec.describe PlayerMailer, type: :mailer do
  describe 'game joined' do
    let(:white) { FactoryBot.create(:player, playername: 'White') }
    let(:black) { FactoryBot.create(:player, playername: 'Black') }
    let(:game) { FactoryBot.create(:game, white_player: white, black_player: black) }
    let(:mail) { PlayerMailer.game_joined(game) }

    it 'renders the headers' do
      expect(mail.subject).to eq('A player has joined your game')
      expect(mail.to).to eq([white.email])
      expect(mail.from).to eq(['do-not-reply@chesssenders.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(white.playername)
      expect(mail.body.encoded).to match(black.playername)
      expect(mail.body.encoded).to match(game_url(game))
    end
  end

  describe 'message sent' do
    let(:sender) { FactoryBot.create(:player, playername: 'Sender') }
    let(:recipient) { FactoryBot.create(:player, playername: 'Recipient') }
    let(:conversation) { Conversation.create(sender_id: sender.id, recipient_id: recipient.id) }
    let(:message) {
      Message.create(body: 'test',
                     conversation_id: conversation.id,
                     player_id: sender.id)
    }
    let(:mail) { PlayerMailer.message_sent(message) }

    it 'renders the headers' do
      expect(mail.subject).to eq('A player has sent you a message')
      expect(mail.to).to eq([recipient.email])
      expect(mail.from).to eq(['do-not-reply@chesssenders.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(recipient.playername)
      expect(mail.body.encoded).to match(sender.playername)
      expect(mail.body.encoded).to match(conversation_messages_url(conversation))
    end
  end
end
