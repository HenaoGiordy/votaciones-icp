module{
    
    public type ElectionError ={
        #ElectionAlreadyExists;
        #ElectioNotFound;
        #CandidateNotFound;
        #CandidateAlreadyExists;
        #NotAuthenticated;
    };
}