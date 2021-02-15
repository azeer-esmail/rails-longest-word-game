require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
    session[:letters] = @letters
  end

  def score
    word = params[:score].upcase
    @response = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    letters = session[:letters]
    @letters = letters.dup
    l = letters.length
    if @response['found']
      word.split('').each{ |c| letters.delete_at(letters.index(c)) if letters.include?(c)}
      y = "Congratulations! #{word} is a valid word!"
      n = "sorry but #{word} can't be built out of #{@letters.join(', ')}"
      @res = l - word.length == letters.length ? y : n
    else
      @res = "sorry but #{word} doesn't seem to be a valid Eglish word..."
    end
  end
end
