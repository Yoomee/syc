class TramlinesSemanticFormBuilder < Formtastic::SemanticFormBuilder

  def ck_text_input(method, options)
    basic_input_helper(:cktext_area, :text, method, options)
  end
  
end