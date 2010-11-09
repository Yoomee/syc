class String

  def indefinitize
    (%w{a e i o u}.include?(self.first.downcase) ? "an" : "a") + self
  end

  # Like the Rails _truncate_ helper but doesn't break HTML tags or entities.
  def truncate_html(max_length = 30, ellipsis = "...")
    doc = Hpricot(self)
    ellipsis_length = Hpricot(ellipsis).inner_text.mb_chars.length
    content_length = doc.inner_text.mb_chars.length
    actual_length = max_length - ellipsis_length
    content_length > max_length ? doc.truncate(actual_length).inner_html : self
  end

  def urlify
    strip.gsub(/[^a-zA-Z0-9\s\-]/,"").gsub(/\s+/,"-")
  end

  # Truncate at word boundary thus avoiding chopping words 
  def word_truncate(length = 30, truncate_string = "...")
    return if self.nil?
    l = length - truncate_string.length
    ret = self.length > length ? self[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : self
    ret = ret.gsub(/&#39;/,"'")
  end

end

module HpricotTruncator
  
  module IgnoredTag
    def truncate(max_length)
      self
    end
  end

  module NodeWithChildren
    def truncate(max_length, ellipsis = '...')
      return self if inner_text.mb_chars.length <= max_length
      truncated_node = self.dup
      truncated_node.name = self.name if self.respond_to?(:name)
      truncated_node.children = []
      each_child do |node|
        remaining_length = max_length - truncated_node.inner_text.mb_chars.length
        break if remaining_length < 1
        truncated_node.children << node.truncate(remaining_length, ellipsis)
      end
      truncated_node
    end
  end

  module TextNode
    def truncate(max_length, ellipsis = '...')
      # We're using String#scan because Hpricot doesn't distinguish entities.
      if content.mb_chars.length > max_length
        Hpricot::Text.new(content.scan(/&#?[^\W_]+;|./).first(max_length).join + ellipsis)
      else
        Hpricot::Text.new(content)
      end
    end
  end

end

Hpricot::BogusETag.send(:include, HpricotTruncator::IgnoredTag)
Hpricot::Comment.send(:include,   HpricotTruncator::IgnoredTag)
Hpricot::Doc.send(:include,       HpricotTruncator::NodeWithChildren)
Hpricot::Elem.send(:include,      HpricotTruncator::NodeWithChildren)
Hpricot::Text.send(:include,      HpricotTruncator::TextNode)
