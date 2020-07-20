Feature: Latest FX rates endpoint

  @latest @positive-tests
  Scenario Outline: I hit latest FX rates endpoint of Rates API with valid symbol parameter
    When I set endpoint to latest
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrency>" is returned
    And numerical values of exchange rate are returned for "<rates>"
    And date "<date>" is returned

    Examples:
      | symbols               | statusCode | baseCurrency | rates               | date                                   |
      | USD                   | 200        | EUR          | USD                 | (current date or previous working day) |
      | USD,GBP,CHF,CZK,SEK   | 200        | EUR          | USD,GBP,CHF,CZK,SEK | (current date or previous working day) |
      | (no symbol parameter) | 200        | EUR          | (all currencies)    | (current date or previous working day) |
      | (empty parameter)     | 200        | EUR          | (all currencies)    | (current date or previous working day) |