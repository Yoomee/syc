Factory.define(:mail) do |m|
  m.association :recipient, :factory => :member
  m.subject 'An email'
  m.from "sender <sender@test.com>"
  m.html_body "<p>The html body</p>"
end

Factory.define(:sent_mail, :parent => :mail) do |m|
  m.status 'sent'
end