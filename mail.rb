require 'rest-client'

def send_question_too_hard_message(id, right_count, wrong_count)
  if(right_count == nil)
    right_count = 0
  end

  RestClient.post "https://api:key-fea78a3f0186fb58b93c6eb91aaa0301"\
                  "@api.mailgun.net/v3/app8bbd8df84a434676995fa7ab78553919.mailgun.org/messages",
                  :from => "Ruby Quiz Bot <mailgun@app8bbd8df84a434676995fa7ab78553919.mailgun.org>",
                  :to => "flosch+mailgun@posteo.org, dominik.koeltringer@gmail.com",
                  :subject => "Question too hard?",
                  :text => "Your question with the id " + id.to_s + " might be too hard. People answered your question " + wrong_count.to_s + " times incorrectly versus only " + right_count.to_s + " times correctly at the moment."
end
