Feature: Latest FX rates endpoint

  @latest @positive-tests @symbols
  Scenario Outline: I hit latest FX rates endpoint of Rates API with valid symbol parameter
    When I set endpoint to latest
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And numerical values of exchange rate are returned for "<rates>"
    And date "<date>" is returned

    Examples:
      | symbols               | statusCode | baseCurrencyInResponse | rates               | date                                   |
      | USD                   | 200        | EUR                    | USD                 | (current date or previous working day) |
      | USD,GBP,CHF,CZK,SEK   | 200        | EUR                    | USD,GBP,CHF,CZK,SEK | (current date or previous working day) |
      | (no symbol parameter) | 200        | EUR                    | (all currencies)    | (current date or previous working day) |
      | (empty parameter)     | 200        | EUR                    | (all currencies)    | (current date or previous working day) |

  @latest @positive-tests @base
  Scenario Outline: I hit latest FX rates endpoint of Rates API with valid base parameter
    When I set endpoint to latest
    And I set base parameter to "<baseCurrencyInParameter>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And exchange rate for "<baseCurrencyInResponse>" currency equals "<rateForBaseCurrency>"
    And numerical values of exchange rate are returned for "<rates>"
    And date "<date>" is returned

    Examples:
      | baseCurrencyInParameter | statusCode | baseCurrencyInResponse | rates                                    | rateForBaseCurrency | date                                   |
      | USD                     | 200        | USD                    | (all currencies including base currency) | 1.0                 | (current date or previous working day) |
      | GBP                     | 200        | GBP                    | (all currencies including base currency) | 1.0                 | (current date or previous working day) |
      | (empty parameter)       | 200        | EUR                    | (all currencies)                         | (not present)       | (current date or previous working day) |


  @latest @negative-tests @symbols
  Scenario Outline: I hit latest FX rates endpoint of Rates API with invalid symbol parameter
    When I set endpoint to latest
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | symbols         | statusCode | errorMessage                                                                           |
      | HSB             | 400        | Symbols 'HSB' are invalid for date (current date or previous working day).             |
      | USD,ABC         | 400        | Symbols 'USD,ABC' are invalid for date (current date or previous working day).         |
      | HSB,ABC,CMB,SOC | 400        | Symbols 'HSB,ABC,CMB,SOC' are invalid for date (current date or previous working day). |