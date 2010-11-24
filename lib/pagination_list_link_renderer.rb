class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  def html_container(html)
    @search_key = :search
    @params = @template.params[@search_key] || {}
    
    html += "<span>|</span>" + [per_page_link(25), per_page_link(50), per_page_link(200)].join('')
    html += "</div><div style='clear: both; padding-top: 0.5em;'>" + alphabetic_pagination
    html = "<div style='clear: both'>" + html + "</div>"
    tag(:div, html, container_attributes)
  end

  def alphabetic_pagination
    page_links = ('a'..'z').map{|character| alphabetic_page_link(character)}
    
    return page_links.join('')
  end

  def alphabetic_page_link(character)
    if character == @params[:by_character]
      link = "<em>%s</em>" % character.upcase
    else
      link = "<a class='per_page' href='%s'>%s</a>" % [alphabetic_page_href(character), character.upcase]
    end
    
    return link
  end
  
  def alphabetic_page_href(character)
    search_params = @params.merge(:by_character => character)
    params = @template.params.merge(@search_key => search_params)
    
    @template.url_for(params)
  end
  
  def per_page_link(count)
    if count == @template.params[:per_page].to_i
      link = "<em>%s</em>"  % count
    else
      link = "<a class='per_page' href='%s'>%s</a>" % [per_page_href(count), count]
    end
    
    return link
  end

  def per_page_href(count)
    params = @template.params.merge({:per_page => count})
    
    @template.url_for(params)
  end
end
