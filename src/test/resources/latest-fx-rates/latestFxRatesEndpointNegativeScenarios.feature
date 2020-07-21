Feature: Latest FX rates endpoint - negative scenarios

  @latest-rates @negative-scenario @symbols
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

  @latest-rates @negative-scenario @base
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

  @latest-rates @negative-scenario @base @symbols
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

  @latest-rates @negative-scenario @base @symbols
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