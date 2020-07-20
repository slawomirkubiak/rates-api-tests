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

  @latest @positive-tests @base @symbols
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

  @latest @negative-tests @symbols
  Scenario Outline: I hit latest FX rates endpoint of Rates API with invalid symbol parameter
    When I set endpoint to latest
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | symbols         | statusCode | errorMessage                                                                           |
      | EUR             | 400        | Symbols 'EUR' are invalid for date (current date or previous working day).             |
      | HSB             | 400        | Symbols 'HSB' are invalid for date (current date or previous working day).             |
      | USD,ABC         | 400        | Symbols 'USD,ABC' are invalid for date (current date or previous working day).         |
      | HSB,ABC,CMB,SOC | 400        | Symbols 'HSB,ABC,CMB,SOC' are invalid for date (current date or previous working day). |

  @latest @negative-tests @base
  Scenario Outline: I hit latest FX rates endpoint of Rates API with invalid base parameter
    When I set endpoint to latest
    And I set base parameter to "<baseCurrencyInParameter>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | baseCurrencyInParameter | statusCode | errorMessage                     |
      | AGH                     | 400        | Base 'AGH' is not supported.     |
      | GBP,USD                 | 400        | Base 'GBP,USD' is not supported. |
      | GBP,AGH                 | 400        | Base 'GBP,AGH' is not supported. |

  @latest @negative-tests @base @symbols
  Scenario Outline: I hit latest FX rates endpoint of Rates API with invalid base or symbols parameter
    When I set endpoint to latest
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | baseCurrencyInParameter | symbols           | statusCode | errorMessage                                                                       |
      | AGH                     | GBP               | 400        | Base 'AGH' is not supported.                                                       |
      | JPY,AGH                 | GBP,CZK,NOK       | 400        | Base 'JPY,AGH' is not supported.                                                   |
      | ISK                     | JSW               | 400        | Symbols 'JSW' are invalid for date (current date or previous working day).         |
      | SGD                     | KGH,GBP,INR       | 400        | Symbols 'KGH,GBP,INR' are invalid for date (current date or previous working day). |
      | CDD                     | (empty parameter) | 400        | Base 'CDD' is not supported.                                                       |
      | RUB,CNY,ABC             | (empty parameter) | 400        | Base 'RUB,CNY,ABC' is not supported.                                               |
      | (empty parameter)       | CMB               | 400        | Symbols 'CMB' are invalid for date (current date or previous working day).         |
      | (empty parameter)       | EUR,GBP,MSI       | 400        | Symbols 'EUR,GBP,MSI' are invalid for date (current date or previous working day). |

  @latest @negative-tests @base @symbols
  Scenario Outline: I hit latest FX rates endpoint of Rates API with invalid base and symbols parameters
    When I set endpoint to latest
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | baseCurrencyInParameter | symbols     | statusCode | errorMessage                         |
      | CRT                     | LCD         | 400        | Base 'CRT' is not supported.         |
      | CRT                     | IPS,MVA,PVA | 400        | Base 'CRT' is not supported.         |
      | CRT,LCD,IPS             | PVA         | 400        | Base 'CRT,LCD,IPS' is not supported. |
      | CRT,LCD,IPS             | LCD,MVA,PVA | 400        | Base 'CRT,LCD,IPS' is not supported. |