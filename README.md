# `votaciones-icp`


This Motoko program manages elections through a set of operations on elections and candidates. It utilizes actors, HashMaps, and defined models and errors to ensure secure and structured election management.
Modules

- Main.mo: Contains the main logic for managing elections.
- Errors.mo: Defines custom error types specific to election operations.
- Models.mo: Defines the data structures used in the program, such as Candidate and Election.

# `Functionality`

### `Create Election`
**createElection(election: models.Election)**
Creates a new election if the caller is authenticated and the election doesn't already exist. Returns the created election or an error if authentication fails or the election already exists.
 
### `Add Candidate to Election`
**addCandidate(electionNumber: Text, candidate: models.Candidate)**
 Adds a candidate to a specified election if the caller is authenticated, the election exists, and the candidate doesn't already exist in that election. Returns the added candidate or an error if conditions are not met.

### `Get Election`
**getElection(number: Text)**
Retrieves an election by its number. Returns the election if found, or an error if not found.

### `Vote in Election`

**vote(numberElection: Text, numberCandidate: Text):**
Allows a voter to cast a vote for a candidate in a specified election if authenticated, not already voted, and both election and candidate exist. Returns the updated candidate with incremented votes or an error.

### `Get Candidate in Election`
**getCandidate(numberCandidate: Text, numberElection: Text)**
Retrieves a candidate by their number in a specified election. Returns the candidate if found, or an error if not found.

# `Error Handling`

The program defines several custom errors in errors.mo to manage various scenarios such as election or candidate not found, authentication failures, attempts to add duplicate candidates.

```motoko
  public type ElectionError =
      {
          #ElectionAlreadyExists;
          #AlreadyVoted;
          #ElectioNotFound;
          #CandidateNotFound;
          #CandidateAlreadyExists;
          #NotAuthenticated;
      };
```