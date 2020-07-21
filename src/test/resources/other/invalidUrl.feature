Feature: Invalid URL syntax

  @invalid-url @negative-scenario
  Scenario Outline: I hit Rates API with incorrect endpoint URL
    When I set "<urlString>" in URL
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | urlString         | statusCode | errorMessage                                                   |
      | (no string)       | 400        | time data 'api' does not match format '%Y-%m-%d'               |
      | 2019-12-          | 400        | time data '2019-12-' does not match format '%Y-%m-%d'          |
      | 2019-Dec-29       | 400        | time data '2019-Dec-29' does not match format '%Y-%m-%d'       |
      | 29-12-2019        | 400        | time data '29-12-2019' does not match format '%Y-%m-%d'        |
      | 1stOfDecember2001 | 400        | time data '1stOfDecember2001' does not match format '%Y-%m-%d' |