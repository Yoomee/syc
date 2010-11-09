Factory.define(:page) do |p|
  p.title 'A page'
  p.text Lorem::Base.new('paragraphs', 5).output
  p.association :section
end

Factory.define(:unpublished_page, :parent => :page) do |p|
  p.publish_on 1.day.from_now
end

Factory.define(:expired_page, :parent => :page) do |p|
  p.expires_on 1.day.ago
end

Factory.define(:page_with_photo, :parent => :page) do |p|
  p.association :photo
end

Factory.define(:page_without_photo, :parent => :page) do |p|
end