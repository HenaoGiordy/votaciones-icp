import HashMap "mo:base/HashMap";
import models "models";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Error "errors";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

actor{
  //Create a hashmap to store the Elections
  var elections = HashMap.HashMap<Text, models.Election>(5, Text.equal, Text.hash);

  //Create a new Election
  public shared(msg) func createElection(election : models.Election) : async Result.Result<models.Election,  Error.ElectionError>{
    //Check if the user is authenticated
    if(Principal.isAnonymous(msg.caller)){
      return #err(#NotAuthenticated);
    };
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
  public shared(msg) func addCandidate(electionNumber : Text, candidate : models.Candidate) : async Result.Result<models.Candidate, Error.ElectionError>{
    //Check if the user is authenticated
    if(Principal.isAnonymous(msg.caller)){
      return #err(#NotAuthenticated);
    };
    var election = elections.get(electionNumber);
    switch(election){
      case (?election) {
        //Get the candidates
        var canditates = Buffer.fromArray<models.Candidate>(election.candidates);
        for(i in canditates.vals()){
          //Check if the candidate already exists
          if(i.number == candidate.number){
            return #err(#CandidateAlreadyExists);
          };
        };
        //Add the new candidate
        canditates.add(candidate);
        //Convert new Buffer<Candidates> to an array of candidates
        var newArray = Buffer.toArray(canditates);
        //Create a new Election with the new candidate
        var newElection: models.Election = {
          number = electionNumber;
          candidates = newArray;
          voters = election.voters;
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
  
  public shared(msg) func vote(numberElection : Text, numberCandidate: Text): async Result.Result<models.Candidate, Error.ElectionError>{
    //Check if the user is authenticated
    if(Principal.isAnonymous(msg.caller)){
      return #err(#NotAuthenticated);
    };
    //Get the Election
    var election = elections.get(numberElection);
    
    switch(election){
      case(?election){
        var voters = Buffer.fromArray<Principal>(election.voters);
        //Check if the user has already voted
        if(Buffer.contains<Principal>(voters, msg.caller, Principal.equal)){
          return #err(#AlreadyVoted);
        };
        //Get the Candidate
        var candidates = election.candidates;
        var candidate: ?models.Candidate = Array.find<models.Candidate>(candidates, func x = x.number == numberCandidate);
        switch(candidate){
          case(?candidate){
            var modify = Buffer.fromArray<models.Candidate>(candidates);
            var iterador : Nat = 0;
            for(i in modify.vals()){
              if(i.number == numberCandidate){
                var newCandidate: models.Candidate = {
                  number = i.number;
                  name = i.name;
                  votes = i.votes + 1;
                };
                modify.put(iterador, newCandidate);
                var electionModified = Buffer.toArray<models.Candidate>(modify);
                var voters = Buffer.fromArray<Principal>(election.voters);
                voters.add(msg.caller);
                var newElection: models.Election = {
                  number = numberElection;
                  candidates = electionModified;
                  voters = Buffer.toArray<Principal>(voters);
                };
                ignore elections.replace(numberElection, newElection);
                return #ok((newCandidate));
              };
              iterador += 1;
            };
            return #err(#CandidateNotFound);
          };
          case null{
            return #err(#CandidateNotFound);
          };
        };
        
      };
      case null{
        return #err(#ElectioNotFound);
      }
    }
  };

  //Get a specific Candidate by it´s number
  public query func getCandidate(numberCandidate : Text, numberElection: Text) : async Result.Result<models.Candidate, Error.ElectionError>{
    var election = elections.get(numberElection);
    switch(election){
      case(?election){
        var candidates = election.candidates;
        var candidate: ?models.Candidate = Array.find<models.Candidate>(candidates, func x = x.number == numberCandidate);
        switch(candidate){
          case(?candidate){
            return #ok(candidate);
          };
          case null{
            return #err(#CandidateNotFound);
          };
        };
      };
      case null{
        return #err(#ElectioNotFound);
      };
    };
  };

  
}

