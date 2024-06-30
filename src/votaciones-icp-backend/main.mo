import HashMap "mo:base/HashMap";
import models "models";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Error "errors";

actor{
  //Create a hashmap to store the votes
  var votes = HashMap.HashMap<Text, models.Vote>(5, Text.equal, Text.hash);

  //Create a new vote
  public func createVote(vote : models.Vote) : async Result.Result<models.Vote,  Error.VoteError>{
    //Check if the vote already exists
    if((votes.get(vote.number)) != null){
      return #err(#VoteAlreadyExists);
    };
      //Add the vote to the hashmap
      votes.put(vote.number, vote);
      return #ok(vote);
    };
  
  //Add a candidate to a vote
  public func addCandidate(voteNumber : Text, candidate : models.Candidate) : async Result.Result<models.Candidate, Error.VoteError>{
    var vote = votes.get(voteNumber);
    switch(vote){
      case (?vote) {
        //Get the candidates
        var canditates = Buffer.fromArray<models.Candidate>(vote.candidates);
        //Add the new candidate
        canditates.add(candidate);
        //Convert new Buffer<Candidates> to an array of candidates
        var newArray = Buffer.toArray(canditates);
        //Create a new vote with the new candidate
        var newVote: models.Vote = {
          number = voteNumber;
          candidates = newArray;
        };
        //Replace the old vote with the new one
        ignore votes.replace(voteNumber, newVote);
        return #ok(candidate);
      };
      case null {
        //If the vote does not exist
        return #err(#VoteNotFound);
      };
    };
  }
}

