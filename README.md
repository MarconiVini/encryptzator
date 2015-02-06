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