package steps;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;
import io.restassured.response.ValidatableResponse;

import static io.restassured.RestAssured.*;
import static org.junit.Assert.assertEquals;

public class StepDefinitions {

    private Response response;

    private String apiUrl = "https://api.ratesapi.io/api/";

    @When("I put {string} in URL")
    public void iPutStringInURL(String urlString) {
        response = given().log().all().when().get(apiUrl + urlString);
    }

    @Then("status code {int} is returned")
    public void statusCodeStatusCodeIsReturned(int statusCode) {
        response.then().statusCode(statusCode);

    }

    @And("error message {string} is returned")
    public void errorMessageErrorMessageIsReturned(String errorMessage) {
        assertEquals(response.path("error"), errorMessage);

    }
}
