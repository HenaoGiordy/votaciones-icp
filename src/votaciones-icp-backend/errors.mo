module{
    public type AuthenticationError ={
        #NotAuthenticated;
    };
    public type ElectionError ={
        #ElectionAlreadyExists;
        #ElectioNotFound;
        #CandidateAlreadyExists;
    };
}