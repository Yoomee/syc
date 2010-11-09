Factory.define(:photo) do |p|
  p.image_uid 'test_image'
  p.association :member, :factory => :member
  p.association :photo_album
  p.after_build do |photo|
    photo.image.stubs(:size).returns 100.kilobytes
    photo.stubs(:resize_down).returns true
    photo.stubs(:save_attachments).returns true
  end
end
