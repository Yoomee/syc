Factory.define(:member) do |f|
  f.forename 'John'
  f.surname 'Smith'
  f.sequence(:email) {|n| "test#{n}@test.com"}
  f.password 'pa55w0rd'
end

Factory.define(:admin_member, :parent => :member) do |m|
  m.is_admin true
end