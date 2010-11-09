Factory.define(:enquiry) do |e|
  e.association :member, :factory => :member
  e.form_name "Contact"
  e.after_build do |enquiry|
    enquiry.stubs(:valid?).returns true
  end
end