require 'digest/sha1'
require 'openssl'
require 'pp'


module GoPay

  module Crypt
    extend self

    def sha1(string)
      Digest::SHA1.hexdigest(string)
    end

    def encrypt(string, secret)
      des = OpenSSL::Cipher::Cipher.new("des-ede3")
      des.encrypt
      des.key = secret
      result = des.update(string)
      result.unpack("H*").to_s
    end

  end

end
