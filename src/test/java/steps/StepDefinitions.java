package steps;

import helpers.TestHelpers;
import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.config.HttpClientConfig;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {

    private RequestSpecification request;
    private String urlString;
    private String fullUrl;
    private Response response;
    private static int TIMEOUT = 2000;

    private String apiUrl = "https://api.ratesapi.io/api";
    private static List<String> ALL_CURRENCIES = Arrays.asList("GBP", "HKD", "IDR", "ILS", "DKK", "INR", "CHF",
            "MXN", "CZK", "SGD", "THB", "HRK", "MYR", "NOK", "CNY", "BGN", "PHP", "SEK", "PLN", "ZAR",
            "CAD", "ISK", "BRL", "RON", "NZD", "TRY", "JPY", "RUB", "KRW", "USD", "HUF", "AUD");
    private List<String> expectedCurrencies;
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
                        .setParam("http.connection-manager.timeout", TIMEOUT));

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
            System.out.println("Contains string working day");

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
            assertEquals(response.path("error"), errorMessage);
        }
    }

    @When("I set endpoint to latest")
    public void iSetEndpointToLatest() {
        urlString = "latest";
    }

    @And("base currency {string} is returned")
    public void baseCurrencyIsReturned(String base) {
        assertEquals(response.path("base"), base);
    }

    @And("numerical values of exchange rate are returned for {string}")
    public void numericalValuesOfExchangeRateAreReturnedFor(String rates) {
        if (rates.equals("(all currencies)")) {
            expectedCurrencies = ALL_CURRENCIES; // replace ("all currencies") description with it names list
        } else {
            expectedCurrencies = Arrays.asList(rates.split("\\s*,\\s*"));
        }

        Map<String, Float> ratesFromApi = response.then().extract().response().path("rates"); // extract all rates from API response, check if they have numerical values
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

}
