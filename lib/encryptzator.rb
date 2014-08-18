require 'openssl'
require 'digest/sha2'
require "base64"

class Encryptzator
  def initialize
    #initialize cipher
    @cipher = OpenSSL::Cipher::AES.new(256, :CBC)
  end

  def encrypt_message(message, random_pass)
    #tell cipher that we want to encrypt a message
    @cipher.encrypt

    #Use password encrypt as a key
    #@cipher.random_key = Digest::SHA2.new(256).digest(random_pass)
    @cipher.key = Digest::SHA2.new(256).digest(random_pass)
    
    #generate random IV
    iv = @cipher.random_iv

    encrypted_message = @cipher.update(message) 
    encrypted_message << @cipher.final
    
    {iv: iv, encrypted_message: encrypted_message}
  end

  def decrypt_message(hash = {})
    #checa a integridade do hash
    check_hash_integrity hash
    
    #re-use the cipher for decrypt
    @cipher.decrypt
    @cipher.key = Digest::SHA2.new(256).digest(hash[:random_pass])
    @cipher.iv = hash[:iv]
    decrypt = @cipher.update(hash[:encrypted_message]) 
    decrypt << @cipher.final
  end

  #Encode the message returning the IV and encrypted message
  #separated by "((o))"
  def encrypt_message_utf8(message, random_pass)
    #tell cipher that we want to encrypt a message
    @cipher.encrypt
    #Use password encrypt as a key
    #@cipher.random_key = Digest::SHA2.new(256).digest(random_pass)
    @cipher.key = Digest::SHA2.new(256).digest(random_pass)
    
    #generate random IV
    iv = @cipher.random_iv

    encrypted_message = @cipher.update(message) 
    encrypted_message << @cipher.final
    
    #get encrypted message and convert from base ascii-8bit to utf-8
    encoded_iv = Base64.encode64(iv).encode('utf-8')
    encoded_message = Base64.encode64(encrypted_message).encode('utf-8')
    encoded_iv + "((o))" + encoded_message
  end

  #Decode message that has the separator "((o))" using 
  #the password key returning only the string decoded
  def decrypt_message_utf8(encoded_message, pass_key)
    pair = encoded_message.split("((o))")
    iv = Base64.decode64(pair.first).encode('ascii-8bit')
    encrypt_message = Base64.decode64(pair.last).encode('ascii-8bit')
    decrypt_message({random_pass: pass_key, iv: iv, encrypted_message: encrypt_message})
  end 


  private
    def decode_pass_key(pass_key)
      Base64.decode64(pass_key).encode('ascii-8bit')
    end

    def check_hash_integrity hash
      [:random_pass, :iv, :encrypted_message].each do |key|
        raise Exception.new("Argument :key '#{key}' is not into the Hash...")     unless hash.has_key?(key) 
        raise Exception.new("Hash is empty on key: '#{key}' ")                    if hash[key].empty? 
      end
    end
end

=begin
  

encrypt = Encryptzator.new
e = encrypt.encrypt_message("Very important message")

p "===================="

p encrypt.decrypt_message(e)
=end