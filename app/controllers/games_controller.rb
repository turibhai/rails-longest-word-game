# require "json"
# require "open-uri"

# class GamesController < ApplicationController

#     def new
#         letters = ('a'..'z').to_a
#         @letters = letters.sample(10)
#     end

#     def score
#         @users_input = params[:letter]
#         @sample = params[:@letters].split

#         valid_input = @users_input.chars.all? do |letter|
#             @users_input.split.count(letter) <= @sample.count(letter)
#         end

        

#         url = "https://dictionary.lewagon.com/#{URI.encode_www_form_component(@users_input.strip)}"
#         result_serialized = URI.parse(url).read
#         result_hash = JSON.parse(result_serialized)
    
#         result = valid_input == result_hash["found"] ? "you won" : "try again"
       
                
#     end

# end
require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    letters = ('a'..'z').to_a
    @letters = letters.sample(10).join(" ") # Join letters into a string for frontend
  end

  def score
    @users_input = params[:letter].strip.downcase # Ensure no extra spaces or case issues
    @sample = params[:@letters].split # Convert the string back into an array of letters

    # Validate input against available letters
    valid_input = @users_input.chars.all? do |letter|
      @users_input.count(letter) <= @sample.count(letter)
    end

    # Fetch word validation from external dictionary API
    url = "https://dictionary.lewagon.com/:#{URI.encode_www_form_component(@users_input.strip)}" # Properly encode input
    result_serialized = URI.open(url).read
    result_hash = JSON.parse(result_serialized)

    # Determine result and feedback
    @result_message = if valid_input && result_hash["found"]
                        "Congratulations! You formed a valid word!"
                      elsif !valid_input
                        "Your word uses invalid letters! Try again."
                      elsif !result_hash["found"]
                        "The word is not valid in the dictionary! Try again."
                      end
  end
end
