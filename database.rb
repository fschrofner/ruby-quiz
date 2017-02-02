require 'sequel'
require 'pg'

#Sequel::Database.extension :pg_array

#var SERVER_ADDRESS = 'postgres://wzsaizbidqbckt:a39a4293ca3895f91742f736e24fa9f5d57ed99eee4521da818fed50f3f9c066@ec2-50-17-207-16.compute-1.amazonaws.com:5432/d6lak3olpllv2t'
SERVER_ADDRESS = '127.0.0.1'
PORT = '5432'
DBNAME = 'd6lak3olpllv2t'
USER = 'wzsaizbidqbckt'
PASS = 'a39a4293ca3895f91742f736e24fa9f5d57ed99eee4521da818fed50f3f9c066'

DB = Sequel.connect('postgres://' + USER + ':' + PASS + '@' + SERVER_ADDRESS + ':' + PORT + '/' + DBNAME)
Sequel.extension 'pg_array'
Sequel.extension 'pg_array_ops'

def get_question(id)
  questions = DB[:questions]
  questions[:id => id]
end

def add_question(question_json)
	id = Time.now.to_i + rand(1..999)
	question = convert_to_question(id, question_json)
	save_to_database(question)
end

def convert_to_question(id, json)
	puts('text: ' + json['text'].to_s)

	question = Question.new
	question.id = id
	question.text = json['text'].to_s

	answer_array = Array.new

	json['answers'].each do |e|
		answer = Answer.new
		answer.id = e['id'].to_i
		answer.text = e['text'].to_s
		answer.correct = e['correct'] == 'true' ? true : false

		answer_array.push(answer)
	end

	question.answers = answer_array
	question
end

def save_to_database(question)
	questions = DB[:questions]
	puts question.answers.length.to_s
  questions.insert(:id => question.id, :text => question.text, :answers => Sequel.pg_array(question.answers.map{|x| create_answer_db_object(x)}))
end

def create_answer_db_object(answer)
	{:id => answer.id, :text => answer.text, :correct => answer.correct}
end


class Question
	attr_accessor :id
	attr_accessor :text
	attr_accessor :answers
end

class Answer < Sequel::Model
	attr_accessor :id
	attr_accessor :text
	attr_accessor :correct
end
