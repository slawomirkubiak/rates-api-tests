# rates-api-tests

## Technical details
IMP: This project uses Java 1.8

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
Following test cases were designed:

|TC no | Category/Feature | Summary/Scenario | Prerequisites/Given | Step no | Step | Expected result/Then | Tag |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Invalid URL syntax | Missing date | Rates API is up and running | 1 | Hit url `https://api.ratesapi.io/api/` | <li>Status code `400` is returned <li>Error message `{"error":"time data 'api' does not match format '%Y-%m-%d'"}` is returned | invalid-url, negative-test |
| 2 | Invalid URL syntax | Invalid date format | Rates API is up and running | 1 | Hit url `https://api.ratesapi.io/api/2019-Dec-29` | <li>Status code `400` is returned <li>Error message `{"error":"time data '2019-Dec-29' does not match format '%Y-%m-%d'"}` is returned | invalid-url |
| 3 | Invalid URL syntax | Dummy sting instead of date | Rates API is up and running | 1 | Hit url `https://api.ratesapi.io/api/sampleDate` | <li>Status code `400` is returned <li>Error message `{"error":"time data 'sampleDate' does not match format '%Y-%m-%d'"}` is returned | invalid-url |
| 4 | Latest date endpoint | Simple FX rates request | Rates API is up and running | 1 | Hit `latest` endpoint | <li>Status code `200` is returned <li>`base` key has `EUR` value<li> key `rates` contains numerical values for all currencies<li>`date` key has current date in format YYYY-MM-DD value | | latest, positive-scenario |
| 5 | Latest date endpoint | FX rates request - single symbol | Rates API is up and running | 1 | Hit `latest` endpoint with `symbol` parameter and value `USD`| <li>Status code `200` is returned <li>`base` key has `EUR` value<li> key `rates` contains only one element and it's numerical value of exchange rate for `USD`<li>`date` key has current date in format YYYY-MM-DD value | | latest, positive-scenario |
| 6 | Latest date endpoint | FX rates request - multiple symbols | Rates API is up and running | 1 | Hit `latest` endpoint with `symbol` parameter and values `USD,GBP,PLN`| <li>Status code `200` is returned <li>`base` key has `EUR` value<li> key `rates` contains elements `USD,GBP,PLN` it's numerical value of exchange rate<li>`date` key has current date in format YYYY-MM-DD value | | latest, positive-scenario |

## Traceability matrix

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

# Running tests
- run `mvn test`
- report should be generated in `\target\cucumber-report.html`
- running selected scenarios by tags:

  - update `tags` property in file `src\test\java\RunCucumberTest.java`:
  <pre><code> @CucumberOptions(
        plugin = {"pretty", "html:target/cucumber-report.html"},
        features = {"src/test/resources"},
        glue = {"steps"},
        tags = "@positive-scenario or @negative-scenario"
  </pre></code>
    
  - run in cmd `mvn test -Dcucumber.filter.tags="@positive-scenario or @negative-scenario`

