# rates-api-tests

## Technical details
This project uses Java 1.8

## Assumptions
- all requests in this project are GET methods
- `all currencies` term means following currencies: `EUR, GBP, HKD, IDR, ILS, DKK, INR, CHF, MXN, CZK, SGD, THB, HRK, MYR, NOK, CNY, BGN, PHP, SEK, PLN, ZAR, CAD, ISK, BRL, RON, NZD, TRY, JPY, RUB, KRW, USD, HUF, AUD` 
- currently tests assumes that tests are running only in working days so `date` in response should be current date or previous working day. TBD: handling public holidays etc.

# Testing approach
## Acceptance criteria
Following AC were provided:

| AC No | Given | When | Then |
| --- | --- | --- | --- |
| 1 | Rates API for Latest Foreign Exchange rates | The API is available | An automated test suite should run which will assert the success status of the response |
| 2 | As above | As above | An automated test suite should run which will assert the response |
| 3 | As above | An incorrect or incomplete url is provided e.g: https://api.ratesapi.io/api/ | Test case should assert the correct response supplied by the call |
| 4 | Rates API for Specific date Foreign Exchange rates | The API is available | An automated test suite should run which will assert the success status of the response |
| 5 | As above | As above | An automated test suite should run which will assert the response |
| 6 | As above | A future date is provided in the url | An automated test suite should run which will validate that the response matches the current date |

## Test cases
All designed test cases were gathered in file [rates-api-scenarios.xlsx](https://github.com/slawomirkubiak/rates-api-tests/blob/master/src/test/resources/docs/rates-api-scenarios.xlsx)


# Running tests
- run `mvn test`
- report should be generated in `\target\cucumber-report.html`
- running selected scenarios by tags:

  - update `tags` property in file `src\test\java\RunCucumberTest.java`:
  <pre> @CucumberOptions(
        plugin = {"pretty", "html:target/cucumber-report.html"},
        features = {"src/test/resources"},
        glue = {"steps"},
        tags = "@positive-scenario or @negative-scenario")
  </pre>

  - run in cmd `mvn test -Dcucumber.filter.tags="@positive-scenario or @negative-scenario`

## Tags
Following tags were defined for scenarios:

By API feature:
- `@latest-rates`
- `@past-rates`
- `@invalid-url`

By scenario type:
- `@positive-scenario`
- `@negative-scenario`

By used parameter:
- `@date`
- `@base`
- `@symbols`