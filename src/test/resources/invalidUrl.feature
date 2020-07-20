Feature: Invalid URL syntax

  @invalid-url @negative-tests
  Scenario Outline: I hit Rates API with incorrect endpoint URL
    When I set "<urlString>" in URL
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | urlString   | statusCode | errorMessage                                             |
      | (no string) | 400        | time data 'api' does not match format '%Y-%m-%d'         |
      | 2019-Dec-29 | 400        | time data '2019-Dec-29' does not match format '%Y-%m-%d' |
      | sampleDate  | 400        | time data 'sampleDate' does not match format '%Y-%m-%d'  |