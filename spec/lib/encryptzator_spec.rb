require 'encryptzator'

describe Encryptzator do 
  let(:encryp)  { Encryptzator.new }
  let(:message) { "Believe you can and you're halfway there." }
  let(:my_pass) { "mg@&$$Hdhahnntrumble" }

  it 'should initialize' do
    expect(Encryptzator.new.class).to eq Encryptzator
  end

  describe 'Encrypting' do
    it 'should have an encrypt message return values' do
      message_hash = encryp.encrypt_message(message, my_pass)
      expect(message_hash[:encrypted_message]).not_to be nil
      expect(message_hash[:encrypted_message].encoding.to_s).to eq "ASCII-8BIT"
      expect(message_hash[:iv]).not_to be nil
    end

    describe "utf-8" do
      it "return string is utf-8" do
        message_hash = encryp.encrypt_message_utf8(message, my_pass)
        expect(message_hash).not_to be nil
        expect(message_hash.encoding.to_s).to eq "UTF-8"
      end

      it "has a string separator" do
        message_hash = encryp.encrypt_message_utf8(message, my_pass)
        expect(message_hash).to include "((o))"
      end
    end
  end

  describe 'Decrypting' do
    let(:message_hash) { encryp.encrypt_message(message, my_pass) }
    let(:iv)      { message_hash[:iv] }
    let(:encrypted_message) { message_hash[:encrypted_message] }
    #hash for decrypting
    let(:hash) {{ random_pass: my_pass, iv: iv, encrypted_message: encrypted_message}}

    it "should check hash paramters integrity of random_pass" do
      hash = {}
      hash[:iv] = iv
      hash[:encrypted_message] = encrypted_message
      expect(lambda{@encryp.decrypt_message hash}).to raise_exception
    end
    
    it "should check hash paramters integrity of iv" do
      hash = {}
      hash[:encrypted_message] = encrypted_message
      hash[:random_pass] = my_pass
      expect(lambda{encryp.decrypt_message hash}).to raise_exception
    end

    it "should check hash paramters integrity of encrypted_message" do
      hash = {}
      hash[:iv] = @iv
      hash[:random_pass] = @my_pass
      expect(lambda{@encryp.decrypt_message hash}).to raise_exception
    end

    it "should decrypt the final message" do
        expect(encryp.decrypt_message hash).to be_eql message
    end
  end

  describe 'Decrypting when message is in UTF-8' do
    let(:encrypt_message) {encryp.encrypt_message_utf8(message, my_pass)}

    it "should decrypt message" do
      expect(encryp.decrypt_message_utf8(encrypt_message, my_pass)).to be_eql message
    end

    it "message shuld be utf-8" do
      expect(encryp.decrypt_message_utf8(encrypt_message, my_pass).encoding.to_s).to eql 'UTF-8'
    end
  end
  
end