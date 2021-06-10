module GameEventsHelper
    def event_date_show(event_date)
        if event_date.present?
            return event_date
        else
            return "不明"
        end
    end
end
