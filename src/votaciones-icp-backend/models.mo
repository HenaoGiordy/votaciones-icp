import Text "mo:base/Text";

module{
    public type Candidate = {
        number: Text;
        name : Text;
        votes : Nat;
    };

    public type Vote = {
        number: Text;
        candidates : [Candidate];
    };
}