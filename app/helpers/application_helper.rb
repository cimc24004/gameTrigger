module ApplicationHelper
    def game_event_body_strip(body)
        return sanitize body, tags: %w(hr i h2 p img strong u ol li ul h1 h3 h4 h5 h6 style span b em a table tr td iframe video a tbody br),attributes: %w(href style class)
    end
end
