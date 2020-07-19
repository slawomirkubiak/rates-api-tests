Feature: Invalid URL syntax

  Scenario Outline: I hit Rates API with incorrect endpoint URL
    When I put <urlString> in URL
    Then status code <statusCode> is returned
    And error message <errorMessage> is returned

    Examples:
      | urlString     | statusCode | errorMessage                                               |
      | ""            | 400        | "time data 'api' does not match format '%Y-%m-%d'"         |
      | "2019-Dec-29" | 400        | "time data '2019-Dec-29' does not match format '%Y-%m-%d'" |
      | "sampleDate"  | 400        | "time data 'sampleDate' does not match format '%Y-%m-%d'"  |