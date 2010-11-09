Factory.define(:status) do |v|
  v.association :member, :factory => :member
  v.text "This is a status"
end