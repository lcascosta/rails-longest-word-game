require 'open-uri'
require 'json'

class GameplayController < ApplicationController
  def game
    @grid = generate_grid(9)
  end

  def score
    end_time = Time.now
    start_time = Time.at(params[:start_time].to_i)
    grid = params[:grid].split('')
    @word = params[:word]
    @score = run_game(@word, grid, start_time, end_time)
  end

  def generate_grid(grid_size)
    alphabet = ("A".."Z").to_a
    grid = []
    grid_size.times { grid << alphabet.sample }
    grid
  end

  WORDS = File.read('/usr/share/dict/words').upcase.split("\n")

  def run_game(attempt, grid, start_time, end_time)
    if !validate_letters(attempt, grid)
      { time: end_time - start_time, score: 0, message: "Not in the grid!" }
    elsif !WORDS.include? attempt.upcase
      { time: end_time - start_time, score: 0, message: "Not an english word!" }
    else
      { translation: translator(attempt)["outputs"][0]["output"],
        time: (end_time - start_time).to_i,
        score: (attempt.size * 50) - (end_time - start_time).to_i,
        message: "Well done!" }
    end
  end

  def translator(w)
    key = "32e295f1-4ba6-4862-ad98-0156028a8d5"
    strio = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{key}b&input=#{w}")
    JSON.parse(strio.read)
  end

  def validate_letters(attempt, grid)
    attempt_a = attempt.upcase.split("")
    attempt_h = Hash.new(0)
    attempt_a.each { |a| attempt_h[a] += 1 }
    grid_h = Hash.new(0)
    grid.each { |b| grid_h[b] += 1 }
    attempt_h.all? { |k, _v| attempt_h[k] <= grid_h[k] }
  end
end
