import ballerina/http;
import ballerina/io;

type RiskResponse record {
boolean hasRisk;
};

type RiskRequest record {
string ip;
};

type ipGeolocationResp record {
string ip;
string country_code2;
};

final string geoApiKey = "cbb6cb59fec24f4eb0d3a1f66984db49";

service / on new http:Listener(8090) {
resource function post risk(@http:Payload RiskRequest req) returns RiskResponse|error? {

     string ip = req.ip;
     http:Client ipGeolocation = check new ("https://api.ipgeolocation.io");
     ipGeolocationResp geoResponse = check ipGeolocation->get(string `/ipgeo?apiKey=${geoApiKey}&ip=${ip}&fields=country_code2`);

    io:println(geoResponse.country_code2);
     RiskResponse resp = {
          // hasRisk is true if the country code of the IP address is not the specified country code.
          hasRisk: geoResponse.country_code2 == "CA"
     };
     return resp;
}
}
