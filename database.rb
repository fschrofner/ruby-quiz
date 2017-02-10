require 'redis'

Questions = Redis.new

def get_question(id)
  Questions.hget("questions", id)
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
  Questions.hset("questions", question.id, question.create_json)
end

def update_in_database(question)
  save_to_database(question)
end

def question_exists(id)
  Questions.hexists("questions", id)
end

def create_answer_object(answer)
	{"id" => answer.id, "text" => answer.text, "correct" => answer.correct}
end

def create_censored_answer_object(answer)
	{"id" => answer.id, "text" => answer.text}
end

def get_from_database(id)
	question_db = Questions.hget("questions", id)
  if(question_db != nil)
    question = Question.parse_json(JSON.parse(question_db))
	  question.create_censored_json()
  end
end

def get_random_from_database()
	size = Questions.hlen("questions")

	if size > 0
		index = rand(0..size-1)
    id = Questions.hkeys("questions")[index]
    get_from_database(id)
	end
end

def database_empty?()
	Questions.hlen("questions") < 1
end

def delete_from_database(id)
	Questions.hdel("questions", id)
end

def answer_question(id, question)
	question_db = JSON.parse(Questions.hget("questions", id))

	question_db["answers"].each{|answer|
		
		matching_answer = question["answers"].select{|y|
			y["id"] == answer["id"]
		}

		if matching_answer.length < 1 || matching_answer[0]["correct"] != answer["correct"]
      puts 'increased wrong count'
      Questions.hincrby("wrong_count", id, 1)
			return {"result" => false}.to_json
		end
	}
  puts 'increased right count'
  Questions.hincrby("right_count", id, 1)
	{"result" => true}.to_json
end

def get_right_wrong_ratio(id)
  right = get_right_answers(id)
  wrong = get_wrong_answers(id)
  if(wrong.to_i <= 0)
    wrong = 1
  end

  if(right.to_i <= 0)
    right = 1
  end

  right.to_f / wrong.to_f
end

def get_total_answers(id)
  right = get_right_answers(id)
  wrong = get_wrong_answers(id)
  right.to_i + wrong.to_i
end

def get_right_answers(id)
  Questions.hget("right_count", id)
end

def get_wrong_answers(id)
  Questions.hget("wrong_count", id)
end

def get_email_notification_sent(id)
  Questions.sismember("sent_notifications", id)
end

def set_email_notification_sent(id)
  Questions.sadd("sent_notifications", id)
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
