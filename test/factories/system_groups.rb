Factory.define :system_group do |m|
  m.name { Factory.next(:system_group_name) }
end

Factory.sequence :system_group_name do |n|
  "Group #{n}"
end