# Function to validate format of dates
def valid_date_format(date_str)
  # Regular expression to match the format YYYY-MM-DD
  date_format_regex = /\A\d{4}-\d{2}-\d{2}\z/

  # Check if the date string matches the expected format
  return !!(date_str =~ date_format_regex)
end

# Function to validate that end_date goes after start_date
def valid_date_start_end(start_date_str, end_date_str)
  return Date.parse(start_date_str) < Date.parse(end_date_str)
end

# Function to validate that date range of 3 is ok
def valid_date_range(start_date_str, end_date_str)
  return (Date.parse(end_date_str) - Date.parse(start_date_str)).to_i <= 3
end

# Function to validate that start date is today
def valid_start_date_today(start_date_str)
  start_date = Date.parse(start_date_str)
  today = Date.today
  return start_date == today
end

# Function to convert timepoint to DateTime
def timepoint_to_datetime(init, timepoint)
  DateTime.strptime(init, '%Y%m%d%H') + (timepoint / 24.0)
end

# Function to filter dates
def filter_by_dates(start_date_str, end_date_str, list_dates)
  list_filtered = []

  start_date = Date.parse(start_date_str) rescue nil
  end_date = Date.parse(end_date_str) rescue nil

  list_dates.each do |item|
    date = Date.parse(item["date"]) rescue nil
    if date >= start_date && date <= end_date
      list_filtered << item
    end
  end
  return list_filtered
end
