Feature: Past FX rates endpoint - positive scenarios

  @past-rates @positive-scenario @date
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
      | 2000-02-29 | 200        | EUR                    | AUD,CAD,CHF,CYP,CZK,DKK,EEK,GBP,HKD,HUF,ISK,JPY,KRW,LTL,LVL,MTL,NOK,NZD,PLN,ROL,SEK,SGD,SIT,SKK,TRL,USD,ZAR | (the same date as in request or previous working day) |
      | 2030-07-19 | 200        | EUR                    | (all currencies)                                                                                            | (current date or previous working day)                |

  @past-rates @positive-scenario @symbols
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

  @past-rates @positive-scenario @base
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


  @past-rates @positive-scenario @base @symbols
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