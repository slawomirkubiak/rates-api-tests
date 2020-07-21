Feature: Past FX rates endpoint - negative scenarios

  @past-rates @negative-scenario @date
  Scenario Outline: I hit past FX rates endpoint of Rates API with invalid date and without any parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | date       | statusCode | errorMessage                                      |
      | 1999-01-03 | 400        | There is no data for dates older then 1999-01-04. |
      | 1969-12-31 | 400        | There is no data for dates older then 1999-01-04. |
      | 2001-02-29 | 400        | day is out of range for month                     |
      | 2011-06-31 | 400        | day is out of range for month                     |

  @past-rates @negative-scenario @date @base @symbols
  Scenario Outline: I hit past FX rates endpoint of Rates API with invalid date, valid base and symbols parameters
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | date              | baseCurrencyInParameter | symbols           | statusCode | errorMessage                                      |
      | 2001-04-31        | EUR                     | GBP               | 400        | day is out of range for month                     |
      | 1930-01-01        | SEK                     | GBP,CZK,NOK       | 400        | There is no data for dates older then 1999-01-04. |
      | 2001-02-29        | PLN                     | (empty parameter) | 400        | day is out of range for month                     |
      | 1965-05-05        | (empty parameter)       | HUF               | 400        | There is no data for dates older then 1999-01-04. |
      | (empty parameter) | (empty parameter)       | GBP,CHF,HKD       | 400        | time data 'api' does not match format '%Y-%m-%d'  |

  @past-rates @negative-scenario @date @symbols
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date, invalid symbol parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | date       | symbols         | statusCode | errorMessage                                                                                          |
      | 2020-01-01 | EUR             | 400        | Symbols 'EUR' are invalid for date (the same date as in request or previous working day).             |
      | 2030-01-01 | HSB             | 400        | Symbols 'HSB' are invalid for date (the same date as in request or previous working day).             |
      | 2018-03-01 | USD,ABC         | 400        | Symbols 'USD,ABC' are invalid for date (the same date as in request or previous working day).         |
      | 2015-05-05 | HSB,ABC,CMB,SOC | 400        | Symbols 'HSB,ABC,CMB,SOC' are invalid for date (the same date as in request or previous working day). |

  @past-rates @negative-scenario @date @base
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date and invalid base parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set base parameter to "<baseCurrencyInParameter>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | date       | baseCurrencyInParameter | statusCode | errorMessage                     |
      | 2020-01-01 | AGH                     | 400        | Base 'AGH' is not supported.     |
      | 2030-01-01 | GBP,USD                 | 400        | Base 'GBP,USD' is not supported. |
      | 2018-03-01 | GBP,AGH                 | 400        | Base 'GBP,AGH' is not supported. |

  @past-rates @negative-scenario @date @base @symbols
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date and with invalid base or symbols parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | date       | baseCurrencyInParameter | symbols           | statusCode | errorMessage                                                                                      |
      | 2020-01-01 | AGH                     | GBP               | 400        | Base 'AGH' is not supported.                                                                      |
      | 2030-01-01 | JPY,AGH                 | GBP,CZK,NOK       | 400        | Base 'JPY,AGH' is not supported.                                                                  |
      | 2018-03-01 | ISK                     | JSW               | 400        | Symbols 'JSW' are invalid for date (the same date as in request or previous working day).         |
      | 2018-03-01 | SGD                     | KGH,GBP,INR       | 400        | Symbols 'KGH,GBP,INR' are invalid for date (the same date as in request or previous working day). |
      | 2020-01-01 | CDD                     | (empty parameter) | 400        | Base 'CDD' is not supported.                                                                      |
      | 2030-01-01 | RUB,CNY,ABC             | (empty parameter) | 400        | Base 'RUB,CNY,ABC' is not supported.                                                              |
      | 2018-03-01 | (empty parameter)       | CMB               | 400        | Symbols 'CMB' are invalid for date (the same date as in request or previous working day).         |
      | 2018-03-01 | (empty parameter)       | EUR,GBP,MSI       | 400        | Symbols 'EUR,GBP,MSI' are invalid for date (the same date as in request or previous working day). |

  @past-rates @negative-scenario @date @base @symbols
  Scenario Outline: I hit past FX rates endpoint of Rates API with invalid date, base and symbols parameters
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And error message "<errorMessage>" is returned

    Examples:
      | date       | baseCurrencyInParameter | symbols     | statusCode | errorMessage                                      |
      | 2001-04-31 | CRT                     | LCD         | 400        | day is out of range for month                     |
      | 1930-01-01 | CRT                     | IPS,MVA,PVA | 400        | There is no data for dates older then 1999-01-04. |
      | 2001-02-29 | CRT,LCD,IPS             | PVA         | 400        | day is out of range for month                     |
      | 1965-05-05 | CRT,LCD,IPS             | LCD,MVA,PVA | 400        | There is no data for dates older then 1999-01-04. |