require "digest/sha1"
require "openssl"

module GoPay

  module Crypt
    extend self

    def sha1(string)
      Digest::SHA1.hexdigest(string)
    end

    def encrypt(object)
      string = sha1(object.concat)
      des = OpenSSL::Cipher::Cipher.new("des-ede3")
      des.encrypt
      des.key = GoPay.configuration.secret
      result = des.update(string)
      result.unpack("H*").to_s
    end

  end

end
