Feature: Past FX rates endpoint

  @past-rates @positive-tests @no-parameters
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date and without any parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And numerical values of exchange rate are returned for "<rates>"
    And date "<dateInResponse>" is returned

    Examples:
      | date       | statusCode | baseCurrencyInResponse | rates                                                                                                       | dateInResponse                                        |
      | 2020-07-19 | 200        | EUR                    | (all currencies)                                                                                            | (the same date as in request or previous working day) |
      | 1999-01-04 | 200        | EUR                    | AUD,CAD,CHF,CYP,CZK,DKK,EEK,GBP,HKD,HUF,ISK,JPY,KRW,LTL,LVL,MTL,NOK,NZD,PLN,ROL,SEK,SGD,SIT,SKK,TRL,USD,ZAR | (the same date as in request or previous working day) |
      | 2000-02-29 | 200        | EUR                    | AUD,CAD,CHF,CYP,CZK,DKK,EEK,GBP,HKD,HUF,ISK,JPY,KRW,LTL,LVL,MTL,NOK,NZD,PLN,ROL,SEK,SGD,SIT,SKK,TRL,USD,ZAR | (the same date as in request or previous working day) |
      | 2030-07-19 | 200        | EUR                    | (all currencies)                                                                                            | (current date or previous working day)                |

  @past-rates @negative-tests @no-parameters
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

  @past-rates @positive-tests @symbols
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date and symbol parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And numerical values of exchange rate are returned for "<rates>"
    And date "<dateInResponse>" is returned

    Examples:
      | date       | symbols               | statusCode | baseCurrencyInResponse | rates               | dateInResponse                                        |
      | 2020-01-01 | USD                   | 200        | EUR                    | USD                 | (the same date as in request or previous working day) |
      | 2010-01-01 | USD,GBP,CHF,CZK,SEK   | 200        | EUR                    | USD,GBP,CHF,CZK,SEK | (the same date as in request or previous working day) |
      | 2030-12-31 | (no symbol parameter) | 200        | EUR                    | (all currencies)    | (current date or previous working day)                |
      | 2040-12-31 | (empty parameter)     | 200        | EUR                    | (all currencies)    | (current date or previous working day)                |

  @past-rates @positive-tests @base
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date and base parameter
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set base parameter to "<baseCurrencyInParameter>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And exchange rate for "<baseCurrencyInResponse>" currency equals "<rateForBaseCurrency>"
    And numerical values of exchange rate are returned for "<rates>"
    And date "<dateInResponse>" is returned

    Examples:
      | date       | baseCurrencyInParameter | statusCode | baseCurrencyInResponse | rates                                    | rateForBaseCurrency | dateInResponse                                        |
      | 2020-02-14 | USD                     | 200        | USD                    | (all currencies including base currency) | 1.0                 | (the same date as in request or previous working day) |
      | 2018-02-03 | GBP                     | 200        | GBP                    | (all currencies including base currency) | 1.0                 | (the same date as in request or previous working day) |
      | 2050-12-31 | (empty parameter)       | 200        | EUR                    | (all currencies)                         | (not present)       | (current date or previous working day)                |


  @past-rates @positive-tests @base @symbols
  Scenario Outline: I hit past FX rates endpoint of Rates API with valid date, base and symbols parameters
    When I set endpoint to past
    And I set date in URL to "<date>"
    And I set base parameter to "<baseCurrencyInParameter>"
    And I set symbols parameter to "<symbols>"
    And I hit Rates API
    Then status code <statusCode> is returned
    And base currency "<baseCurrencyInResponse>" is returned
    And numerical values of exchange rate are returned for "<rates>"
    And date "<dateInResponse>" is returned

    Examples:
      | date       | baseCurrencyInParameter | symbols           | statusCode | baseCurrencyInResponse | rates                                    | dateInResponse                                        |
      | 2020-01-01 | EUR                     | GBP               | 200        | EUR                    | GBP                                      | (the same date as in request or previous working day) |
      | 2030-01-01 | SEK                     | GBP,CZK,NOK       | 200        | SEK                    | GBP,CZK,NOK                              | (current date or previous working day)                |
      | 2018-03-01 | PLN                     | (empty parameter) | 200        | PLN                    | (all currencies including base currency) | (the same date as in request or previous working day) |
      | 2015-05-05 | (empty parameter)       | HUF               | 200        | EUR                    | HUF                                      | (the same date as in request or previous working day) |
      | 2030-01-01 | (empty parameter)       | GBP,CHF,HKD       | 200        | EUR                    | GBP,CHF,HKD                              | (current date or previous working day)                |

  @past-rates @negative-tests @base @symbols
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

  @past-rates @negative-tests @symbols
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

  @past-rates @negative-tests @base
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

  @past-rates @negative-tests @base @symbols
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

  @past-rates @negative-tests @base @symbols
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