Factory.define(:link) do |p|
  p.association :member, :factory => :member
  p.url "http://www.yoomee.com"
end