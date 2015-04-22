module ApplicationHelper

  def date_in_words(date)
    date.strftime("#{date.day.ordinalize} %b %y") if date
  end

  def duration_in_words(duration)
    ChronicDuration.output(duration.abs, format: :chrono) if duration.is_a?(Fixnum)
  end

  def personal_best_time_difference(result)
    pb = result.find_personal_best

    if pb
      difference = pb.duration - result.duration

      if difference == 0
        icon('check', "Personal Best")
      else
        "#{duration_in_words(difference)} #{icon('arrow-circle-o-down')} than Personal Best".html_safe
      end
    end

  end
end
