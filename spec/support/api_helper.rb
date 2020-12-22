module ActionDispatch
  class TestResponse
    def parsed
      @parsed ||= JSON.parse(body, symbolize_names: true)
    end
  end
end
