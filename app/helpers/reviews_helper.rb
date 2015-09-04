module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    remainder = (5 - rating)
    '★' * rating.round + '☆' * remainder
  end

  def time_created(time)
    time_difference = ((Time.now - time) / 3600).round
    "Created #{pluralize(time_difference, 'hour')} ago"
  end
end
