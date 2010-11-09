module MembersHelper

  PERSON_TEXT_REPLACEMENTS = [["are", "is"], ["have", "has"], ["haven't", "hasn't"]]
  
  def forename_or_me(member)
    @logged_in_member==member ? 'me' : member.forename
  end
  
  def forename_or_you(member, text='')
    if @logged_in_member==member
      "you " + first_personalize_text(text)
    else
      "#{member.forename} " + third_personalize_text(text)
    end
  end
  
  def forename_or_your(member)
    @logged_in_member==member ? "your" : "#{member.forename}'s"    
  end
  
  def full_name_or_your(member)
    @logged_in_member==member ? "your" : "#{member.full_name}'s"    
  end
  
  def first_personalize_text(text)
    return '' if text.blank?    
    PERSON_TEXT_REPLACEMENTS.inject(out=text) do |out, rep|
      out.gsub(rep[1], rep[0])
    end
  end
  
  def third_personalize_text(text)
    return '' if text.blank?
    PERSON_TEXT_REPLACEMENTS.inject(out=text) do |out, rep|
      out.gsub(rep[0], rep[1])
    end
  end
   
end