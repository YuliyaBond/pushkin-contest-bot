require 'net/http'
require_relative '../services/pushkin'

class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token  
  PUSHKIN = FilePushkin.new.parse

  def index 
      
  end

  def req
    
  case params[:level].to_i

    when 1
      answer = 1_level(params[:question])
    when 2
      answer = 2_level(params[:question])[0]
    when 3
      answer = 3_level(params[:question])
    when 4
      answer = 4_level(params[:question])
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

  def 1_level(question)
    question = del(question)
    PUSHKIN.each do |poem|
      poem[1].each do |line|
        line = del(line)
        return poem[0] if line == question
      end
    end
  end

  def 2_level(question)
    parts = question.split('%')
    PUSHKIN.each do |poem|
      poem[1].each do |line|
        if line.include? parts[0]
          return line.split(' ') - question.split(' ')
        end
      end
    end   
  end

  def 3_level(question)
    parts = question.split("\n")
    str_1 = parts[0].split('%')
    
    PUSHKIN.each do |poem|
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

  def 4_level(question)
    parts = question.split("\n")
    str_1 = parts[0].split('%')
    
    PUSHKIN.each do |poem|
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
