Factory.define(:document) do |d|
  d.name 'Document'
  d.file_uid 'document.pdf'
  d.association :member, :factory => :member
  d.after_build do |document|
    document.file.stubs(:size).returns 100.kilobytes
    document.stubs(:save_attachments).returns true
  end
end
