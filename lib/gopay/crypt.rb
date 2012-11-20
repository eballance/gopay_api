require "digest/sha1"
require "openssl"

module GoPay

	module Crypt
		extend self

		def sha1(string)
			Digest::SHA1.hexdigest(string)
		end

		def encrypt(string)
			string = sha1(string)
			des = OpenSSL::Cipher::Cipher.new("des-ede3")
			des.encrypt
			des.key = GoPay.configuration.secure_key
			result = des.update(string)
			result.unpack("H*")[0]
		end

		def decrypt(encrypted_data, padding_off = false)
			encrypted_data = bin2hex(encrypted_data)
			des = OpenSSL::Cipher.new("des-ede3")
			des.decrypt
			des.padding = 0 if padding_off
			des.key = GoPay.configuration.secure_key
			result = ""
			result << des.update(encrypted_data)
			result
		end

		def bin2hex(bin)
			bin.scan(/../).map { |tuple| tuple.hex }.pack 'c*'
		end

	end

end
