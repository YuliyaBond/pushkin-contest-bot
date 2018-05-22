require 'net/http'
require_relative '../services/pushkin'

class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token  
  FILE_PUSH_POEMS = FilePushkin.new.parse

  def index 
    
  end

  def req
    
  case params[:level].to_i

    when 1
      answer = level_1(params[:question])
    when 2
      answer = level_2(params[:question])[0]
    when 3
      answer = level_3(params[:question])
    when 4
      answer = level_4(params[:question])
    when 5
      answer = level_5(params[:question])
    when 6
      answer = level_6_7(params[:question])
    when 7
      answer = level_6_7(params[:question])
    when 8
      answer = level_8(params[:question])
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
    question = delete_excess(question)
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        line = delete_excess(line)
        return poem[0] if line == question
      end
    end
  end

  def level_2(question)
    parts = question.split('%')
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? parts[0]
          return line.split(' ') - question.split(' ')
        end
      end
    end   
  end

  def level_3(question)
    parts = question.split("\n")
    first_str = parts[0].split('%')
    
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? first_str[0]
          word_1 =  line.split(' ') - parts[0].split(' ')
          index_1 = poem[1].index(line)           
          index_2 =  poem[1][index_1 + 1]
          word_2 = index_2.split(' ') - parts[1].split(' ')
          @last_str = "#{word_1[0]},#{word_2[0]}"
          break
        end       
      end
    end
    return @last_str
  end

  def level_4(question)
    parts = question.split("\n")
    first_str = parts[0].split('%')
    
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? first_str[0]
          word_1 =  line.split(' ') - parts[0].split(' ')
          index_1 = poem[1].index(line)           
          index_2 =  poem[1][index_1 + 1]
          index_3 = poem[1][index_1 + 2]
          word_2 = index_2.split(' ') - parts[1].split(' ')
          word_3 = index_3.split(' ') - parts[2].split(' ')
          @last_str = "#{word_1[0]},#{word_2[0]},#{word_3[0]}"
          break
        end       
      end
    end
    return @last_str
  end

  def level_5(question)
    parts = question.split(' ')
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        if line.include? parts[0]
          word_1 = line.split(' ') - question.split(' ')
          word_2 = question.split(' ') - line.split(' ')
          @str = "#{word_1[0]},#{word_2[0]}"
          break
        end
      end
    end
    return @str
  end

  def level_6_7(question)
    parts = question.split('')
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        letters = delete_excess(line).split('')
        if parts - letters == []
          return line
        end
      end
    end
  end 
  
  def level_8(question)
    parts = question.split('')
    FILE_PUSH_POEMS.each do |poem|
      poem[1].each do |line|
        letters = delete_excess(line).split('')
        tmp = letters - parts
        sum = parts + letters
        last_str = sum.uniq
        last_str.pop
        last_str += tmp
        if last_str - letters == []
          return line 
        end
      end
    end
  end

  def delete_excess(str)
    return str.gsub(/[,?.!:+-=*_@#()^;№'<>~`«»—]/, '')
  end
end
