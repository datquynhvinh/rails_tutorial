module ApplicationHelper
    # Returns the full title on a per-page basis.
    def full_title(page_title = '')
        base_title = "Sample App"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end

    def page_name(name = '')
        base_title = "Sample App"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end

    def admin_layout?
        request.path.start_with?('/admin')
    end
end
