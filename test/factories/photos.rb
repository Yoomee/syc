include Mocha::API
Factory.define(:photo) do |p|
  p.image_uid 'test_image'
  p.association :member, :factory => :member
  p.association :photo_album
  p.after_build do |photo|
    image_mock = mock
    photo.stubs(:image).returns image_mock
    image_mock.stubs(:size).returns 100.kilobytes
    image_mock.stubs(:process).returns image_mock
    image_mock.stubs(:mime_type).returns 'image/png'
    image_mock.stubs(:url).returns '/url/to/image.png'
    photo.stubs(:resize_down).returns true
    photo.stubs(:save_attachments).returns true
  end
end
