require 'sinatra'
require 'sequel'
require 'pg'

#var SERVER_ADDRESS = 'postgres://wzsaizbidqbckt:a39a4293ca3895f91742f736e24fa9f5d57ed99eee4521da818fed50f3f9c066@ec2-50-17-207-16.compute-1.amazonaws.com:5432/d6lak3olpllv2t'
SERVER_ADDRESS = '127.0.0.1'
PORT = '5432'
DBNAME = 'd6lak3olpllv2t'
USER = 'wzsaizbidqbckt'
PASS = 'a39a4293ca3895f91742f736e24fa9f5d57ed99eee4521da818fed50f3f9c066'

DB = Sequel.connect('postgres://' + USER + ':' + PASS + '@' + SERVER_ADDRESS + ':' + PORT + '/' + DBNAME)

def get_question(id)
  questions = DB[:questions]
  questions[:id => id]
end

def add_question(id,question)
  questions = DB[:questions]
  questions.insert(:id => id, :question => question)
end

get '/' do
  'Hello world!'
  add_question(1234,"test question")
end

