class CommonMarker::CustomHtmlRenderer < CommonMarker::HtmlRenderer
  def tasklist(node)
    return '' unless tasklist?(node)

    state = if checked?(node)
              'checked="" disabled=""'
            else
              'disabled=""'
            end
    " class=\"task-list-item\"><input type=\"checkbox\" #{state} /"
  end
end
