import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Bool "mo:base/Bool";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

actor {
  type DogId = Nat32;
  type Dog = {
    name : Text;
    age : Nat32;
    breed : Text;
    isAdopted : Bool;
    isNeutered : Bool
  };

  type ResponseDog = {
    name : Text;
    age : Nat32;
    breed : Text;
    isAdopted : Bool;
    isNeutered : Bool;
    id : Nat32
  };

  type SearchCriteria = {
    minAge : ?Nat32;
    maxAge : ?Nat32;
    breed : ?Text;
    isAdopted : ?Bool;
    isNeutered : ?Bool
  };

  private stable var nextDogId : DogId = 0;
  private stable var dogs : Trie.Trie<DogId, Dog> = Trie.empty();

  // Function to retrieve a single dog's details by its ID
  public query func getDog(dogId : DogId) : async ?ResponseDog {
    let result = Trie.find(dogs, key(dogId), Nat32.equal);
    switch result {
      case (?dog) {
        ?{
          name = dog.name;
          age = dog.age;
          breed = dog.breed;
          isAdopted = dog.isAdopted;
          isNeutered = dog.isNeutered;
          id = dogId
        }
      };
      case null {null}
    }
  };

  // Function to list all dogs in the shelter
  public query func listAllDogs() : async [ResponseDog] {
    let buffer = Buffer.Buffer<ResponseDog>(0);

    for ((id, dog) in Trie.iter(dogs)) {
      buffer.add({
        name = dog.name;
        age = dog.age;
        breed = dog.breed;
        isAdopted = dog.isAdopted;
        isNeutered = dog.isNeutered;
        id = id
      })
    };

    return Buffer.toArray(buffer)
  };

  // Function to search dogs based on multiple criteria
  public query func searchDogs(criteria : SearchCriteria) : async [ResponseDog] {
    let buffer = Buffer.Buffer<ResponseDog>(0);

    for ((id, dog) in Trie.iter(dogs)) {
      let matchAge = switch (criteria.minAge, criteria.maxAge) {
        case (null, null) {true};
        case (?min, null) {dog.age >= min};
        case (null, ?max) {dog.age <= max};
        case (?min, ?max) {dog.age >= min and dog.age <= max}
      };

      let matchBreed = switch (criteria.breed) {
        case null {true};
        case (?breed) {Text.equal(dog.breed, breed)}
      };

      let matchAdopted = switch (criteria.isAdopted) {
        case null {true};
        case (?status) {dog.isAdopted == status}
      };

      let matchNeutered = switch (criteria.isNeutered) {
        case null {true};
        case (?status) {dog.isNeutered == status}
      };

      if (matchAge and matchBreed and matchAdopted and matchNeutered) {
        buffer.add({
          name = dog.name;
          age = dog.age;
          breed = dog.breed;
          isAdopted = dog.isAdopted;
          isNeutered = dog.isNeutered;
          id = id
        })
      }
    };

    return Buffer.toArray(buffer)
  };

  // Function to neuter a dog by updating its record
  public func neuterDog(dogId : DogId) : async Bool {
    let result = Trie.find(dogs, key(dogId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      switch result {
        case (?dog) {
          let neuteredDog = {
            name = dog.name;
            age = dog.age;
            breed = dog.breed;
            isAdopted = dog.isAdopted;
            isNeutered = true
          };
          dogs := Trie.replace(
            dogs,
            key(dogId),
            Nat32.equal,
            ?neuteredDog
          ).0
        };
        case _ {}
      }
    };
    return exists
  };

  // Function to retrieve shelter statistics such as total, adopted, available, and neutered dogs
  public query func getShelterStats() : async {
    totalDogs : Nat;
    adoptedDogs : Nat;
    availableDogs : Nat;
    neuteredDogs : Nat
  } {
    var totalDogs = 0;
    var adoptedDogs = 0;
    var neuteredDogs = 0;

    for ((id, dog) in Trie.iter(dogs)) {
      totalDogs += 1;
      if (dog.isAdopted) {adoptedDogs += 1};
      if (dog.isNeutered) {neuteredDogs += 1}
    };

    return {
      totalDogs = totalDogs;
      adoptedDogs = adoptedDogs;
      availableDogs = totalDogs - adoptedDogs;
      neuteredDogs = neuteredDogs
    }
  };

  // Private helper function to create keys for Trie operations
  private func key(x : DogId) : Trie.Key<DogId> {
    return {hash = x; key = x}
  }
}
