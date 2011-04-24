module ApplicationHelper
  # Return a title on a per-page basis.
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    #link_to title, {:sort => column, :direction => direction}, {:class => css_class}
        # change where :sort link is created to include the search parameter
        # as a persistent method;  see below --
     link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
     # params.merge  carries the parameters over from current page to linked page
  end
end
