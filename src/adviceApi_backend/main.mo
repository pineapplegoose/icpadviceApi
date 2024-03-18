import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import List "mo:base/List";
import Random "mo:base/Random";
import Result "mo:base/Result";

actor {

  type Advice = {
    text : Text;
    id : Nat;
    time : Time.Time;
    user : Principal;
    tag : Text;
  };

  var nil : List.List<Advice> = List.nil<Advice>();

  public shared (msg) func createAdvice(text : Text, tag : Text) : async Advice {
    let advice : Advice = {
      text = text;
      id = 1;
      time = Time.now();
      user = msg.caller;
      tag = tag;
    };
    let _ = List.push(advice, nil);
    return advice;
  };

  public func getRandom() : async Result.Result<Advice, Text> {
    let random = Random.Finite(await Random.blob());
    let randomNumber = random.range(8);
    switch (randomNumber) {
      case (null) {
        return #err("There was an error genrating the random number");
      };
      case (?number) {
        let index = number % List.size(nil);
        let advice = List.get(nil, index);
        switch (advice) {
          case (null) {
            return #err("There was a problem getting the index");
          };
          case (?advice) {
            return #ok(advice);
          };
        };
      };
    };

  };

  public func getRandomByTag(tag : Text) : async Result.Result<Advice, Text> {
    let random = Random.Finite(await Random.blob());
    let randomNumber = random.range(8);
    let other = List.filter<Advice>(nil, func(advice) { advice.tag == tag });
    switch (randomNumber) {
      case (null) {
        return #err("There was an error genrating the random number");
      };
      case (?number) {
        let index = number % List.size(other);
        let advice = List.get(other, index);
        switch (advice) {
          case (null) {
            return #err("There was a problem getting the index");
          };
          case (?advice) {
            return #ok(advice);
          };
        };
      };
    };

  };
};
