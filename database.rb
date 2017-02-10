require 'redis'

Questions = Redis.new

def get_question(id)
  Questions.get(id)
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
  Questions.set(question.id, question.create_json)
end

def update_in_database(question)
  save_to_database(question)
end

def question_exists(id)
  Questions.exists(id)
end

def create_answer_object(answer)
	{"id" => answer.id, "text" => answer.text, "correct" => answer.correct}
end

def create_censored_answer_object(answer)
	{"id" => answer.id, "text" => answer.text}
end

def get_from_database(id)
	question_db = Questions.get(id)
	question = Question.parse_json(JSON.parse(question_db))
	question.create_censored_json()
end

def get_random_from_database()
	size = Questions.dbsize
	
	if size > 0
		id = Questions.randomkey
	  get_from_database(id)
	end
end

def database_empty?()
	Questions.dbsize < 1
end

def delete_from_database(id)
	Questions.del(id)
end

def answer_question(id, question)
	question_db = JSON.parse(Questions.get(id))

	question_db["answers"].each{|answer|
		
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

  def self.parse_json(json)
    question = Question.new
    question.id = json["id"]
	  question.text = json["text"]
	  question.answers = json["answers"].map{|answer|
		  Answer.new(answer["id"], answer["text"], answer["correct"])
	  }
    question
  end

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
