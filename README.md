# Encryptzator

Simple open-source encrypt-decrypt lib.

# Instalation

Just run

    bundle install

be happy ;)

# Usatage

load Encryptzator instantiating it. You will pass to it a message that you wish to encrypt and a random_password.

    cipher = Encryptzator.new
    coded_message = cipher.encrypt_message("My very secret message", "a random pass")

The coded message have two very important messages:
    coded_message[:iv]
    coded_message[:encrypted_message] 

Those two pieces of information should be kept in secrect, and they hold the keys to unlock the message secret:
    my_pass = "a random pass"
    decoded_message = cipher { random_pass: my_pass, iv: coded_message[:iv], encrypted_message: coded_message[:encrypted_message]}

    puts decoded_message 
    =>"My very secret message"