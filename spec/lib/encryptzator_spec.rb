require 'encryptzator'

describe Encryptzator do 
  describe 'ClassInitialize' do
    it 'should initialize' do
      u = Encryptzator.new
      expect(u.class).to eq Encryptzator
    end

    describe 'Encrypting' do
      before :each do
        @encryp = Encryptzator.new
        @message = "Believe you can and you're halfway there."
        @my_pass = "mg@&$$Hdhahnntrumble"
      end

      it 'should have an encrypt message return values' do
        message = @encryp.encrypt_message(@message, @my_pass)
        expect(message[:encrypted_message]).not_to be nil
        expect(message[:encrypted_message].encoding.to_s).to eq "ASCII-8BIT"
        expect(message[:iv]).not_to be nil
      end
    end

    describe 'Decrypting' do
      before :each do 

        @encryp = Encryptzator.new
        @message = "Believe you can and you're halfway there."
        @my_pass = "mg@&$$Hdhahnntrumble"
        message = @encryp.encrypt_message(@message, @my_pass)
        @iv = message[:iv]
        @encrypted_message = message[:encrypted_message]
        #hash for decrypting
        @hash = { random_pass: @my_pass, iv: @iv, encrypted_message: @encrypted_message}
      end

      it "should check hash paramters integrity of random_pass" do
        hash = {}
        hash[:iv] = @iv
        hash[:encrypted_message] = @encrypted_message
        expect(lambda{@encryp.decrypt_message hash}).to raise_exception
      end
      
      it "should check hash paramters integrity of iv" do
        hash = {}
        hash[:encrypted_message] = @encrypted_message
        hash[:random_pass] = @my_pass
        expect(lambda{@encryp.decrypt_message hash}).to raise_exception
      end

      it "should check hash paramters integrity of encrypted_message" do
        hash = {}
        hash[:iv] = @iv
        hash[:random_pass] = @my_pass
        expect(lambda{@encryp.decrypt_message hash}).to raise_exception
      end

      it "should decrypt the final message" do
        expect(@encryp.decrypt_message @hash).to be_eql @message
      end
    end

    describe 'Decrypting when message is in UTF-8' do
      before :each do 
        @encryp = Encryptzator.new
        @message = "Believe you can and you're halfway there."
        @my_pass = "mg@&$$Hdhahnntrumble"
        @encrypt_message = @encryp.encrypt_message_utf8(@message, @my_pass)
      end

      it "should decrypt message" do
        expect(@encryp.decrypt_message_utf8(@encrypt_message, @my_pass)).to be_eql @message
      end
    end
  end
end