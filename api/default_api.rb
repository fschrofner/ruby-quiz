require 'json'
require './database'

MyApp.add_route('POST', '/questions/{id}/answer', {
  "resourcePath" => "/Default",
  "summary" => "Answer a question",
  "nickname" => "id_answer_post", 
  "responseClass" => "inline_response_200", 
  "endpoint" => "/{id}/answer", 
  "notes" => "description",
  "parameters" => [
    {
      "name" => "id",
      "description" => "The id of the question",
      "dataType" => "int",
      "paramType" => "path",
    },
    {
      "name" => "body",
      "description" => "The answered question",
      "dataType" => "Question",
      "paramType" => "body",
    }
    ]}) do
  cross_origin
  # the guts live here

  {"message" => "yes, it worked"}.to_json
end


MyApp.add_route('DELETE', '/questions/{id}', {
  "resourcePath" => "/Default",
  "summary" => "Delete a question",
  "nickname" => "id_delete", 
  "responseClass" => "void", 
  "endpoint" => "/{id}", 
  "notes" => "description",
  "parameters" => [
    {
      "name" => "id",
      "description" => "The id of the question",
      "dataType" => "int",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  # the guts live here

  {"message" => "yes, it worked"}.to_json
end


MyApp.add_route('GET', '/questions/{id}', {
  "resourcePath" => "/Default",
  "summary" => "Get a question",
  "nickname" => "id_get", 
  "responseClass" => "Question", 
  "endpoint" => "/{id}", 
  "notes" => "description",
  "parameters" => [
    {
      "name" => "id",
      "description" => "The id of the question",
      "dataType" => "int",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  # the guts live here

  #{"message" => "yes, it worked"}.to_json
	helloId = params[:id].to_s
	{"message" => "Hello #{helloId}"}.to_json
end


MyApp.add_route('PUT', '/questions/{id}', {
  "resourcePath" => "/Default",
  "summary" => "Update a question",
  "nickname" => "id_put", 
  "responseClass" => "Question", 
  "endpoint" => "/{id}", 
  "notes" => "description",
  "parameters" => [
    {
      "name" => "id",
      "description" => "The id of the question",
      "dataType" => "int",
      "paramType" => "path",
    },
    {
      "name" => "body",
      "description" => "The updated question",
      "dataType" => "Question",
      "paramType" => "body",
    }
    ]}) do
  cross_origin
  # the guts live here

  {"message" => "yes, it worked"}.to_json
end


MyApp.add_route('GET', '/questions/random', {
  "resourcePath" => "/Default",
  "summary" => "Get a random question",
  "nickname" => "random_get", 
  "responseClass" => "Question", 
  "endpoint" => "/random", 
  "notes" => "description",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here

  {"message" => "yes, it worked"}.to_json
end


MyApp.add_route('POST', '/questions/', {
  "resourcePath" => "/Default",
  "summary" => "Post new question",
  "nickname" => "root_post", 
  "responseClass" => "Question", 
  "endpoint" => "/", 
  "notes" => "description",
  "parameters" => [
    {
      "name" => "body",
      "description" => "The question JSON you want to post",
      "dataType" => "Question",
      "paramType" => "body",
    }
    ]}) do
  cross_origin
  # the guts live here

	data = JSON.parse(request.body.read)

	add_question(data)

  {"message" => "yes, it worked"}.to_json
end

