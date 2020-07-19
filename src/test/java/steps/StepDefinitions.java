package steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.config.HttpClientConfig;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import static io.restassured.RestAssured.given;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {


    private RequestSpecification request;
    private String fullUrl;
    private Response response;
    private static int TIMEOUT = 400;

    private String apiUrl = "https://api.ratesapi.io/api/";

    @Before
    public void buildApiUrl() {

    RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
    RestAssured.config = RestAssured
        .config()
        .httpClient(HttpClientConfig.httpClientConfig()
            .setParam("http.connection.timeout", TIMEOUT)
            .setParam("http.socket.timeout", TIMEOUT)
            .setParam("http.connection-manager.timeout", TIMEOUT));
    
    request = given().when();
    }

    @When("I put {string} in URL")
    public void iPutUrlStringInURL(String urlString) {
        urlString = (urlString.equals("(no string)")) ? "" : urlString; //replace null value description from feature file with real null
        fullUrl = apiUrl + urlString;
    }

    @Then("status code {int} is returned")
    public void statusCodeStatusCodeIsReturned(int statusCode) {
        response.then().statusCode(statusCode);
    }

    @And("error message {string} is returned")
    public void errorMessageErrorMessageIsReturned(String errorMessage) {
        assertEquals(response.path("error"), errorMessage);
    }

    @And("I hit Rates API")
    public void hitRatesAPI() {
        response = request.get(fullUrl);
    }
}
