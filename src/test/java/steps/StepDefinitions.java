package steps;

import helpers.TestHelpers;
import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.config.HttpClientConfig;
import io.restassured.path.json.config.JsonPathConfig;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

import static io.restassured.RestAssured.given;
import static io.restassured.config.JsonConfig.jsonConfig;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class StepDefinitions {

    private RequestSpecification request;
    private String urlString;
    private String fullUrl;
    private Response response;
    private static int TIMEOUT = 2000;

    private static String DEFAULT_BASE = "EUR"; //default value in API
    private String base = DEFAULT_BASE;

    public String getBase() {
        return base;
    }

    public void setBase(String base) {
        this.base = base;
    }

    private String apiUrl = "https://api.ratesapi.io/api";
    private LinkedList<String> ALL_CURRENCIES = new LinkedList<>(Arrays.asList("GBP", "HKD", "IDR", "ILS", "DKK", "INR", "CHF",
            "MXN", "CZK", "SGD", "THB", "HRK", "MYR", "NOK", "CNY", "BGN", "PHP", "SEK", "PLN", "ZAR",
            "CAD", "ISK", "BRL", "RON", "NZD", "TRY", "JPY", "RUB", "KRW", "USD", "HUF", "AUD", "EUR"));
    private static String CURRENT_OR_PREVIOUS_WORKING_DAY_STRING = "(current date or previous working day)";
    private static LocalDate CURRENT_DATE = LocalDate.now();
    private static LocalDate PREVIOUS_WORKING_DAY = TestHelpers.getPreviousWorkingDay(LocalDate.now());

    @Before
    public void setupRequest() {

        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
        RestAssured.config = RestAssured
                .config()
                .httpClient(HttpClientConfig.httpClientConfig()
                        .setParam("http.connection.timeout", TIMEOUT)
                        .setParam("http.socket.timeout", TIMEOUT)
                        .setParam("http.connection-manager.timeout", TIMEOUT))
                .jsonConfig(jsonConfig().numberReturnType(JsonPathConfig.NumberReturnType.BIG_DECIMAL));

        request = given()
                .urlEncodingEnabled(false) //turn off replacing comma to %2C etc.
                .log().all(); //log all request details

    }

    @When("I set {string} in URL")
    public void iPutUrlStringInURL(String urlString) {
        this.urlString = urlString.equals("(no string)") ? "" : urlString; //replace empty value description from feature file with real empty value
    }

    @When("I set symbols parameter to {string}")
    public void iSetSymbolsParameterToSymbols(String symbols) {

        if (!symbols.equals("(empty parameter)")) { //skip the logic if "symbols" parameter shouldn't be set
            symbols = symbols.equals("(no symbol parameter)") ? "" : symbols; // replace empty symbol value description from feature file with real empty value
            request = request.param("symbols", symbols);
        }

    }

    @And("I hit Rates API")
    public void hitRatesAPI() {
        fullUrl = apiUrl + "/" + urlString;
        response = request.when().get(fullUrl);
    }

    @Then("status code {int} is returned")
    public void statusCodeStatusCodeIsReturned(int statusCode) {
        response.then().log().all().statusCode(statusCode); //TBD: move response logging to separate method
    }

    @And("error message {string} is returned")
    public void errorMessageErrorMessageIsReturned(String errorMessage) {
        if (errorMessage.contains(CURRENT_OR_PREVIOUS_WORKING_DAY_STRING)) {

            String trimmedErrorMessage1 = errorMessage.replaceAll(CURRENT_OR_PREVIOUS_WORKING_DAY_STRING, CURRENT_DATE.toString()).replaceAll("[()]", ""); //workaround to trim parenthesis as they're interpreted by regex
            String trimmedErrorMessage2 = errorMessage.replaceAll(CURRENT_OR_PREVIOUS_WORKING_DAY_STRING, PREVIOUS_WORKING_DAY.toString()).replaceAll("[()]", "");
            String errorFromApi = response.path("error");

            assertThat(errorFromApi, is(
                    anyOf(
                            equalTo(trimmedErrorMessage1),
                            equalTo(trimmedErrorMessage2)
                    )
            ));

        } else {
            assertEquals(errorMessage, response.path("error"));
        }
    }

    @When("I set endpoint to latest")
    public void iSetEndpointToLatest() {
        urlString = "latest";
    }

    @And("base currency {string} is returned")
    public void baseCurrencyIsReturned(String base) {
        assertEquals(base, response.path("base"));
    }

    @And("numerical values of exchange rate are returned for {string}")
    public void numericalValuesOfExchangeRateAreReturnedFor(String rates) {
        List<String> expectedCurrencies;

        switch (rates) {
            case "(all currencies)":
                expectedCurrencies = ALL_CURRENCIES;
                expectedCurrencies.remove(getBase()); // remove base currency from the currencies list
                break;
            case "(all currencies including base currency)":
                expectedCurrencies = ALL_CURRENCIES;
                break;
            default:
                expectedCurrencies = Arrays.asList(rates.split("\\s*,\\s*")); // load expected currencies from feature file
        }

        Map<String, BigDecimal> ratesFromApi = response.then().extract().response().path("rates"); // extract all rates from API response, check if they have numerical values
        List<String> currenciesFromApi = new ArrayList(ratesFromApi.keySet()); // move just currencies to separate list

        TestHelpers.compareListsIfEquals(expectedCurrencies, currenciesFromApi);
    }


    @And("date {string} is returned")
    public void dateDateIsReturned(String date) {
        LocalDate dateFromApi = LocalDate.parse(response.then().extract().response().path("date"));

        if (date.equals(CURRENT_OR_PREVIOUS_WORKING_DAY_STRING)) {
            assertThat(dateFromApi, is(anyOf(equalTo(CURRENT_DATE), equalTo(PREVIOUS_WORKING_DAY))));
        } else {
            assertThat(dateFromApi, equalTo(CURRENT_DATE));
        }
    }

    @And("I set base parameter to {string}")
    public void iSetBaseParameterTo(String baseCurrencyInParameter) {

        switch (baseCurrencyInParameter) {
            case "(empty parameter)":
                break; //skip the logic if "symbols" parameter shouldn't be set
            case "(no symbol parameter)":
                request = request.param("base", ""); // replace empty symbol value description from feature file with real empty value
            default:
                request = request.param("base", baseCurrencyInParameter);
                setBase(baseCurrencyInParameter);
        }

    }

    @And("exchange rate for {string} currency equals {string}")
    public void exchangeRateForCurrencyEquals(String baseCurrencyInResponse, String expectedBaseCurrencyFxRate) {
        if (expectedBaseCurrencyFxRate.equals("(not present)")) {
            assertNull(response.path("rates." + getBase()));
        } else {
            assertEquals(new BigDecimal(expectedBaseCurrencyFxRate), response.path("rates." + baseCurrencyInResponse));
        }
    }
}