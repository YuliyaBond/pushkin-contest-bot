require 'net/http'
require_relative '../services/pushkin'

class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token  
  FILE_POEMS = FilePushkin.new.parse

  def index      
  end

  def req
    
    case :level
    when 1
      answer = level_1(params[:question])
    when 2
      answer = level_2(params[:question])[0]
    when 3
      answer = level_3(params[:question])
    when 4
      answer = level_4(params[:question])
    end

    uri = URI("http://pushkin.rubyroidlabs.com/quiz")
    parameters = {
      answer: answer,
      token: "89e4fd81545ad22932910f14583d1ef4",
      task_id: params[:id]
    }
    Net::HTTP.post_form(uri, parameters)
  end

  private

  def level_1(question)
    question = del(question)
    FILE_POEMS.each do |poem|
      poem[1].each do |line|
        line = del(line)
        return poem[0] if line == question
      end
    end
  end

  def level_2(question)
    parts = question.split('%')
    FILE_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? parts[0]
          return line.split(' ') - question.split(' ')
        end
      end
    end   
  end

  def level_3(question)
    parts = question.split("\n")
    str_1 = parts[0].split('%')
    
    FILE_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? str_1[0]
          word_1 =  line.split(' ') - parts[0].split(' ')
          ind_1 = poem[1].index(line)           
          ind_2 =  poem[1][ind_1 + 1]
          word_2 = ind_2.split(' ') - parts[1].split(' ')
          @str = "#{word_1[0]},#{word_2[0]}"
          break
        end       
      end
    end
    return @str
  end

  def level_4(question)
    parts = question.split("\n")
    str_1 = parts[0].split('%')
    
    FILE_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? str_1[0]
          word_1 =  line.split(' ') - parts[0].split(' ')
          ind_1 = poem[1].index(line)           
          ind_2 =  poem[1][ind_1 + 1]
          ind_3 = poem[1][ind_1 + 2]
          word_2 = ind_2.split(' ') - parts[1].split(' ')
          word_3 = ind_3.split(' ') - parts[2].split(' ')
          @str = "#{word_1[0]},#{word_2[0]},#{word_3[0]}"
          break
        end       
      end
    end
    return @str
  end

  
  
  def del(str)
    return str.gsub(/[,?.!:+-=*_@#()^;№'<>~`«»—]/, '')
  end
end