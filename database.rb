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
Sequel::Model.db.extension :pg_array

Questions = DB[:questions]

def get_question(id)
  Questions[:id => id]
end

def add_question(question_json)
	id = Time.now.to_i + rand(1..999)
	question = convert_to_question(id, question_json)
	save_to_database(question)
	question.create_json()
end

def update_question(id, question_json)
	question = convert_to_question(id, question_json)
	update_in_database(question)
	question.create_json()
end

def convert_to_question(id, json)
	puts('text: ' + json['text'].to_s)

	question = Question.new
	question.id = id
	question.text = json['text'].to_s

	answer_array = Array.new

	json['answers'].each do |e|
		answer = Answer.new(e['id'], e['text'], e['correct'])
		answer_array.push(answer)
	end

	question.answers = answer_array
	question
end

def save_to_database(question)
  Questions.insert(:id => question.id, :text => question.text, :answers => Sequel.pg_array(question.answers.map{|x| create_answer_object(x).to_json}))
end

def update_in_database(question)
  Questions.where(:id => question.id).update(:text => question.text, :answers => Sequel.pg_array(question.answers.map{|x| create_answer_object(x).to_json}))
end

def question_exists(id)
	if Questions[:id => id] != nil
		true
	else
		false
	end
end

def create_answer_object(answer)
	{"id" => answer.id, "text" => answer.text, "correct" => answer.correct}
end

def create_censored_answer_object(answer)
	{"id" => answer.id, "text" => answer.text}
end

def get_from_database(id)
	question_db = Questions[:id => id]
	question = Question.new
	question.id = question_db[:id]
	question.text = question_db[:text]
	question.answers = question_db[:answers].map{|x|
		answer = JSON.parse(x)
		Answer.new(answer["id"], answer["text"], answer["correct"])
	}

	question.create_censored_json()
end

def get_random_from_database()
	size = Questions.all.length
	
	if size > 0
		random_number = rand(0..size-1)
		id = Questions.all[random_number][:id]
	  get_from_database(id)
	end
end

def database_empty?()
	Questions.all.length < 1
end

def delete_from_database(id)
	Questions.where(:id => id).delete
end

def answer_question(id, question)
	question_db = Questions[:id => id]
	question_db[:answers].each{|x|
		answer = JSON.parse(x)
		
		matching_answer = question["answers"].select{|y|
			y["id"] == answer["id"]
		}

		if matching_answer.length < 1 || matching_answer[0]["correct"] != answer["correct"]
			return {"result" => false}.to_json
		end
	}
	{"result" => true}.to_json
	
end


class Question
	attr_accessor :id
	attr_accessor :text
	attr_accessor :answers

	def create_json()
		{"id" => id, "text" => text, "answers" => answers.map{|x| create_answer_object(x)}}.to_json
	end

	def create_censored_json()
		{"id" => id, "text" => text, "answers" => answers.map{|x| create_censored_answer_object(x)}}.to_json
	end
end

class Answer
	attr_accessor :id
	attr_accessor :text
	attr_accessor :correct

	def initialize(id, text, correct)
		@id = id
		@text = text
		@correct = correct
	end
end
