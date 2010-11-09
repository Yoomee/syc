Factory.define(:video) do |v|
  v.association :member, :factory => :member
  v.url "http://www.vimeo.com/123"
end