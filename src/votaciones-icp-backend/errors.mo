module{
    public type AuthenticationError ={
        #NotAuthenticated;
    };
    public type VoteError ={
        #VoteAlreadyExists;
        #VoteNotFound;
        #CandidateAlreadyExists;
    };
}