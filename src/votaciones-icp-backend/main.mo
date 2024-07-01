import HashMap "mo:base/HashMap";
import models "models";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Error "errors";

actor{
  //Create a hashmap to store the Elections
  var elections = HashMap.HashMap<Text, models.Election>(5, Text.equal, Text.hash);

  //Create a new Election
  public func createElection(election : models.Election) : async Result.Result<models.Election,  Error.ElectionError>{
    //Check if the Election already exists
    switch(elections.get(election.number)){
      case (?_) {
        return #err(#ElectionAlreadyExists);
      };
      case null {
        //Add the Election to the hashmap
        elections.put(election.number, election);
        return #ok(election);
      };
    };
    
  };
  
  //Add a candidate to a Election
  public func addCandidate(electionNumber : Text, candidate : models.Candidate) : async Result.Result<models.Candidate, Error.ElectionError>{
    var election = elections.get(electionNumber);
    switch(election){
      case (?election) {
        //Get the candidates
        var canditates = Buffer.fromArray<models.Candidate>(election.candidates);
        //Add the new candidate
        canditates.add(candidate);
        //Convert new Buffer<Candidates> to an array of candidates
        var newArray = Buffer.toArray(canditates);
        //Create a new Election with the new candidate
        var newElection: models.Election = {
          number = electionNumber;
          candidates = newArray;
        };
        //Replace the old Election with the new one
        ignore elections.replace(electionNumber, newElection);
        return #ok(candidate);
      };
      case null {
        //If the Election does not exist
        return #err(#ElectioNotFound);
      };
    };
  };

  //Get a specific Election by it´s number
  public query func getElection(number: Text): async Result.Result<models.Election, Error.ElectionError> {
    var election = elections.get(number);
    switch(election){
      case (?election) {
        return #ok(election);
      };
      case null {
        return #err(#ElectioNotFound);
        };
      };
    };
  
}

