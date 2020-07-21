Feature: Latest FX rates endpoint - positive scenarios

  @latest-rates @positive-scenario @symbols
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

  @latest-rates @positive-scenario @base
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

  @latest-rates @positive-scenario @base @symbols
  Scenario Outline: I hit latest FX rates endpoint of Rates API with valid base and symbols parameters
    When I set endpoint to latest
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And numerical values of exchange rate are returned for "<rates>"
    And date "<date>" is returned

    Examples:
      | baseCurrencyInParameter | symbols           | statusCode | baseCurrencyInResponse | rates                                    | date                                   |
      | EUR                     | GBP               | 200        | EUR                    | GBP                                      | (current date or previous working day) |
      | SEK                     | GBP,CZK,NOK       | 200        | SEK                    | GBP,CZK,NOK                              | (current date or previous working day) |
      | DKK                     | (empty parameter) | 200        | DKK                    | (all currencies including base currency) | (current date or previous working day) |
      | (empty parameter)       | HUF               | 200        | EUR                    | HUF                                      | (current date or previous working day) |
      | (empty parameter)       | GBP,CHF,HKD       | 200        | EUR                    | GBP,CHF,HKD                              | (current date or previous working day) |