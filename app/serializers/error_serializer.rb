class ErrorSerializer
  def self.format_errors(messages)
    {
      message: 'Your query could not be completed',
      errors: messages
    }
  end

  def self.format_invalid_search_response
    { 
      message: "your query could not be completed", 
      errors: ["invalid search params"] 
    }
  end

  def self.format_error(exception)
    {
      message: "your request could not be completed",
      errors: [
        {
          error: exception.message
        }
      ]
    }
  end
end