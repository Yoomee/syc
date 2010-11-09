Factory.define(:link) do |p|
  p.association :member, :factory => :member
  p.url "http://www.yoomee.com"
  p.image_uid "defaults/link_image"
end