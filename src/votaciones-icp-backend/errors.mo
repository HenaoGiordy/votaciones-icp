module{
    
    public type ElectionError ={
        #ElectionAlreadyExists;
        #AlreadyVoted;
        #ElectioNotFound;
        #CandidateNotFound;
        #CandidateAlreadyExists;
        #NotAuthenticated;
    };
}