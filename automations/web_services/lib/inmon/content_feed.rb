class ContentFeed
  def self.fetch_content(caller_id, parent_id, child_id, title_id, content_type)
    LFCommon.soap_call(
      LFWSDL::CONST_CONTENT_FEED,
      :fetch_content,
      "<caller-id>#{caller_id}</caller-id>
      <parent-id>#{parent_id}</parent-id>
      <child-id>#{child_id}</child-id>
      <title-id>#{title_id}</title-id>
      <content-type>#{content_type}</content-type>"
    )
  end
end
